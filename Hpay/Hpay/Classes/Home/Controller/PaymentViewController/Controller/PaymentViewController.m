    #import "PaymentViewController.h"
    #import "FPSecurityAuthManager.h"
    #import "HomeHelperModel.h"
    #import "DecimalUtils.h"
    #import "ApiError.h"

    @interface PaymentViewController ()

    @property(weak, nonatomic) IBOutlet UIButton *confirmBtn;
    @property(weak, nonatomic) IBOutlet UIButton *cancelBtn;
    @property(weak, nonatomic) IBOutlet UIButton *topupBtn;

    @property(weak, nonatomic) IBOutlet UILabel *topLabel;
    @property(weak, nonatomic) IBOutlet UILabel *titleLabel;
    @property(weak, nonatomic) IBOutlet UILabel *nameLabel;
    @property(weak, nonatomic) IBOutlet UILabel *nameValueLabel;
    @property(weak, nonatomic) IBOutlet UILabel *coinLabel;
    @property(weak, nonatomic) IBOutlet UILabel *coinValueLabel;
    @property(weak, nonatomic) IBOutlet UILabel *otherLabel;
    @property(weak, nonatomic) IBOutlet UILabel *otherValueLabel;

    @property(weak, nonatomic) IBOutlet UIView *topupBGView;
    @property(weak, nonatomic) IBOutlet UIView *otherView;

    @property(weak, nonatomic) IBOutlet UIView *bottomSheetView;
    @property(weak, nonatomic) IBOutlet UIButton *bottomSheetCloseButton;
    @property(weak, nonatomic) IBOutlet UIView *divider1;
    @property(weak, nonatomic) IBOutlet UIView *divider2;
    @property(weak, nonatomic) IBOutlet UIView *divider3;
    @property(weak, nonatomic) IBOutlet UIView *divider4;


    @end

    @implementation PaymentViewController

    - (void)viewDidLoad {
        [super viewDidLoad];
        [self initUI];
        [self addNotification];
        [self applyTheme];
    }

    - (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
        [self applyTheme];
    }

    - (void)addNotification {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(close:) name:kPinInputErrorFiveTimesNotification object:nil];
        // Add observer to detect app entering the background
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }

    - (void)initUI {
        [self.confirmBtn setTitle:self.confirmBtn.titleLabel.text.localizedUppercaseString forState:UIControlStateNormal];
        self.confirmBtn.hidden = NO;
        self.topupBGView.hidden = YES;
        self.otherView.hidden = YES;
        switch (self.paymentType) {
            case FPPaymentTypeNormal:
            case FPPaymentTypeWithScanQRCode:
                self.topLabel.text = NSLocalizedHome(@"my_qr_title");
                
                break;
            case FPPaymentTypeWithGatewayOrderQRCode: {
                self.topLabel.text = NSLocalizedHome(@"payment_confirmation");
                self.nameLabel.text = NSLocalizedHome(@"shop_name");
                self.coinLabel.text = NSLocalizedHome(@"payment_crypto");
                
                self.titleLabel.text = [NSString stringWithFormat:@"%@ %@", self.dataDict[@"CryptoCode"], self.dataDict[@"CryptoAmount"]];
                self.nameValueLabel.text = [NSString stringWithFormat:@"%@", self.dataDict[@"MerchantName"]];
                self.coinValueLabel.text = [NSString stringWithFormat:@"%@", self.dataDict[@"CryptoCode"]];
                
                // Because this type is pushed in the background, we need to compare whether the balance is enough here first
                // Other types are restricted at the front desk
                NSString *amount = [NSString stringWithFormat:@"%@", [self.dataDict valueForKey:@"CryptoAmount"]];
                NSString *balance = [NSString stringWithFormat:@"%@", [self.dataDict valueForKey:@"Balance"]];
                NSDecimalNumber *amountNumber = [NSDecimalNumber decimalNumberWithString:amount];
                NSDecimalNumber *balanceNumber = [NSDecimalNumber decimalNumberWithString:balance];
                NSComparisonResult result = [balanceNumber compare:amountNumber];
                if (result == NSOrderedAscending) {
                    [self lackBalance];
                }
            }
                break;
            case FPPaymentTypeWithdrawal: {
                self.nameLabel.text = NSLocalizedHome(@"shop_name");
                self.coinLabel.text = NSLocalizedHome(@"payment_crypto");
            }
                break;
            case FPPaymentTypeWithtransfer: {
                NSString *reference = self.dataDict[@"Reference"];
                if ([reference length] > 0) {
                    self.otherView.hidden = NO;
                    self.otherLabel.text = NSLocalizedString(@"note", @"Note label title on Send review screen");
                    self.otherValueLabel.text = reference;
                }

                self.topLabel.text = NSLocalizedString(@"review_details", "Payment Review Title Text");
                self.titleLabel.hidden = YES;
                
                if (self.dataDict[@"Receivers"]){
                    self.nameLabel.text = NSLocalizedHome(@"received_amount_group");
                } else {
                    self.nameLabel.text = NSLocalizedHome(@"received_amount");
                }
                
                if (self.dataDict[@"Receivers"]){
                    self.coinLabel.text = NSLocalizedHome(@"receiver_account_group");
                } else {
                    self.coinLabel.text = NSLocalizedHome(@"receiver_account");
                }
                
                
                NSUInteger digits = [((NSNumber*)self.dataDict[@"CoinDecimalPlace"]) unsignedIntValue];
                self.nameValueLabel.text = [NSString stringWithFormat:@"%@ %@",
                                            [DecimalUtils.shared stringInLocalisedFormatWithInput:self.dataDict[@"Amount"] preferredFractionDigits:digits],
                                            self.dataDict[@"CoinCode"]];
                self.nameValueLabel.adjustsFontSizeToFitWidth = YES;
                self.coinValueLabel.text = self.dataDict[@"Account"];
            }
                break;
            case FPPaymentTypeBlueTooth: {
                self.topLabel.text = NSLocalizedHome(@"payment_confirmation");
                self.nameLabel.text = NSLocalizedHome(@"shop_name");
                self.coinLabel.text = NSLocalizedHome(@"payment_crypto");
                self.titleLabel.text = [NSString stringWithFormat:@"%@ %@", self.dataDict[@"Currency"], self.dataDict[@"Amount"]];
                self.nameValueLabel.text = [NSString stringWithFormat:@"%@", self.dataDict[@"MerchantName"]];
                self.coinValueLabel.text = [NSString stringWithFormat:@"%@", self.dataDict[@"Currency"]];
            }
                break;
            default:
                break;
        }
    }

    - (void)applyTheme{
        id<ThemeProtocol> theme = [self getCurrentTheme];
        _bottomSheetCloseButton.tintColor = theme.primaryOnSurface;
        _bottomSheetView.backgroundColor = theme.surface;
        _topLabel.textColor = theme.primaryOnSurface;
        _titleLabel.textColor = theme.primaryOnSurface;
        _divider1.backgroundColor = theme.verticalDivider;
        _divider2.backgroundColor = theme.verticalDivider;
        _divider3.backgroundColor = theme.verticalDivider;
        _divider4.backgroundColor = theme.verticalDivider;
        _nameLabel.textColor = theme.secondaryOnSurface;
        _nameValueLabel.textColor = theme.primaryOnSurface;
        _coinLabel.textColor = theme.secondaryOnSurface;
        _coinValueLabel.textColor = theme.primaryOnSurface;
        _otherLabel.textColor = theme.secondaryOnSurface;
        _otherValueLabel.textColor = theme.primaryOnSurface;
        _topupBtn.backgroundColor = theme.primaryButtonOnSurface;
    }

    #pragma mark -- Action

    - (IBAction)close:(id)sender {
        if (self.clickBlock) {
            self.clickBlock(FPPaymentClickCloseType, nil);
        } else {
            [self dismiss:NULL];
        }
    }

    - (IBAction)confirm:(id)sender {
        switch (self.paymentType) {
            case FPPaymentTypeNormal:
            case FPPaymentTypeWithGatewayOrderQRCode: {
                [self payment];
            }
                break;
            case FPPaymentTypeWithdrawal: {
                
            }
                break;
            case FPPaymentTypeWithtransfer: {
                [self transfer];
            }
                break;
            case FPPaymentTypeBlueTooth:
            case FPPaymentTypeWithScanQRCode: {
                break;
            }
                break;
            default:
                break;
        }
    }

    - (IBAction)cancel:(id)sender {
        if (self.clickBlock) {
            self.clickBlock(FPPaymentClickCancelType, nil);
        } else {
            [self dismiss:NULL];
        }
    }

    - (IBAction)topup:(id)sender {
        if (self.clickBlock) {
            self.clickBlock(FPPaymentClickTopupType, nil);
        } else {
            [self dismiss:NULL];
        }
    }

    - (void)dismiss:(void (^ __nullable)(void))completion {
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.0];
        [self dismissViewControllerAnimated:YES completion:completion];
    }

    - (void)applicationEnterBackground {
        /// Whether to start the local lock screen password unlock
        BOOL isOpenLockScreenAuth = [[[NSUserDefaults standardUserDefaults] objectForKey:kisOpenPasswordUnlockKey] boolValue];
        
        if (isOpenLockScreenAuth) {
            [self close:nil];
        }
    }

    #pragma mark - Publish

    - (void)lackBalance {
        [MBHUD showInView:self.view withDetailTitle:NSLocalizedHome(@"insufficient_balance") withType:HUDTypeError];
        self.confirmBtn.hidden = YES;
        self.topupBGView.hidden = NO;
    }

    - (void)setDataDict:(NSDictionary *)dataDict {
        _dataDict = dataDict;
    }

    #pragma mark - Payment

    - (void)payment {
        if ((self.dataDict && self.dataDict[@"Id"])) {
            FPSecurityAuthManager *authManager = [[FPSecurityAuthManager alloc] init];
            [authManager securityAuth];
            [authManager setSecurityAuthSuccessBlock:^(NSString *securityPssaword) {
                [MBHUD showInView:self.view withTitle:nil withType:HUDTypeLoading];
                [HomeHelperModel payExistedOrder:self.dataDict[@"Id"] Pin:securityPssaword type:self.paymentType completeBlock:^(FPOrderDetailModel *model, NSInteger errorCode, NSString *errorMessage) {
                    [MBHUD hideInView:self.view];
                    if (model && errorCode == kFPNetRequestSuccessCode) {
                        if (self.clickBlock) {
                            self.clickBlock(FPPaymentClickSuccessType, model);
                        }
                    } else {
                        [self.navigationController popToRootViewControllerAnimated:NO];
                        [self payErrorHandlerWithErrorCode:errorCode errorMessage:errorMessage];
                    }
                    
                }];
                
            }];
        }
    }

    - (void)payErrorHandlerWithErrorCode:(NSInteger)errorCode errorMessage:(NSString *)remoteMessage {
        
        //ApiError *error = [ApiError errorWithCode:errorCode message:remoteMessage];
        //[MBHUD showInView:self.view withDetailTitle:error.prettyMessage withType:HUDTypeError];
        
        switch (errorCode) {
            case kFPNetWorkErrorCode:{
                [self showNetworkErrorWithPrimaryButtonTitle:StateViewModel.retryButtonTitle
                                        secondaryButtonTitle:NULL
                                         didTapPrimaryButton:^(id  _Nonnull sender) {
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
            case kErrorCodeAccountRestrictedToRecieve: {
                [self.tabBarController showAlertForRestrictedToRecieve];
                break;
            }
            case kErrorCodeReciverAccountInRestrictedCoutry: {
                [self.tabBarController showAlertForRecieverInRestrictedCoutry];
                break;
            }
            case kFPLackofBalanceCode: {
                [MBHUD showInView:self.view withDetailTitle:NSLocalizedHome(@"insufficient_balance") withType:HUDTypeError];
                break;
            }
                
            default: {
                ApiError *error = [ApiError errorWithCode:errorCode message:remoteMessage];
                [MBHUD showInView:self.view withDetailTitle:error.prettyMessage withType:HUDTypeError];
                break;
            }
        }
    }

    #pragma mark - Transfer
    
    - (void)transfer {
        if (self.dataDict) {
            
            if (self.dataDict[@"Receivers"]){
                [self groupTransfer];
                return;
            }
            
            FPSecurityAuthManager *authManager = [[FPSecurityAuthManager alloc] init];
            [authManager securityAuth];
            [authManager setSecurityAuthSuccessBlock:^(NSString *securityPssaword) {
                
                [MBHUD showInView:self.view withDetailTitle:nil withType:HUDTypeLoading];
                
                [HomeHelperModel
                 transferWithAccountType:self.dataDict[@"toAccountType"]
                 accountID:self.dataDict[@"toAccountId"]
                 userHash:self.dataDict[@"userHash"]
                 coinId:self.dataDict[@"CoinId"]
                 amout:self.dataDict[@"Amount"]
                 pin:securityPssaword
                 reference:self.dataDict[@"Reference"]
                 CheckDuplicateTransaction: @"true"
                 completBlock:^(NSInteger errorCode, NSString *message, NSDictionary *dict) {
                    [MBHUD hideInView:self.view];
                    if (errorCode == kFPNetRequestSuccessCode) {
                        if (self.clickBlock) {
                            if(dict == nil){self.clickBlock(FPPaymentDuplicateCancelType, dict);}
                            else{self.clickBlock(FPPaymentClickSuccessType, dict);}
                        }
                    } else {
                        if(errorCode == 11000){
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedDefault(@"alert") message:NSLocalizedDefault(@"possible_dublicate_transaction_text") preferredStyle:UIAlertControllerStyleAlert];

                            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedDefault(@"okay") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                [HomeHelperModel
                                 transferWithAccountType:self.dataDict[@"toAccountType"]
                                 accountID:self.dataDict[@"toAccountId"]
                                 userHash:self.dataDict[@"userHash"]
                                 coinId:self.dataDict[@"CoinId"]
                                 amout:self.dataDict[@"Amount"]
                                 pin:securityPssaword
                                 reference:self.dataDict[@"Reference"]
                                 CheckDuplicateTransaction: nil
                                 completBlock:^(NSInteger errorCode, NSString *message, NSDictionary *dict) {
                                    if (errorCode == kFPNetRequestSuccessCode) {
                                        if (self.clickBlock) {
                                            if(dict == nil){self.clickBlock(FPPaymentDuplicateCancelType, dict);}
                                            else{self.clickBlock(FPPaymentClickSuccessType, dict);}
                                        }
                                    }
                                }];
                            }]];
                            
                            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedDefault(@"Cancel") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                
                                FPNavigationController *presentingViewController = (FPNavigationController*)self.presentingViewController;
                                [self dismiss:^{
                                    [presentingViewController popToRootViewControllerAnimated:true];
                                    
                                }];
                            }]];
                            [self presentViewController:alert animated:true completion:nil];
                        } else {
                            [self payErrorHandlerWithErrorCode:errorCode errorMessage:message];
                        }
                    }
                }];
            }];
        }
    }

