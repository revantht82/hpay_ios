#import "PayMerchantViewController.h"
#import "DeeplinkHelperModel.h"
#import "HCPayMerchantRouter.h"
#import "AppEnum.h"
#import "HCPaymentCancelResponseModel.h"
#import "DecimalUtils.h"
#import "ApiError.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UIImageView+AFNetworking.h"
#import "ProfileHelperModel.h"
#import "FPKeyBoardManager.h"
#import "AES128.h"
#import "AppDelegate.h"
#import "VerifyPinUseCase.h"

@interface PayMerchantViewController ()

@property(weak, nonatomic) IBOutlet UIImageView *merchantLogoView;
@property(weak, nonatomic) IBOutlet UILabel *merchantNameLabel;
@property(weak, nonatomic) IBOutlet UILabel *availableBalanceValue;
@property(weak, nonatomic) IBOutlet UILabel *availableBalanceTitle;
@property(weak, nonatomic) IBOutlet UILabel *amountValue;
@property(weak, nonatomic) IBOutlet UILabel *amountTitle;
@property(weak, nonatomic) IBOutlet UILabel *noteValue;
@property(weak, nonatomic) IBOutlet UILabel *noteTitle;
@property(weak, nonatomic) IBOutlet UILabel *statusValue;
@property(weak, nonatomic) IBOutlet UILabel *statusTitle;
@property(weak, nonatomic) IBOutlet UILabel *expiryTimeTitle;
@property(weak, nonatomic) IBOutlet UILabel *expiryTimeValue;
@property(weak, nonatomic) IBOutlet UIButton *payButton;
@property(weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (strong, nonatomic) IBOutlet UIView *rootView;
@property (weak, nonatomic) IBOutlet UIStackView *detailsView;

@property(strong, nonatomic) HCPayMerchantRouter<HPPaymentMerchantRouterInterface> *router;
@property(assign, nonatomic) BOOL didRetrieveOrder;
@property(weak, nonatomic) NSTimer *expiryTimer;
@property(strong, nonatomic) VerifyPinUseCase *verifyPinUseCase;
@end

@implementation PayMerchantViewController

- (HCPayMerchantRouter<HPPaymentMerchantRouterInterface> *)router {
    if (_router == nil) {
        _router = [[HCPayMerchantRouter alloc] init];
        _router.currentControllerDelegate = self;
        _router.navigationDelegate = self.navigationController;
        _router.tabBarControllerDelegate = self.tabBarController;
    }
    return _router;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self configureViewStateHandlingWithAlignment:kAlignmentFull
                                           height:NULL];
}

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
    if (!self.orderId) {
        [MBHUD showInView:self.view withDetailTitle:@"empty order id" withType:HUDTypeWarning];
        
        // TODO: show orderId injection warning
        return;
    }
    [self retrieveOrder:self.orderId];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.expiryTimer invalidate];
}


#pragma mark - Retrieve Order
- (void)retrieveOrder:(NSString * _Nonnull)orderId {
    [self showLoading];
    
    struct RetrieveOrderRequest request;
    request.orderId = orderId;
    
    [DeeplinkHelperModel retrieveOrder:request successHandler:^(HCRetrieveOrderResponseModel *response) {
        [self handleResponseWith:response];
    } failureHandler:^(NSInteger code, NSString *message) {
        [self hideLoading];
        [self handleRetrieveFailureWithErrorCode:code andMessage:message];
    }];
}

- (void)handleResponseWith:(HCRetrieveOrderResponseModel *)response {
    _didRetrieveOrder = YES;
    [self hideStatefulViewController];
    [self hideLoading];
    self.payButton.enabled = YES;
    self.cancelButton.enabled = YES;
    
    id<ThemeProtocol> theme = [self getCurrentTheme];
    [self.merchantLogoView setImageWithURLRequestImage:response.logoUrl withTintColor:theme.primaryOnBackground];
    self.merchantNameLabel.text = response.merchantName;
    
    NSString *coinName = response.coinName;
    
    if (!coinName) {
        if (response.coinID == 50) coinName = @"HDO";
        else if (response.coinID == 51) coinName = @"HCN";
    }
    
    self.availableBalanceValue.text = [NSString stringWithFormat:@"%@ %@",
                                       [DecimalUtils.shared stringInLocalisedFormatWithInput:response.availableBalance preferredFractionDigits:response.decimalPlace], coinName];
    self.amountValue.text = [NSString stringWithFormat:@"%@ %@",
                             [DecimalUtils.shared stringInLocalisedFormatWithInput:response.price preferredFractionDigits:response.decimalPlace], coinName];
    self.noteValue.text = response.reference;
    self.statusValue.text = [self stringForPayMerchantStatus:response.status];
    
    [self.expiryTimeValue setHidden:response.status != Pending];
    [self.expiryTimeTitle setHidden:response.status != Pending];
    
    if (response.status == Pending) {
        NSDate *expiryDate = [self dateFromExpiryString:response.paymentExpiryTime];
        self.expiryTimeValue.text = [self formattedExpiryTimeFromDate:expiryDate];
        [self fireExpiryTimerWithDate:expiryDate];
    }
    
    [self setupUIWithPayMerchantStatus:response.status];
}

