//
//  RequestmoneyViewController.m
//  Hpay
//
//  Created by ONUR YILMAZ on 21/03/2022.
//  Copyright © 2022 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestmoneyViewController.h"
#import "ZdPickerView.h"
#import "HomeHelperModel.h"
#import "CBPayView.h"
#import "RequestmoneyRouter.h"
#import "NSString+Regular.h"
#import "DecimalUtils.h"
#import "HCToolBar.h"
#import "ApiError.h"
#import "ProductCategoryResponse.h"
#import "HimalayaPayAPIManager.h"
#import "HpayPicker.h"
#import "RequestConfirmationView.h"
#import "QRView.h"
#import "RequestFundModelHelper.h"
#import <SafariServices/SafariServices.h>
#import "WebViewController.h"

@interface RequestmoneyViewController () <UITextViewDelegate>
@property(weak, nonatomic) IBOutlet UIButton *coinTypeBtn;
@property(weak, nonatomic) IBOutlet UILabel *coinNum;
@property(weak, nonatomic) IBOutlet TXLimitedTextField *coinNumTF;
@property(weak, nonatomic) IBOutlet UILabel *coinCodeName;
@property(weak, nonatomic) IBOutlet UIButton *actionButton;
@property(weak, nonatomic) IBOutlet UIView *topHeader;
@property(weak, nonatomic) IBOutlet UIView *inputContainerView;
@property(weak, nonatomic) IBOutlet UIButton *categoryButton;

@property(weak, nonatomic) IBOutlet UILabel *amountRequestLabel;
@property(weak, nonatomic) IBOutlet UILabel *productCategoryLabel;
@property(weak, nonatomic) IBOutlet UILabel *notesLabel;
@property(weak, nonatomic) IBOutlet UIButton *selectAcategoryButton;
@property(weak, nonatomic) IBOutlet UILabel *counterLabel;


@property(strong, nonatomic) NSDictionary *selCoinDic;
@property(strong, nonatomic) NSDictionary *selCatDic;
@property(strong, nonatomic) NSArray *huaZhuanArr;
@property(strong, nonatomic) NSMutableArray *categoriesArr;
@property(strong, nonatomic) RequestmoneyRouter<RequestmoneyRouterInterface> *router;
@property(strong, nonatomic) NSNumberFormatter *numberFormatter;
@property(strong, nonatomic) HCToolBar *toolBar;
@property (weak, nonatomic) IBOutlet UIView *divider1;
@property (weak, nonatomic) IBOutlet UIView *divider2;
@property (weak, nonatomic) IBOutlet UIView *divider3;

@property(nonatomic, assign) NSString *selCatId;
@property(strong, nonatomic) NSString *selCatString;
@property(nonatomic, assign) NSInteger selIndex;
@property(strong, nonatomic) NSString *notesEntered;
@property(nonatomic, assign) NSInteger amountTorequest;

@property(weak, nonatomic) IBOutlet UITextView *notesTextView;
@property(weak, nonatomic) IBOutlet UITextField *amountTextField;
@property(weak, nonatomic) IBOutlet UILabel *currencyLabel;
@property(weak, nonatomic) IBOutlet UILabel *categoryLabel;

@end

@implementation RequestmoneyViewController



- (RequestmoneyRouter<RequestmoneyRouterInterface> *)router {
    if (_router == nil) {
        _router = [[RequestmoneyRouter alloc] init];
        _router.currentControllerDelegate = self;
        _router.navigationDelegate = self.navigationController;
        _router.tabBarControllerDelegate = self.tabBarController;
    }
    return _router;
}