- (void)groupTransfer {
    FPSecurityAuthManager *authManager = [[FPSecurityAuthManager alloc] init];
    [authManager securityAuth];
    [authManager setSecurityAuthSuccessBlock:^(NSString *securityPssaword) {
        
        [MBHUD showInView:self.view withDetailTitle:nil withType:HUDTypeLoading];
        
        NSMutableArray *users = [[NSMutableArray alloc] init];
        NSArray *receivers = self.dataDict[@"Receivers"];
        
        for (int i=0; i<[receivers count]; i++) {
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            PreTransferModel *user = receivers[i];
            
            if (user.email) {
                dict[@"toAccountType"] = @"1";
            } else {
                dict[@"toAccountType"] = @"0";
            }
            dict[@"ToAccountId"] = user.ToAccountId;
            
            [users addObject:dict];
        }
        
        [HomeHelperModel transferToGroup:users coinId:self.dataDict[@"CoinId"] amout:self.dataDict[@"AmountToSend"] pin:securityPssaword reference:self.dataDict[@"Reference"] completBlock:^(NSInteger errorCode, NSString *message, NSDictionary *dict) {
            [MBHUD hideInView:self.view];
            if (errorCode == kFPNetRequestSuccessCode) {
                if (self.clickBlock) {
                    if(dict == nil){self.clickBlock(FPPaymentDuplicateCancelType, dict);}
                    else{self.clickBlock(FPGroupPaymentClickSuccessType, dict);}
                }
            } else {
                [self payErrorHandlerWithErrorCode:errorCode errorMessage:message];
            }
        }];
    }];
}

    - (void)dealloc {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    @end