- (void)fireExpiryTimerWithDate:(NSDate *)date{
    if (date == NULL) {
        return;
    }
    NSTimeInterval secondsFromNow = date.timeIntervalSinceNow;
    if (secondsFromNow > 0) {
        WS(weakSelf);
        self.expiryTimer = [NSTimer scheduledTimerWithTimeInterval:secondsFromNow
                                                           repeats:NO
                                                             block:^(NSTimer * _Nonnull timer) {
            [weakSelf showPaymentExpiryAlert];
        }];
    }
}

- (void)showPaymentExpiryAlert{

    AlertActionItem *gotItAction = [AlertActionItem defaultGotItItemWithHandler:^{
        [self dismissButtonPressed];
    }];
    
    ApiError* error = [ApiError errorWithCode:kErrorCodePaymentExpired message:NULL];
    
    [self showAlertWithTitle:@""
                     message:error.prettyMerchantCreateErrorMessage
                     actions:[NSArray arrayWithObject:gotItAction]];
}

- (NSString *)formattedExpiryTimeFromDate:(NSDate *)date{
    NSDateFormatter *toDateFormatter = [[NSDateFormatter alloc] init];
    [toDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [toDateFormatter stringFromDate:date];
}

- (NSDate *)dateFromExpiryString:(NSString *)dateTimeString{
    NSDateFormatter *fromDateFormatter = [[NSDateFormatter alloc] init];
    [fromDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSSSSz"];
    return [fromDateFormatter dateFromString:dateTimeString];
}

- (void)configureUI {
    // Show empty until data loads from network.
    self.merchantNameLabel.text = @"";
    self.amountValue.text = @"";
    self.noteValue.text = @"";
    self.availableBalanceValue.text = @"";
    self.statusValue.text = @"";
    self.payButton.enabled = NO;
    self.cancelButton.enabled = NO;
    
    self.navigationController.navigationBar.items.firstObject.title = NSLocalizedString(@"pay_merchant.title", comment: @"Screen title on Pay Merchant");
    
    self.availableBalanceTitle.text = NSLocalizedString(@"pay_merchant.available_balance_label", comment: @"Available amount label (title) on Pay Merchant screen");
    self.amountTitle.text = NSLocalizedString(@"amount", comment: @"Amount label (title) on Pay Merchant screen");
    self.noteTitle.text = NSLocalizedString(@"pay_merchant.note_label", comment: @"Note label (title) on Pay Merchant screen");
    self.statusTitle.text = NSLocalizedString(@"pay_merchant.status_label", comment: @"Status label (title) on Pay Merchant screen");
    [self.payButton setTitle:NSLocalizedString(@"pay", comment: @"Title for Pay button on Pay Merchant screen").uppercaseString forState:UIControlStateNormal];
    [self.cancelButton setTitle:NSLocalizedString(@"Cancel", comment: @"Title for Cancel button on Pay Merchant screen").uppercaseString forState:UIControlStateNormal];
    [self configureDismissBarButtonItem];
    [self applyTheme];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self applyTheme];
}

- (void)applyTheme{
    id<ThemeProtocol> theme = [self getCurrentTheme];
    
    _rootView.backgroundColor = theme.background;
    _detailsView.backgroundColor = theme.background;
    
    _merchantLogoView.tintColor = [UIColor whiteColor];
    
    _merchantNameLabel.textColor = theme.primaryOnSurface;
    _amountValue.textColor = theme.primaryOnSurface;
    _availableBalanceValue.textColor = theme.primaryOnSurface;
    _statusValue.textColor = theme.primaryOnSurface;
    _expiryTimeValue.textColor = theme.primaryOnSurface;
    _noteValue.textColor = theme.primaryOnSurface;
    _amountTitle.textColor = theme.secondaryOnSurface;
    _availableBalanceTitle.textColor = theme.secondaryOnSurface;
    _statusTitle.textColor = theme.secondaryOnSurface;
    _expiryTimeTitle.textColor = theme.secondaryOnSurface;
    _noteTitle.textColor = theme.secondaryOnSurface;
    
    [_payButton setBackgroundColor:theme.primaryButton];
    [_cancelButton setBackgroundColor:theme.secondaryButton];
}


-(void)showLoading{
    if (_didRetrieveOrder){
        [MBHUD showInView:self.view withDetailTitle:nil withType:HUDTypeLoading];
    }else{
        [self showLoadingState];
    }
}

-(void)hideLoading{
    [MBHUD hideInView:self.view];
}

#pragma mark - Dismiss Buttons

- (void)configureDismissBarButtonItem {
    self.navigationItem.hidesBackButton = NO;
    UIImage *dismissImage = [UIImage systemImageNamed:@"xmark"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:dismissImage style:UIBarButtonItemStylePlain target:self action:@selector(dismissButtonPressed)];
}

- (void)dismissButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showPINPayKeyboardWithSuccessBlock:(void (^)(NSString *pin))successBlock {

    FPKeyBoardManager *manager = [FPKeyBoardManager new];
    manager.title = NSLocalizedProfile(@"security_verification");
    manager.subTitle = NSLocalizedProfile(@"please_enter_pin");
    WS(weakSelf);
    [manager setKeyBoardCallBack:^(NSString *pwd, FPKeyBoardManager *keyBoard) {
        [MBHUD showInView:[AppDelegate keyWindow] withDetailTitle:nil withType:HUDTypeLoading];
        
        if (!weakSelf.verifyPinUseCase){
            weakSelf.verifyPinUseCase = [[VerifyPinUseCase alloc] init];
        }
        
        [weakSelf.verifyPinUseCase executeWithRequest:pwd completionHandler:^(id  _Nullable response, NSInteger errorCode, NSString * _Nullable errorMessage) {
            [MBHUD hideInView:[AppDelegate keyWindow]];
            [keyBoard hideKeyBoard];
            if (response) {
                successBlock(pwd);
            } else {
                [keyBoard clear];
                switch (errorCode) {
                    case kErrorCodeVerifyPinCheck:
                        [MBHUD showInView:[AppDelegate keyWindow] withDetailTitle:errorMessage withType:HUDTypeFailWithoutImage];
                        break;
                    default:
                        [weakSelf handleErrorWithReason:errorCode];
                        break;
                }
            }
        }];
        
    }];
    [manager setKeyBoardCloseCallBack:^{
        
    }];
    [manager showKeyBoard];
}

#pragma mark - Actions

- (IBAction)payButtonPressed:(UIButton *)sender {
    [self showPINPayKeyboardWithSuccessBlock:^(NSString *pin) {
        [self executePayment];
    }];
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    AlertActionItem *dismissItem = [AlertActionItem defaultDismissItem];
    
    AlertActionItem *confirmItem = [AlertActionItem actionWithTitle:NSLocalizedProfile(@"confirm")
                                                              style:AlertActionStyleDefault
                                                            handler:^{
        [self performCancel];
    }];
    
    [self showAlertWithTitle:NSLocalizedString(@"pay_merchant.cancel_alert.title", @"Cancel confirmation title on Pay Merchant screen")
                     message:NSLocalizedString(@"pay_merchant.cancel_alert.message", @"Cancel confirmation message on Pay Merchant screen")
                     actions:[NSArray arrayWithObjects:dismissItem, confirmItem, nil]];
}

- (void)performCancel{
    [self showLoading];
    struct PaymentCancelRequest request;
    request.orderId = self.orderId;
    
    [DeeplinkHelperModel paymentCancel:request successHandler:^(HCPaymentCancelResponseModel *response) {
        [self hideLoading];
        [self hideStatefulViewController];
        
        if (response.status == Cancelled) {
            [self handlePaymentCancelSuccess];
        } else {
            [self showAlertForUnknownError];
        }
    } failureHandler:^(NSInteger code, NSString *message) {
        [self hideLoading];
        [self handlePaymentCancelFailureWithErrorCode:code andMessage:message];
    }];
}

#pragma mark - Helpers

- (void)executePayment{
    [self showLoading];
    struct PaymentCreateRequest request;
    request.orderId = self.orderId;
    
    [DeeplinkHelperModel paymentCreate:request successHandler:^(HCPaymentCreateResponseModel * _Nonnull response) {
        [self hideLoading];
        [self hideStatefulViewController];
        
        struct PayMerchantStatusNavigationRequest request;
        request.paymantResponse = response;
        
        [self.router pushToPayMerchantStatusWithRequest:request];
        
        // Post coin balance changed notification so listeners (Home) refresh data.
        [[NSNotificationCenter defaultCenter] postNotificationName:kCoinBalanceChangedNotification object:nil];
        
    } failureHandler:^(NSInteger code, NSString * _Nullable message) {
        [self hideLoading];
        [self handlePaymentFailureWithErrorCode:code andMessage:message];
    }];
}

- (void)handlePaymentCancelSuccess {
    AlertActionItem *gotItAction = [AlertActionItem defaultGotItItemWithHandler:^{
        [self dismissButtonPressed];
    }];
    
    [self showAlertWithTitle:NSLocalizedString(@"pay_merchant.cancel_successful_alert.title", @"")
                     message:NSLocalizedString(@"pay_merchant.cancel_successful_alert.message", @"")
                     actions:[NSArray arrayWithObject:gotItAction]];
}

- (void)handlePaymentCancelFailureWithErrorCode:(NSInteger)errorCode andMessage:(NSString*)message {
    
    switch (errorCode) {
        case kFPNetWorkErrorCode:{
            [self showNetworkErrorWithPrimaryButtonTitle:StateViewModel.retryButtonTitle
                                    secondaryButtonTitle:NULL
                                     didTapPrimaryButton:^(id  _Nonnull sender) {
                [self didTapRefresh:sender];
            } didTapSecondaryButton:NULL];
            return;
        }
        case kErrorCodeMerchantRestricted: {
            [self.tabBarController showAlertForMerchantRestricted];
            break;
        }
        case kErrorCodeRestrictedCountry: {
            [self.tabBarController showAlertForAccountRestrictedCoutry];
            break;
        }
        default: {
            AlertActionItem *gotItAction = [AlertActionItem defaultGotItItemWithHandler:^{
                [self dismissButtonPressed];
            }];
            
            ApiError* error = [ApiError errorWithCode:errorCode message:NULL];
            
            [self showAlertWithTitle:error.prettyMerchantCancelErrorTitle
                             message:error.prettyMerchantCancelErrorMessage
                             actions:[NSArray arrayWithObject:gotItAction]];
            break;
        }
    }
}

- (void)handlePaymentFailureWithErrorCode:(NSInteger)code andMessage:(NSString*)message {
    NSArray<AlertActionItem*>* actionItems;
    
    switch (code) {
        case kFPNetRequestServerErrorCode:
        case kFPNetWorkErrorCode:
        case kErrorCodeUserAccountSuspended:
        case kErrorCodeMaxPinAttemptExceeded:{
            [self handleErrorWithReason:code];
            return;
        }
        case kErrorCodePaymentInsufficientBalance:{
            AlertActionItem *dismissItem = [AlertActionItem defaultDismissItem];
            actionItems = [NSArray arrayWithObject:dismissItem];
            break;
        }
        case kErrorCodeMerchantRestricted: {
            [self.tabBarController showAlertForMerchantRestricted];
            break;
        }
        default:{
            AlertActionItem *gotItItem = [AlertActionItem defaultGotItItemWithHandler:^{
                [self dismissButtonPressed];
            }];
            actionItems = [NSArray arrayWithObject:gotItItem];
            break;
        }
    }
    
    ApiError* error = [ApiError errorWithCode:code message:message];
    
    [self showAlertWithTitle:error.prettyMerchantCreateErrorTitle
                     message:error.prettyMerchantCreateErrorMessage
                     actions:actionItems];
}

- (void)handleErrorWithReason:(NSInteger)errorCode {
    switch (errorCode) {
        case kFPNetWorkErrorCode:{
            [self showNetworkErrorWithPrimaryButtonTitle:StateViewModel.refreshButtonTitle
                                    secondaryButtonTitle:NULL
                                     didTapPrimaryButton:^(id  _Nonnull sender) {
                [self didTapRefresh:sender];
            } didTapSecondaryButton:^(id  _Nonnull sender) {
                [self didTapDismiss:sender];
            }];
            break;
        }
        case kErrorCodePaymentOrderNotFound:{
            [self showCustomErrorWithViewModel:StateViewModel.orderNotFoundErrorModel
                            primaryButtonTitle:StateViewModel.dismissButtonTitle
                          secondaryButtonTitle:NULL
                           didTapPrimaryButton:^(id  _Nonnull sender) {
                [self didTapDismiss:sender];
            } didTapSecondaryButton:NULL];
            break;
        }
        case kErrorCodeInvalidKYC:{
            [self showCustomErrorWithViewModel:StateViewModel.invalidKYCErrorModel
                            primaryButtonTitle:StateViewModel.dismissButtonTitle
                          secondaryButtonTitle:NULL
                           didTapPrimaryButton:^(id  _Nonnull sender) {
                [self didTapDismiss:sender];
            } didTapSecondaryButton:NULL];
            break;
        }
        case kErrorCodeUserAccountSuspended:{
            [self showCustomErrorWithViewModel:StateViewModel.userAccountSuspended
                            primaryButtonTitle:StateViewModel.refreshButtonTitle.capitalizedString
                          secondaryButtonTitle:StateViewModel.dismissButtonTitle
                           didTapPrimaryButton:^(id  _Nonnull sender) {
                [self didTapRefresh:sender];
            } didTapSecondaryButton:^(id  _Nonnull sender) {
                [self didTapDismiss:sender];
            }];
            break;
        }
        case kErrorCodeMaxPinAttemptExceeded:{
            [self showCustomErrorWithViewModel:StateViewModel.pinAttemptExceeded
                            primaryButtonTitle:StateViewModel.refreshButtonTitle.capitalizedString
                          secondaryButtonTitle:StateViewModel.dismissButtonTitle
                           didTapPrimaryButton:^(id  _Nonnull sender) {
                [self didTapRefresh:sender];
            } didTapSecondaryButton:^(id  _Nonnull sender) {
                [self didTapDismiss:sender];
            }];
            break;
        }
        case kErrorCodeMerchantRestricted: {
            
            [self showAlertWithTitle:@""
                             message:NSLocalizedString(@"merchant_is_restricted", @"")];
            break;
        }
        case kErrorCodeRestrictedCountry: {
            
            [self showAlertWithTitle:@""
                             message:NSLocalizedString(@"your_account_is_not_located", @"")];
            break;
        }
        default:{
            [self showGenericApiErrorWithPrimaryButtonTitle:StateViewModel.refreshButtonTitle
                                       secondaryButtonTitle:StateViewModel.dismissButtonTitle
                                        didTapPrimaryButton:^(id  _Nonnull sender) {
                [self didTapRefresh:sender];
            } didTapSecondaryButton:^(id  _Nonnull sender) {
                [self didTapDismiss:sender];
            }];
            break;
        }
    }
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"okay", @"")
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController dismissViewControllerAnimated:true completion:nil];
        
    }];
    [alertController addAction:alertAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)handleRetrieveFailureWithErrorCode:(NSInteger)code andMessage:(NSString*)message {
    [self handleErrorWithReason:code];
}