- (NSNumberFormatter*)numberFormatter {
    if (!_numberFormatter) {
        _numberFormatter = [[NSNumberFormatter alloc] init];
        [_numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [_numberFormatter setMinimumFractionDigits:2];
        [_numberFormatter setMaximumFractionDigits:2];
        [_numberFormatter setDecimalSeparator:@"."];
        [_numberFormatter setGroupingSeparator:@""];
        [_numberFormatter setUsesGroupingSeparator:NO];
    }
    return _numberFormatter;
}

#pragma mark - Selected Dictionary Parameters

-(void)updateSelectorLabels:(NSString *)productCategory{
    
    if(productCategory != NULL){
        _categoryButton.titleLabel.text = productCategory;
    }
}

- (nullable NSString *)selectedCryptoCode {
    NSString *cryptoCode = (NSString *)self.selCoinDic[@"CryptoCode"];
    return cryptoCode;
}

- (nullable NSString *)selectedCryptoId {
    NSString *cryptoId = (NSString *)self.selCoinDic[@"CryptoId"];
    return cryptoId;
}

- (nullable NSString *)selectedBalance {
    NSString *balance = (NSString *)self.selCoinDic[@"Balance"];
    return balance;
}

- (nullable NSString *)selectedMinAmount {
    NSString *minAmount = (NSString *)self.selCoinDic[@"MinAmount"];
    return minAmount;
}

- (nullable NSString *)selectedMaxAmount {
    NSString *minAmount = (NSString *)self.selCoinDic[@"MaxAmount"];
    return minAmount;
}

- (nullable NSString *)selectedDecimalPlace {
    NSString *decimalNumberString = (NSString *)self.selCoinDic[@"DecimalPlace"];
    return decimalNumberString;
}

- (NSUInteger)decimalPlaceUInt {
    return [((NSNumber*)self.selCoinDic[@"DecimalPlace"]) unsignedIntValue];
}

#pragma mark  - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViewStateHandlingWithAlignment:kAlignmentFull height:NULL];
    self.navigationItem.title = NSLocalizedDefault(@"request");
    [self.coinTypeBtn setTitle:@"HDR" forState:UIControlStateNormal];
    self.huaZhuanArr = @[];
    self.categoriesArr =@[].mutableCopy;
    self.notesTextView.delegate = self;
    self.coinNumTF.inputAccessoryView = self.toolBar;
    self.coinNumTF.keyboardType = UIKeyboardTypeDecimalPad;
    self.coinNumTF.placeholder = NSLocalizedDefault(@"enter");
    [self.coinNumTF addTarget:self
                       action:@selector(coinFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
    self.amountRequestLabel.text = NSLocalizedDefault(@"amount_to_request");
    self.productCategoryLabel.text = NSLocalizedDefault(@"product_category");
    self.notesLabel.text = NSLocalizedDefault(@"notes");
    [self setupData];
    [self applyTheme];
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    if(self.notesTextView.text.length<=249){
        self.counterLabel.text = [NSString stringWithFormat:@"%d/250", (int)self.notesTextView.text.length];
    }
    else{
        self.notesTextView.text = [self.notesTextView.text substringToIndex:249];
    }
    
}

- (void)applyTheme{
    self.view.backgroundColor = [self getCurrentTheme].background;
    self.topHeader.backgroundColor = [self getCurrentTheme].surface;
    self.inputContainerView.backgroundColor = [self getCurrentTheme].surface;
    [self.coinTypeBtn setTitleColor:[self getCurrentTheme].primaryOnSurface forState:UIControlStateNormal];
    self.coinCodeName.textColor = [self getCurrentTheme].primaryOnSurface;
    self.coinNum.textColor = [self getCurrentTheme].primaryOnSurface;
    self.actionButton.backgroundColor = [self getCurrentTheme].primaryButton;
    self.actionButton.alpha = 0.5;
    self.divider1.backgroundColor = [self getCurrentTheme].verticalDivider;
    self.divider2.backgroundColor = [self getCurrentTheme].verticalDivider;
    self.divider3.backgroundColor = [self getCurrentTheme].verticalDivider;
    [self.categoryButton setTitleColor:[self getCurrentTheme].primaryOnSurface forState:UIControlStateNormal];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self applyTheme];
}

- (void)coinFieldDidChange:(UITextField *)textField{
    NSNumber *isValidNumber = @([self isValidAmount:textField.text] && [self isAmountDecimalNumberValid:textField.text] && ![self.categoryButton.titleLabel.text isEqualToString:@"Select a category"]);
    [self.actionButton setEnabled:[isValidNumber boolValue]];
    [self.actionButton configureBackgroundColorFor:[isValidNumber boolValue]];
}

- (void)productCategoryDidChange{
    NSNumber *isValidNumber = @([self isValidAmount:self.coinNumTF.text] && [self isAmountDecimalNumberValid:self.coinNumTF.text] && ![self.categoryButton.titleLabel.text isEqualToString:@"Select a category"]);
    [self.actionButton setEnabled:[isValidNumber boolValue]];
    [self.actionButton configureBackgroundColorFor:[isValidNumber boolValue]];
}


- (BOOL)isValidAmount:(NSString *)text {
    return (![text isEqualToString:@""] && (text.length > 0));
}

- (BOOL)isAmountDecimalNumberValid:(NSString *)amountText {
    NSDecimalNumber * decimal = [NSDecimalNumber decimalNumberWithString:amountText];
    NSComparisonResult isDecimalZeroComparison = [decimal compare:[NSNumber numberWithDouble:0]];
    return (isDecimalZeroComparison == NSOrderedDescending);
}

#pragma mark - Actions

- (IBAction)coinChooseClick:(id)sender {
    [self.view endEditing:YES];
    if (self.huaZhuanArr.count == 0) {
        return;
    }
    ZdPickerView *picker = [[NSBundle mainBundle] loadNibNamed:@"ZdPickerView" owner:nil options:nil].lastObject;
    picker.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [picker show];
    picker.listArr = self.huaZhuanArr;
    MJWeakSelf
    picker.sureChooseListCoinClick = ^(id _Nonnull listCoin) {
        weakSelf.selCoinDic = listCoin;
        [weakSelf reloadHuazhuanView: listCoin];
    };
    [self.view.window addSubview:picker];
}



- (IBAction)categoryChooseClick:(id)sender {
    [self.view endEditing:YES];
    if (self.categoriesArr.count == 0) {
        return;
    }
    HpayPicker *picker = [[NSBundle mainBundle] loadNibNamed:@"HpayPicker" owner:nil options:nil].lastObject;
    picker.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    NSMutableArray *ARR_ids = [[NSMutableArray alloc] init];
    NSMutableArray *ARR = [[NSMutableArray alloc] init];
    for (int k=0; k<(_categoriesArr.count); k++) {
        [ARR addObject: [_categoriesArr[k] objectForKey:@"CategoryName"]];
        [ARR_ids addObject: [_categoriesArr[k] objectForKey:@"Id"]];
    }
    [picker setDataArr:ARR];
    picker.sureProductCategoryClick = ^(NSInteger selectedIndex, NSString* selectedText) {
        self.selIndex = selectedIndex;
        self.selCatString = selectedText;
        self.selCatId = ARR_ids[selectedIndex];
        [self reloadViews];
        [self productCategoryDidChange];
    };
    [picker show];
    [self.view.window addSubview:picker];
    [picker.pickerView reloadAllComponents];
    
}

- (IBAction)allClick:(id)sender {
    if (self.selCoinDic && self.selectedBalance) {
        self.coinNumTF.text = [NSString stringWithFormat:@"%@", self.selectedBalance];
        [self coinFieldDidChange:self.coinNumTF];
    }
}

- (IBAction)confirmClick:(id)sender {
    if (!self.selCoinDic || !self.selectedBalance || !self.selectedMaxAmount || !self.selectedMinAmount || [NSString textIsEmpty:self.selectedMaxAmount] || [NSString textIsEmpty:self.selectedMinAmount]) {
        return;
    }
    
    NSDecimalNumber *coinNumTFDecimal = [[NSDecimalNumber alloc] initWithString:self.coinNumTF.text];
    NSDecimalNumber *minAmountDecimal = [[NSDecimalNumber alloc] initWithString:self.selectedMinAmount];
    
    NSComparisonResult minAmountComparison = [coinNumTFDecimal compare:minAmountDecimal];
    
    if (minAmountComparison == NSOrderedAscending) {
        [self handleInputError:[NSString stringWithFormat:NSLocalizedDefault(@"min_transfer_amount"), self.selectedMinAmount, self.selectedCryptoCode]];
        return;
    }
    
    [self.coinNumTF resignFirstResponder];
    NSString *amount = [DecimalUtils.shared stringInLocalisedFormatWithInput:self.coinNumTF.text preferredFractionDigits:self.decimalPlaceUInt];
    NSDecimalNumber *amountNumber = [[NSDecimalNumber alloc] initWithString:self.coinNumTF.text];
    RequestConfirmationView *reqConfView = [RequestConfirmationView getPayView:amountNumber amountString:amount productCategory:self.selCatString requestNotes:self.notesTextView.text selectedCategoryId:self.selCatId];
    reqConfView.delegate = self;
    WS(weakSelf);
    [reqConfView showWithType];
    [weakSelf hideKeyboard];
}

- (void)handleInputError:(nonnull NSString *)message {
    [MBHUD showInView:self.view withDetailTitle:message withType:HUDTypeFailWithoutImage];
    [self.coinNumTF becomeFirstResponder];
}

#pragma mark - Helpers

- (void)setupData {
    MJWeakSelf
    [self showLoadingState];
    [HomeHelperModel getCategoriesBlock:^(NSArray *categoriesArr, NSInteger errorCode, NSString *errorMessage) {
        switch(errorCode){
            case kFPNetRequestSuccessCode:{
                [self hideStatefulViewController];
                [weakSelf setCategoriesArr:categoriesArr.mutableCopy];
                weakSelf.selCatDic = categoriesArr.firstObject;
                [weakSelf reloadHuazhuanView: categoriesArr.firstObject];
                break;
            }
            case kFPNetWorkErrorCode:{
                [self showNetworkErrorWithPrimaryButtonTitle:StateViewModel.retryButtonTitle
                                        secondaryButtonTitle:NULL
                                         didTapPrimaryButton:^(id  _Nonnull sender) {
                    [self didTapRefresh:sender];
                } didTapSecondaryButton:NULL];
                break;
            }
            default:{
                [self showNetworkErrorWithPrimaryButtonTitle:StateViewModel.retryButtonTitle
                                        secondaryButtonTitle:NULL
                                         didTapPrimaryButton:^(id  _Nonnull sender) {
                    [self didTapRefresh:sender];
                } didTapSecondaryButton:NULL];
                break;
            }
        }
    }];
    
    [HomeHelperModel getHuaZhuanHomeMsgCompleteBlock:^(NSArray *huazhuanArr, NSInteger errorCode, NSString *errorMessage) {
        switch(errorCode){
            case kFPNetRequestSuccessCode:{
                [self hideStatefulViewController];
                [weakSelf setHuaZhuanArr:huazhuanArr];
                weakSelf.selCoinDic = huazhuanArr.firstObject;
                [weakSelf reloadHuazhuanView: huazhuanArr.firstObject];
                break;
            }
            case kFPNetWorkErrorCode:{
                [self showNetworkErrorWithPrimaryButtonTitle:StateViewModel.retryButtonTitle
                                        secondaryButtonTitle:NULL
                                         didTapPrimaryButton:^(id  _Nonnull sender) {
                    [self didTapRefresh:sender];
                } didTapSecondaryButton:NULL];
                break;
            }
            default:{
                [self showNetworkErrorWithPrimaryButtonTitle:StateViewModel.retryButtonTitle
                                        secondaryButtonTitle:NULL
                                         didTapPrimaryButton:^(id  _Nonnull sender) {
                    [self didTapRefresh:sender];
                } didTapSecondaryButton:NULL];
                break;
            }
        }
    }];
}

-(void)reloadViews{
    
    [self.categoryButton setTitle:self.selCatString forState:UIControlStateNormal];
}

- (void)reloadHuazhuanView:(nonnull NSDictionary *)selCoinDic {
    
    if (!self.selectedBalance || !self.selectedCryptoCode) {
        [self cleanHuaZhuanView];
        return;
    }
    
    [self.coinTypeBtn setTitle:self.selectedCryptoCode forState:UIControlStateNormal];
    self.coinCodeName.text = self.selectedCryptoCode;
    self.coinNumTF.text = @"";
    
    NSString *decimalNumberString = self.selectedDecimalPlace;
    NSInteger decimalNumber = [decimalNumberString intValue];
    [self configureTextFieldDecimalLimitsWith:decimalNumber];
}

- (void)cleanHuaZhuanView {
    [self.coinTypeBtn setTitle:@"" forState:UIControlStateNormal];
    self.coinNum.text = @"";
    self.coinCodeName.text = @"";
    self.coinNumTF.text = @"";
}

- (void)configureTextFieldDecimalLimitsWith:(NSUInteger)decimalNumber {
    self.coinNumTF.limitedSuffix = decimalNumber;
    [self.numberFormatter setMaximumFractionDigits:decimalNumber];
    [self.numberFormatter setMinimumFractionDigits:decimalNumber];
}

//- (void)createHuaZhuanWithPin:(NSString *)pin {
//    [MBHUD showInView:self.view withDetailTitle:nil withType:HUDTypeLoading];
//    NSString *amount = [DecimalUtils.shared stringWithFractionDigitsWithInput:self.coinNumTF.text withExactNumberOfDigits:self.decimalPlaceUInt];
//    WS(weakSelf)
//    [HomeHelperModel creatHuaZhuanOrderWithCryptoId:self.selCoinDic[@"CryptoId"] amount:amount pin:pin CompleteBlock:^(NSDictionary *orderDic, NSInteger errorCode, NSString *errorMessage) {
//        [MBHUD hideInView:weakSelf.view];
//        struct PresentPaySuccessNavigationRequest request;
//        request.orderDictionary = orderDic;
//        request.selCoinDic = weakSelf.selCoinDic;
//        request.amount = weakSelf.coinNumTF.text;
//        
//        if (orderDic && weakSelf.selCoinDic) {
//            [weakSelf.router presentExchangePaySuccessWithRequest:request];
//        } else {
//            [weakSelf handleCreateOrderError:errorCode remoteMessage:errorMessage];
//        }
//        
//    }];
//}

//- (void)handleCreateOrderError:(NSInteger)errorCode remoteMessage:(NSString *)remoteMessage {
//    switch (errorCode) {
//        case kFPNetWorkErrorCode:{
//            [self showNetworkErrorWithPrimaryButtonTitle:StateViewModel.retryButtonTitle
//                                    secondaryButtonTitle:NULL
//                                     didTapPrimaryButton:^(id  _Nonnull sender) {
//                [self didTapRefresh:sender];
//            } didTapSecondaryButton:NULL];
//            return;
//        }
//        default:
//            break;
//    }
//    
//    ApiError* error = [ApiError errorWithCode:errorCode message:remoteMessage];
//    [MBHUD showInView:self.view withDetailTitle:error.prettyMessage withType:HUDTypeError];
//}

- (HCToolBar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[HCToolBar alloc] init];
        MJWeakSelf
        [_toolBar setDidToolBarDoneSelected:^{
            [weakSelf hideKeyboard];
        }];
    }
    return _toolBar;
}

