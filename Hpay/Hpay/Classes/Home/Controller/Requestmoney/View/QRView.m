//
//  QRView.m
//  Hpay
//
//  Created by Younes Soltan on 12/05/2022.
//  Copyright © 2022 Himalaya. All rights reserved.
//

#import "QRView.h"
#import "DecimalUtils.h"
#import "HimalayaAuthKeychainManager.h"
#import "HimalayaPayAPIManager.h"
#import "WebViewController.h"

@implementation QRView

-(void)configurViewWithItem: (NSDictionary*)responseModel {
    _responseModel = responseModel;
    NSString *cryptoCode = responseModel[@"CoinName"];
    NSString *amount = [responseModel valueForKey:@"Amount"];
    NSUInteger decimalPlaceUInt = [cryptoCode isEqualToString:@"HDO"] || [cryptoCode isEqualToString:@"HEU"]? 2 : 3;
    
    if (responseModel && [responseModel valueForKey:@"TransactionId"] && ![[responseModel valueForKey:@"TransactionId"] isEqualToString:@""]) {
        _orderId = responseModel[@"TransactionId"];
    }
    else {
        NSArray* URLparts = [[responseModel valueForKey:@"DeepLink"] componentsSeparatedByString:@"?"];
        if ([URLparts count] > 1){
            NSString *URL = URLparts[1];
            for (NSString *param in [URL componentsSeparatedByString:@"&"]) {
                NSArray *elts = [param componentsSeparatedByString:@"="];
                
                if([elts count] < 2) continue;
                
                if ([elts[0] isEqualToString:@"OrderId"]){
                    _orderId = elts[1];
                    NSLog(@"%@", _orderId);
                }
            }
        }
    }
    
    NSString *formattedAmount = [DecimalUtils.shared stringInLocalisedFormatWithInput: amount preferredFractionDigits:decimalPlaceUInt];
    
    [self createQR:[responseModel valueForKey:@"DeepLink"]];
    [self initLinkLabel:[responseModel valueForKey:@"DeepLink"]];
    [self initAmountLabelwithAmout:formattedAmount andCoinName:[responseModel valueForKey:@"CoinName"]];
    [_cLinkButton setTitle:@"" forState:UIControlStateNormal];
    [_pLinkButton setTitle:@"" forState:UIControlStateNormal];
    [_shareButton setTitle:@"" forState:UIControlStateNormal];
    [self applyTheme];
    self.topLabel.text = NSLocalizedString(@"RequestSuccessful", comment:nil);
}

-(void)hideFiledsForMyQrCode {
    self.topLabel.hidden = NO;
    self.topLabel.text = NSLocalizedString(@"my_qr_title", comment:nil);
    
    NSError *error;
    UserConfigResponse *userConfig = [HimalayaAuthKeychainManager loadUserConfigToKeychain:&error];
    
    if (!error && userConfig.nickname && ![userConfig.nickname isEqualToString:@""] ) {
        self.amountLabel.hidden = NO;
        self.amountLabel.text = [NSString stringWithFormat:@"@%@", userConfig.nickname];
        self.amountLabel.font = [self.amountLabel.font fontWithSize:15];
    }
    else {
        self.amountLabel.hidden = YES;
    }

    self.deepLinkLabel.hidden = YES;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [self applyTheme];
}

- (void)applyTheme {
    id<ThemeProtocol> theme = [self getCurrentTheme];
    self.backgroundColor = theme.background;
    NSString *ticketViewImageName = theme.getImageNameForTicket;
    _ticketImageView.image = [UIImage imageNamed:ticketViewImageName];
    NSString *shareImageName = theme.getImageNameForShare;
    [_shareButton setBackgroundImage:nil forState:UIControlStateNormal];
    [_shareButton setBackgroundImage:[UIImage imageNamed:shareImageName] forState:UIControlStateNormal];
    
    NSString *cLinkImageName = theme.getImageNameForcLink;
    UIImage *cLinkImage = [UIImage imageNamed:cLinkImageName];
    [_cLinkButton setBackgroundImage:nil forState:UIControlStateNormal];
    [_cLinkButton setBackgroundImage:cLinkImage forState:UIControlStateNormal];
    
    _pLinkButton.tintColor = theme.primaryOnBackground;
    
    _cLabel.textColor = theme.secondaryOnSurface;
    _shareLabel.textColor = theme.secondaryOnSurface;
    _pLabel.textColor = theme.secondaryOnSurface;
    _amountLabel.textColor = theme.primaryOnSurface;
    _doneButton.backgroundColor = theme.surface;
    [_doneButton setTitleColor:theme.primaryOnSurface forState:UIControlStateNormal];
}

