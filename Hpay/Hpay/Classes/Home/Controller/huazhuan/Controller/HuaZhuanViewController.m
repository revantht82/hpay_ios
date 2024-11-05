#import "HuaZhuanViewController.h"
#import "ZdPickerView.h"
#import "HomeHelperModel.h"
#import "CBPayView.h"
#import "HuaZhuanRouter.h"
#import "NSString+Regular.h"
#import "DecimalUtils.h"
#import "HCToolBar.h"
#import "ApiError.h"

@interface HuaZhuanViewController () <UITextFieldDelegate>
@property(weak, nonatomic) IBOutlet UIButton *coinTypeBtn;
@property(weak, nonatomic) IBOutlet UILabel *coinNum;
@property(weak, nonatomic) IBOutlet TXLimitedTextField *coinNumTF;
@property(weak, nonatomic) IBOutlet UILabel *coinCodeName;
@property(weak, nonatomic) IBOutlet UIButton *actionButton;
@property(weak, nonatomic) IBOutlet UIView *topHeader;
@property(weak, nonatomic) IBOutlet UIView *inputContainerView;

@property(strong, nonatomic) NSDictionary *selCoinDic;
@property(strong, nonatomic) NSArray *huaZhuanArr;
@property(strong, nonatomic) HuaZhuanRouter<HuaZhuanRouterInterface> *router;
@property(strong, nonatomic) NSNumberFormatter *numberFormatter;
@property(strong, nonatomic) HCToolBar *toolBar;
@property (weak, nonatomic) IBOutlet UIView *divider1;
@property (weak, nonatomic) IBOutlet UIView *divider2;
@property (weak, nonatomic) IBOutlet UIView *divider3;

@end

@implementation HuaZhuanViewController