#pragma mark - StatefulViewController actions

- (void)didTapRefresh:(id)sender{
    [self setupData];
}

#pragma mark - RequestConfirmationViewDelegate

- (void)confirmationViewDismissed {
    NSString *cryptoId = [_selCoinDic valueForKey:@"CryptoId"];
    NSString *amount = _coinNumTF.text;
    NSString *notes = _notesTextView.text;
        
    [RequestFundModelHelper createFundRequestWithCryptoId:cryptoId productCategoryId:_selCatId andAmount: amount withNotes:notes completeBlock: ^(NSDictionary *responseModel, NSInteger errorCode, NSString *errorMessage) {
        if (errorCode == kFPNetRequestSuccessCode) {
            QRView *qrView = [[[NSBundle mainBundle] loadNibNamed:@"QRView" owner:self options:nil] lastObject];
            if (qrView) {
                [self.inputContainerView removeFromSuperview];
                qrView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                [qrView configurViewWithItem:responseModel];
                qrView.delegate = self;

                [self.view addSubview:qrView];
            }
        } else {
            [self handleErrorWithErrorCode:errorCode message:errorMessage];
        }
    }];
}

- (void)handleErrorWithErrorCode:(NSInteger)code message:(NSString *)message{
    switch (code) {
        case kFPNetWorkErrorCode:{
            [self showNetworkErrorWithPrimaryButtonTitle:StateViewModel.retryButtonTitle
                                    secondaryButtonTitle:NULL
                                     didTapPrimaryButton:^(id  _Nonnull sender) {
                [self didTapRefresh:sender];
            } didTapSecondaryButton:NULL];
            break;
        }
            
        case kErrorCodeMerchantRestricted: {
            [self.tabBarController showAlertForMerchantRestricted];
            break;
        }
        case kErrorCodeRestrictedCountry: {
            [self.tabBarController showAlertForAccountRestrictedCoutry];
            break;
        }
        default:{
            [self showGenericApiErrorWithPrimaryButtonTitle:StateViewModel.retryButtonTitle
                                       secondaryButtonTitle:NULL didTapPrimaryButton:^(id  _Nonnull sender) {
                [self didTapRefresh:sender];
            } didTapSecondaryButton:NULL];
            break;
        }
    }
}