- (NSString*)stringForPayMerchantStatus:(TransactionStatusType)status {
    switch (status) {
        case Pending:
            return NSLocalizedString(@"pay_merchant_status.pending", @"");
        case Cancelled:
            return NSLocalizedString(@"pay_merchant_status.cancelled", @"");
        case Complete:
            return NSLocalizedString(@"completed", @"");
        case Reversed:
            return NSLocalizedString(@"reversed", @"");
        case Expired:
            return NSLocalizedString(@"pay_merchant_status.expired", @"");
        case Failed:
            return NSLocalizedString(@"pay_merchant_status.failed", @"");
    }
}

- (void)setupUIWithPayMerchantStatus:(TransactionStatusType)status {
    BOOL showPayButton = YES, showCancelButton = YES;
    switch (status) {
        case Pending:
            showPayButton = YES;
            showCancelButton = YES;
            break;
        case Cancelled:
        case Reversed:
        case Expired:
        case Complete:
        case Failed:
            showPayButton = NO;
            showCancelButton = NO;
            break;
    }
    
    self.payButton.hidden = !showPayButton;
    self.cancelButton.hidden = !showCancelButton;
}

#pragma mark - PayMerchantViewControllerDelegate

- (void)recoveredWithRetrieveOrderResponseModel:(HCRetrieveOrderResponseModel *)model {
    [self handleResponseWith:model];
}

- (void)dismissFlow {
    [self.presentedViewController dismissViewControllerAnimated:NO completion:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark - StatefulViewController actions

- (void)didTapRefresh:(id)sender{
    [self retrieveOrder:self.orderId];
}

- (void)didTapDismiss:(id)sender{
    [self dismissButtonPressed];
}

@end
