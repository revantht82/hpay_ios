//
//  QRView.h
//  Hpay
//
//  Created by Younes Soltan on 12/05/2022.
//  Copyright © 2022 Himalaya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol QRViewDelegate <NSObject>

-(void)shareButtonPressed:(NSString *)linkString :(NSString *)amount :(UIImage *)QRCodeImage;
-(void)doneButtonPressed: (UIButton*)sender;
-(void)openURLSafari: (NSURL*)URL;
-(void)openFileInCustomWebView:(NSString*)filePath withName:(NSString*)fileName andType:(NSString*)fileType;

@end

@interface QRView : UIView

@property(weak, nonatomic) IBOutlet UIImageView *ticketImageView;
@property(weak, nonatomic) IBOutlet UIView *ticketView;
@property(weak, nonatomic) IBOutlet UIImageView *yellowBar;
@property(weak, nonatomic) IBOutlet UIImageView *qrImageView;
@property(weak, nonatomic) IBOutlet UIButton *shareButton;
@property(weak, nonatomic) IBOutlet UIButton *cLinkButton;
@property(weak, nonatomic) IBOutlet UILabel *deepLinkLabel;
@property(weak, nonatomic) IBOutlet UILabel *copiedLabel;
@property(weak, nonatomic) IBOutlet UILabel *cLabel;
@property(weak, nonatomic) IBOutlet UILabel *shareLabel;
@property(weak, nonatomic) IBOutlet UILabel *amountLabel;
@property(weak, nonatomic) IBOutlet UIButton *doneButton;
@property(strong, nonatomic) NSDictionary *responseModel;
@property(nonatomic, assign) id delegate;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UIButton *pLinkButton;
@property (weak, nonatomic) IBOutlet UILabel *pLabel;
@property(strong, nonatomic) NSString *orderId;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *qrLoader;

-(void)configurViewWithItem: (NSDictionary*)responseModel;
-(void)hideFiledsForMyQrCode;

- (IBAction)cLinkPressed:(id)sender;
- (IBAction)sharePressed:(UIButton*)sender;
- (IBAction)donePressed:(UIButton*)sender;
- (IBAction)pLinkPressed:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cLinkButtonVerticalConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cLabelButtonVerticalConstraint;

@end

NS_ASSUME_NONNULL_END