#pragma mark - QR delegate methods

- (void)doneButtonPressed:(UIButton*)sender {
    [self.navigationController popToRootViewControllerAnimated: true];
}

- (void)shareButtonPressed:(NSString *)linkString :(NSString *)amount :(UIImage *)QRCodeImage {
    HCIdentityUser *user = [GCUserManager manager].user;

    NSString *greatingString = [NSString stringWithFormat: NSLocalizedDefault(@"Dear_Sir"), user.name, amount, linkString];

    if (!QRCodeImage) {
        NSData *stringData = [linkString dataUsingEncoding: NSISOLatin1StringEncoding];
        CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        [qrFilter setValue:stringData forKey:@"inputMessage"];
        CIImage *ciImage = qrFilter.outputImage;
        QRCodeImage = [UIImage imageWithCIImage:ciImage];
    }
    NSArray* sharedObjects = [NSArray arrayWithObjects:greatingString, QRCodeImage,  nil];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:sharedObjects applicationActivities:nil];
    activityViewController.popoverPresentationController.sourceView = self.view;
    [self presentViewController:activityViewController animated:YES completion:nil];
}

-(void)openURLSafari: (NSURL*)URL{
    SFSafariViewController *safariController = [[SFSafariViewController alloc] initWithURL:URL];
    [self.router present:safariController];
}

-(void)openFileInCustomWebView:(NSString*)filePath withName:(NSString*)fileName andType:(NSString*)fileType{
    WebViewController *webView = [[WebViewController alloc] init];
    webView.title = self.title;
    webView.file = filePath;
    webView.filename2save = [NSString stringWithFormat:@"%@.%@", fileName, fileType];
    [self.router pushTo:webView];
}

@end