- (HuaZhuanRouter<HuaZhuanRouterInterface> *)router {
    if (_router == nil) {
        _router = [[HuaZhuanRouter alloc] init];
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
    self.navigationItem.title = NSLocalizedDefault(@"transfer");
    [self.coinTypeBtn setTitle:@"HDR" forState:UIControlStateNormal];
    self.huaZhuanArr = @[];
    
    self.coinNumTF.inputAccessoryView = self.toolBar;
    self.coinNumTF.keyboardType = UIKeyboardTypeDecimalPad;
    self.coinNumTF.limitedType = TXLimitedTextFieldTypeCustom;
    [self.coinNumTF setLimitedRegEx:@"^([0-9]*|[0-9]*[.|,][0-9]*)$"];
    self.coinNumTF.placeholder = NSLocalizedDefault(@"enter");
    [self.coinNumTF addTarget:self
                       action:@selector(coinFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
    [self setupData];
    [self applyTheme];
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
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self applyTheme];
}

- (void)coinFieldDidChange:(UITextField *)textField{
    textField.text = [textField.text stringByReplacingOccurrencesOfString:@"," withString:@"."];

    NSNumber *isValidNumber = @([self isValidAmount:textField.text] && [self isAmountDecimalNumberValid:textField.text]);
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
    NSDecimalNumber *selectedBalanceDecimal = [[NSDecimalNumber alloc] initWithString:self.selectedBalance];
    NSDecimalNumber *maxAmountDecimal = [[NSDecimalNumber alloc] initWithString:self.selectedMaxAmount];
    NSDecimalNumber *minAmountDecimal = [[NSDecimalNumber alloc] initWithString:self.selectedMinAmount];
    
    NSComparisonResult selectedBalanceComparison = [coinNumTFDecimal compare:selectedBalanceDecimal];
    NSComparisonResult maxAmountComparison = [coinNumTFDecimal compare:maxAmountDecimal];
    NSComparisonResult minAmountComparison = [coinNumTFDecimal compare:minAmountDecimal];
    
    if (selectedBalanceComparison == NSOrderedDescending) {
        [self handleInputError:NSLocalizedDefault(@"insufficient_balance")];
        return;
    }
    
    if (maxAmountComparison == NSOrderedDescending) {
        [self handleInputError:[NSString stringWithFormat:NSLocalizedDefault(@"single_transaction_limit"),self.selectedMaxAmount]];
        return;
    }
    
    if (minAmountComparison == NSOrderedAscending) {
        [self handleInputError:[NSString stringWithFormat:NSLocalizedDefault(@"min_transfer_amount"), self.selectedMinAmount, self.selectedCryptoCode]];
        return;
    }
    
    [self.coinNumTF resignFirstResponder];
    
    NSString *cryptoCode = self.selectedCryptoCode;
    NSString *amount = [DecimalUtils.shared stringInLocalisedFormatWithInput:self.coinNumTF.text preferredFractionDigits:self.decimalPlaceUInt];
    
    CBPayView *cPayView = [CBPayView getPayView];
    WS(weakSelf);
    [cPayView showWithType:CBPayViewTypeWithGPayHuaZhuan andInfoDict:@{@"CoinCode": cryptoCode, @"Amount": amount} withFinishEvent:^(NSDictionary *resultDict) {
        [weakSelf createHuaZhuanWithPin:resultDict[@"securityPssaword"]];
    }         andLinkBlock:^{
    }];
}

- (void)handleInputError:(nonnull NSString *)message {
    [MBHUD showInView:self.view withDetailTitle:message withType:HUDTypeFailWithoutImage];
    [self.coinNumTF becomeFirstResponder];
}

#pragma mark - Helpers

- (void)setupData {
    MJWeakSelf
    [self showLoadingState];
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

- (void)reloadHuazhuanView:(nonnull NSDictionary *)selCoinDic {
    
    if (!self.selectedBalance || !self.selectedCryptoCode) {
        [self cleanHuaZhuanView];
        return;
    }
    
    NSInteger digits = [self.selectedDecimalPlace intValue];
    [self.coinTypeBtn setTitle:self.selectedCryptoCode forState:UIControlStateNormal];
    self.coinNum.text = [NSString stringWithFormat:@"%@ %@",
                         [DecimalUtils.shared stringInLocalisedFormatWithInput:self.selectedBalance preferredFractionDigits:digits],
                         self.selectedCryptoCode];
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

- (void)createHuaZhuanWithPin:(NSString *)pin {
    [MBHUD showInView:self.view withDetailTitle:nil withType:HUDTypeLoading];
    NSString *amount = [DecimalUtils.shared stringWithFractionDigitsWithInput:self.coinNumTF.text withExactNumberOfDigits:self.decimalPlaceUInt];
    WS(weakSelf)
    [HomeHelperModel creatHuaZhuanOrderWithCryptoId:self.selCoinDic[@"CryptoId"] amount:amount pin:pin CheckDuplicateTransaction:@"true" CompleteBlock:^(NSDictionary *orderDic, NSInteger errorCode, NSString *errorMessage) {
        [MBHUD hideInView:weakSelf.view];
        struct PresentPaySuccessNavigationRequest request;
        request.orderDictionary = orderDic;
        request.selCoinDic = weakSelf.selCoinDic;
        request.amount = weakSelf.coinNumTF.text;
        
        if (orderDic && weakSelf.selCoinDic) {
            [weakSelf.router presentExchangePaySuccessWithRequest:request];
        } else {
            [weakSelf handleCreateOrderError:errorCode remoteMessage:errorMessage];
            if(errorCode == 11000){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedDefault(@"alert") message:NSLocalizedDefault(@"possible_dublicate_transaction_text") preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedDefault(@"okay") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    [HomeHelperModel creatHuaZhuanOrderWithCryptoId:self.selCoinDic[@"CryptoId"] amount:amount pin:pin CheckDuplicateTransaction:nil CompleteBlock:^(NSDictionary *orderDic, NSInteger errorCode, NSString *errorMessage) {
                        
                        if (errorCode == kFPNetRequestSuccessCode) {
                            struct PresentPaySuccessNavigationRequest request;
                            request.orderDictionary = orderDic;
                            request.selCoinDic = weakSelf.selCoinDic;
                            request.amount = weakSelf.coinNumTF.text;
                            
                            if (orderDic && weakSelf.selCoinDic) {
                                [weakSelf.router presentExchangePaySuccessWithRequest:request];
                            }
                        } else {
                            [self handleCreateOrderError:errorCode remoteMessage:errorMessage];
                        }
                    }] ;
                    
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedDefault(@"Cancel") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    NSLog(@"cancelled");
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                }]];
                
                [self presentViewController:alert animated:true completion:nil];
            }
        }
    }];
}

- (void)handleCreateOrderError:(NSInteger)errorCode remoteMessage:(NSString *)remoteMessage {
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
        default:
            break;
    }
    
    ApiError* error = [ApiError errorWithCode:errorCode message:remoteMessage];
    [MBHUD showInView:self.view withDetailTitle:error.prettyMessage withType:HUDTypeError];
}

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

@end