-(void)createQR:(NSString*)urlString {
    
    NSData *stringData = [urlString dataUsingEncoding: NSUTF8StringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    
    CIImage *qrImage = qrFilter.outputImage;
    float scaleX = _qrImageView.frame.size.width / qrImage.extent.size.width;
    float scaleY = self.qrImageView.frame.size.height / qrImage.extent.size.height;
    
    qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
    
    self.qrImageView.image = [UIImage imageWithCIImage:qrImage
                                                 scale:[UIScreen mainScreen].scale
                                           orientation:UIImageOrientationUp];
    
    //[MBHUD showInView:self withDetailTitle:nil withType:HUDTypeLoading];
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    mDict[@"link"] =  urlString;
    
    //self.qrLoader.color = [UIColor yellowColor];
    [self.qrLoader startAnimating];
    self.qrImageView.alpha = 0.1;
    
    [HimalayaPayAPIManager GET:kGetQRCodeImageURL parameters:mDict successBlock:^(NSObject *_Nullable data, NSObject *_Nullable extension, NSString *_Nullable message) {
        
        NSDictionary *dict = (NSDictionary *) data;
        NSString *imageString = dict[@"qrImage"];
        
        NSData *imageData = [[NSData alloc]initWithBase64EncodedString:imageString options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        UIImage *image = [UIImage imageWithData:imageData];
        
        if (image){
            self.qrImageView.image = image;
        }
        
        [self showQRCodeWithAnimation];
        
        //[MBHUD hideInView:self];
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        [self showQRCodeWithAnimation];
        //[MBHUD hideInView:self];
//        [self->_delegate showAlertWithTitle:NSLocalizedString(@"pay_merchant_refresh.backend_error.title_label", nil)
//                         message:NSLocalizedString(@"unexpected_error", nil)
//                        actions:[NSArray arrayWithObjects:[AlertActionItem defaultDismissItem], nil]];
    }];
}

-(void) showQRCodeWithAnimation {
    [self.qrLoader stopAnimating];
    
    [UIView animateWithDuration:0.2f animations:^{
        self.qrImageView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)initLinkLabel: (NSString*)urlString {
    _deepLinkLabel.text = urlString;
}

-(void)initAmountLabelwithAmout:(NSString*)amount andCoinName:(NSString*)coinName {
    _amountLabel.textColor = [self getCurrentTheme].primaryOnSurface;
    
    NSDictionary *amountAttr = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:32.0f]};
    NSMutableAttributedString *amountString = [[NSMutableAttributedString alloc] initWithString:amount attributes:amountAttr];
    
    NSDictionary *coinAttr = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]};
    NSAttributedString *coinString = [[NSMutableAttributedString alloc] initWithString:coinName attributes:coinAttr];
    
    [amountString appendAttributedString:coinString];
    _amountLabel.attributedText = amountString;
}

- (IBAction)cLinkPressed:(id)sender {
    [_copiedLabel setHidden:false];
    [NSTimer scheduledTimerWithTimeInterval:3
                                    repeats:NO
                                      block:^(NSTimer * _Nonnull timer) {
        [self.copiedLabel setHidden:true];
    }];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *deepLink = _deepLinkLabel.text;
    [pasteboard setString:deepLink];
}

- (IBAction)sharePressed:(UIButton*)sender {
    NSString *amount = [_responseModel valueForKey:@"Amount"];
    NSString *cryptoCode = _responseModel[@"CoinName"];
    NSUInteger decimalPlaceUInt = [cryptoCode isEqualToString:@"HDO"] || [cryptoCode isEqualToString:@"HEU"]? 2 : 3;
    NSString *formattedAmount = [DecimalUtils.shared stringInLocalisedFormatWithInput:amount preferredFractionDigits:decimalPlaceUInt];
    formattedAmount = [formattedAmount stringByAppendingString:@" "];
    formattedAmount = [formattedAmount stringByAppendingString:cryptoCode];
    
    
    [self->_delegate shareButtonPressed: _deepLinkLabel.text: formattedAmount :self.qrImageView.image];
    
}

- (IBAction)pLinkPressed:(id)sender {
    [MBHUD showInView:self withDetailTitle:nil withType:HUDTypeLoading];
    _pLinkButton.enabled = NO;
    NSString *urlStr = PrintQRURL;
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    
    NSLog(@"%@", _orderId);
    if (_orderId) {
        mDict[@"orderId"] = _orderId;
    }
    
    [HimalayaPayAPIManager GET:urlStr parameters:mDict successBlock:^(NSObject *_Nullable data, NSObject *_Nullable extension, NSString *_Nullable message) {
        
        NSDictionary *dict = (NSDictionary *) data;
        NSString *filePath = dict[@"filePath"];
        NSURL *exportURL = [NSURL URLWithString:filePath];
        
        if (dict[@"fileName"] && dict[@"fileType"]) {
            [self->_delegate openFileInCustomWebView:dict[@"filePath"] withName:dict[@"fileName"] andType:dict[@"fileType"]];
        } else if ([self->_delegate respondsToSelector:@selector(openURLSafari:)]) {
            [self->_delegate openURLSafari:exportURL];
        } else {
            [self->_delegate showAlertWithTitle:NSLocalizedString(@"pay_merchant_refresh.backend_error.title_label", nil)
                             message:NSLocalizedString(@"unexpected_error", nil)
                            actions:[NSArray arrayWithObjects:[AlertActionItem defaultDismissItem], nil]];
        }
        
        self->_pLinkButton.enabled = YES;
        [MBHUD hideInView:self];
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        
        self->_pLinkButton.enabled = YES;
        [MBHUD hideInView:self];
        [self->_delegate showAlertWithTitle:NSLocalizedString(@"pay_merchant_refresh.backend_error.title_label", nil)
                         message:NSLocalizedString(@"unexpected_error", nil)
                        actions:[NSArray arrayWithObjects:[AlertActionItem defaultDismissItem], nil]];
    }];
}

- (IBAction)donePressed:(UIButton*)sender {
    if ([self->_delegate respondsToSelector:@selector(doneButtonPressed:)]) {
        [self->_delegate doneButtonPressed:sender];
    }
}

@end




