#import "TransferInfoViewController.h"
#import "UIButton+ImageTitleSpacing.h"
#import "CBPayView.h"
#import "HomeHelperModel.h"
#import "FPValueDP.h"
#import "NSString+Regular.h"
#import "TransferInfoRouter.h"
#import "FBCoin.h"
#import "DecimalUtils.h"
#import "ProfileImageView.h"
#import "HCAmountTextField.h"
#import "HCToolBar.h"
#import "ConfirmationReceiverListViewCell.h"
#import "TransferInfoReceiverListHeaderView.h"
#import "HimalayaAuthKeychainManager.h"

@interface TransferInfoViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property(weak, nonatomic) IBOutlet UIView *headerContainerView;
@property(weak, nonatomic) IBOutlet ProfileImageView *profileImageView;
@property(weak, nonatomic) IBOutlet UILabel *nameLabel;
@property(weak, nonatomic) IBOutlet UILabel *accountLabel;
@property(weak, nonatomic) IBOutlet UILabel *transferAmountTitleLabel;
@property(weak, nonatomic) IBOutlet UIButton *fiatCurrencyBtn;
@property(weak, nonatomic) IBOutlet HCAmountTextField *moneyTF;
@property(weak, nonatomic) IBOutlet UILabel *balanceCoinLabel;
@property(weak, nonatomic) IBOutlet UILabel *balanceRateLabel;
@property(weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property(weak, nonatomic) IBOutlet UIButton *nextBtn;
@property(weak, nonatomic) IBOutlet UIButton *verifyButton;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *banImageView_W;

@property(weak, nonatomic) IBOutlet UILabel *referenceHelperLabel;
@property(weak, nonatomic) IBOutlet HPTextField *referenceTextField;
@property (weak, nonatomic) IBOutlet UITableView *receiversTable;
@property (weak, nonatomic) IBOutlet UIView *receiverDetailsView;

@property(weak, nonatomic) IBOutlet UILabel *amountTitleLabel;

@property(nonatomic, strong) CBPayView *cPayView;
@property(nonatomic, strong) HCToolBar *toolBar;
@property(strong, nonatomic) TransferInfoRouter<TransferInfoRouterInterface> *router;

@end

#define REFERENCE_TEXTFIELD_MAXLENGTH 50

@implementation TransferInfoViewController

- (TransferInfoRouter<TransferInfoRouterInterface> *)router {
    if (_router == nil) {
        _router = [[TransferInfoRouter alloc] init];
        _router.currentControllerDelegate = self;
        _router.navigationDelegate = self.navigationController;
        _router.tabBarControllerDelegate = self.tabBarController;
    }
    return _router;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.infoDict && self.transferModel){
        //self.infoDict = self.infoArray[0][@"email"];
        //self.transferModel = self.infoArray[0][@"transferModel"];
    }
    
    [self processData];
    
    self.moneyTF.delegate = self;
    self.moneyTF.inputAccessoryView = self.toolBar;
    self.referenceTextField.inputAccessoryView = self.toolBar;
    [self.moneyTF becomeFirstResponder];
    [self configureReferenceFields];
    [self.nextBtn setTitle:self.nextBtn.titleLabel.text.localizedUppercaseString forState:UIControlStateNormal];
    self.nextBtn.alpha = 0.5;
    [self applyTheme];
    
}

-(void)viewWillAppear:(BOOL)animated{
    if ([self.infoArray count] > 1){
        self.transferAmountTitleLabel.text = NSLocalizedString(@"transfer.send_to_group.amount_title", nil);
        
        for (PreTransferModel *item in self.infoArray){
            item.groupSendAmount = @"";
        }
        
    } else {
        self.transferAmountTitleLabel.text = NSLocalizedString(@"Transfer_Amount", nil);
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self applyTheme];
}

- (void)applyTheme{
    self.receiversTable.backgroundColor = [self getCurrentTheme].surface;
    self.receiverDetailsView.backgroundColor = [self getCurrentTheme].surface;
    self.view.backgroundColor = [self getCurrentTheme].background;
    self.headerContainerView.backgroundColor = [self getCurrentTheme].surface;
    self.nameLabel.textColor = [self getCurrentTheme].primaryOnSurface;
    self.accountLabel.textColor = [self getCurrentTheme].secondaryOnSurface;
    self.transferAmountTitleLabel.textColor = [self getCurrentTheme].primaryOnSurface;
    self.referenceHelperLabel.textColor = [self getCurrentTheme].primaryOnSurface;
    self.moneyTF.textColor = [self getCurrentTheme].primaryOnSurface;
    self.referenceTextField.textColor = [self getCurrentTheme].primaryOnSurface;
    self.amountTitleLabel.textColor = [self getCurrentTheme].primaryOnBackground;
    self.balanceCoinLabel.textColor = [self getCurrentTheme].primaryOnBackground;
    self.balanceRateLabel.textColor = [self getCurrentTheme].secondaryOnBackground;
    self.remarkLabel.textColor = [self getCurrentTheme].secondaryOnBackground;
    self.nextBtn.backgroundColor = [self getCurrentTheme].primaryButton;
}

- (void)processData {
    if (self.transferModel) {
        if (self.transferModel.CoinCode) {
            self.navigationItem.title = [NSString stringWithFormat:NSLocalizedDefault(@"transferTitle"), self.transferModel.CoinCode];
        }
        
        [self.fiatCurrencyBtn setTitle:self.transferModel.CoinCode forState:UIControlStateNormal];
        [self.fiatCurrencyBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:1];
        
        self.balanceCoinLabel.text = [NSString stringWithFormat:@"%@ %@",
                                      [DecimalUtils.shared stringInLocalisedFormatWithInput:self.transferModel.CoinBalance preferredFractionDigits:self.transferModel.CoinDecimalPlace],
                                      self.transferModel.CoinCode];
        // Step-by-step requirements modification
        NSInteger place = 2;
        double temp = self.transferModel.CoinBalance.doubleValue * self.transferModel.Price.doubleValue;
        BOOL isKillEndingZero = NO;
        if (temp < 1) {
            place = 8;
            isKillEndingZero = YES;
        }
        NSString *rateStr = [FPValueDP A:self.transferModel.CoinBalance chengyiB:self.transferModel.Price withPlace:place isKillEndingZero:isKillEndingZero];
        
        if (self.transferModel.Price){
            self.balanceRateLabel.text = [NSString stringWithFormat:@"≈%@%@",
                                          [DecimalUtils.shared stringInLocalisedFormatWithInput:rateStr preferredFractionDigits:2], // decimal place not returned.
                                          self.transferModel.FiatCurrency];
        }else{
            self.balanceRateLabel.text = kPlaceholderForMarketPriceNotAvailable;
        }

        NSString *minCoinAmount = [NSString stringWithFormat:@"%@ %@", self.transferModel.MinCount, self.transferModel.CoinCode];
        CGFloat value = [self.transferModel.Price floatValue] * [self.transferModel.MinCount floatValue];
        NSString *minFiatAmount = (self.transferModel.Price) ? [NSString stringWithFormat:@"%.2f %@", value, self.transferModel.FiatCurrency] : kPlaceholderForMarketPriceNotAvailable;
        NSString *info = [NSString stringWithFormat:NSLocalizedHome(@"min_transfer_amount_xxx_or_zzz"), minCoinAmount, minFiatAmount];
        self.remarkLabel.text = info;
    }
    
    if ([self.infoArray count] > 1) {
        self.receiversTable.hidden = FALSE;
        
        _receiversTable.delegate = self;
        _receiversTable.dataSource = self;
        [_receiversTable registerNib:[UINib nibWithNibName:@"ConfirmationReceiverListViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ConfirmationReceiverListViewCellId"];
        [_receiversTable registerNib:[UINib nibWithNibName:@"TransferInfoReceiverListHeaderView" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"TransferInfoReceiverListHeaderViewId"];
        
        [self.headerContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-40);
        }];
    }
    else if (self.transferModel) {
        self.receiversTable.hidden = TRUE;
        
        self.accountLabel.text = self.transferModel.ToAccountName;
        
        if (self.transferModel.IsProfileVerified) {
            self.banImageView_W.constant = 0;
            [self.verifyButton setTitleColor:[self getCurrentTheme].primaryOnSurface forState:UIControlStateNormal];
        } else {
            [self.verifyButton setTitle:NSLocalizedHome(@"transferInfo.isProfileNotVerifiedYet.warning") forState:UIControlStateNormal];
        }
        [self.profileImageView setupWithUserName:self.transferModel.givenName lastName:self.transferModel.familyName];
        self.nameLabel.text = [NSString stringWithFormat:@"%@", self.transferModel.ToFullname];

    }
}

- (void)configureReferenceFields {
    _referenceHelperLabel.text = NSLocalizedString(@"transfer_info.noteLabel.title", @"Transfer Info note label title");
    _referenceTextField.placeholder = NSLocalizedString(@"transfer_info.noteField_placeholder.title", @"Transfer Info note field placeholder title");
    [_referenceTextField setMaxNumber:REFERENCE_TEXTFIELD_MAXLENGTH];
}

-(NSString*)calcTotalAmountTranfered {
    NSNumber *total = 0;
    
    for (PreTransferModel *item in self.infoArray){
        total = [NSNumber numberWithDouble:(total.doubleValue + [item.groupSendAmount doubleValue])];
    }
    
    return total.stringValue;
}

#pragma mark - Amount input change

- (IBAction)textFieldValueChange:(UITextField*)sender {
    sender.text = [sender.text stringByReplacingOccurrencesOfString:@"," withString:@"."];
    self.nextBtn.selected = self.nextBtn.userInteractionEnabled = sender.text.length > 0 ? YES : NO;
    [self.nextBtn configureBackgroundColorFor:sender.text.length > 0];
    if (sender.tag == -1){ //main text field
        for (PreTransferModel *item in self.infoArray){
            item.groupSendAmount = sender.text;
        }
    } else if (sender.tag >= 0 && sender.tag < [self.infoArray count]) {
        PreTransferModel *item = self.infoArray[sender.tag];
        item.groupSendAmount = sender.text;
    }
    
    [self.receiversTable reloadData];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@","]) {
        string = @".";
    }
    
    if (![NSString verifyMoney:string] && ![string isEqualToString:@""]) {
        return NO;
    }
    
    NSInteger decimalPlace = 0;
    NSInteger maxNumber = 0;
    NSString *minMoney;
    BOOL isLackofbalance = NO;
    
    if (self.transferModel && [self.fiatCurrencyBtn.titleLabel.text isEqualToString:self.transferModel.CoinCode]) {
        // BTC
        decimalPlace = self.transferModel.CoinDecimalPlace;
        maxNumber = 11 + self.transferModel.CoinDecimalPlace;
        minMoney = self.transferModel.CoinBalance;
    } else if (self.transferModel && [self.fiatCurrencyBtn.titleLabel.text isEqualToString:self.transferModel.FiatCurrency]) {
        // Fiat currency
        decimalPlace = 2;     //Decimal places
        NSString *rateStr = [FPValueDP A:@"9999999999.99" chengyiB:self.transferModel.Price withPlace:2];
        maxNumber = rateStr.length;
        minMoney = [FPValueDP A:self.transferModel.CoinBalance chengyiB:self.transferModel.Price withPlace:2];
    } else {
        return NO;
    }
    
    UITextPosition *beginning = textField.beginningOfDocument;
    UITextRange *selectedRange = textField.selectedTextRange;
    UITextPosition *selectionStart = selectedRange.start;
    const NSInteger location = [textField offsetFromPosition:beginning toPosition:selectionStart];
    
    // The first letter cannot be "."
    if (textField.text.length == 0) {
        if ([string isEqualToString:@"."]) {
            return NO;
        }
    }
    
    // The input is "."
    if ([string isEqualToString:@"."]) {
        // If there is "." in the textfield before, input is prohibited
        if ([textField.text rangeOfString:@"."].location != NSNotFound) {
            return NO;
        } else {
            if (textField.text.length > location && textField.text.length - decimalPlace > location) {
                return NO;
            }
        }
    }
    
    if ([textField.text hasPrefix:@"0"] && ![string isEqualToString:@"."] && textField.text.length == 1 && ![string isEqualToString:@""]) {
        return NO;
    }
    
    if ([string isEqualToString:@"0"] && textField.text.length > 0) {
        
        if (location == 0) {
            return NO;
        }
    }
    
    NSMutableString *moneyStr = [[NSMutableString alloc] initWithString:textField.text];
    [moneyStr insertString:string atIndex:location];
    if ([FPValueDP A:moneyStr.mutableCopy dayuB:minMoney]) {
        [MBHUD hideInView:self.view];
        [MBHUD showInView:self.view withDetailTitle:NSLocalizedWallet(@"insufficient_balance") withType:HUDTypeError];
        isLackofbalance = YES;
    }
    
    NSRange ran = [textField.text rangeOfString:@"."];
    if (ran.location != NSNotFound) {
        
        if (location > ran.location) {
            // The cursor is after the decimal point
            
            // Get the string after the decimal point
            NSString *tmp = [textField.text substringFromIndex:ran.location + 1];
            NSInteger dotAfterLength = tmp.length;
            
            // Delete key
            if ([string isEqualToString:@""]) {
                // Remove the decimal point
                NSString *noPStr = [textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
                if (noPStr && noPStr.length > (maxNumber - decimalPlace) && location == ran.location + 1) {
                    return NO;
                }
                return YES;
            }
            
            if (dotAfterLength < decimalPlace) {
                return YES;
            } else {
                
                return NO;
            }
            
        } else {
            
            //The cursor is in front of the decimal point
            if (textField.text && textField.text.length == maxNumber && ![string isEqualToString:@""] && isLackofbalance == NO) {
                [MBHUD hideInView:self.view];
                [MBHUD showInView:self.view withDetailTitle:NSLocalizedHome(@"insufficient_balance") withType:HUDTypeError];
            }
            
            if (location == 0) {
                if ([string isEqualToString:@"0"]) {
                    return NO;
                }
            } else {
                if ([textField.text hasPrefix:@"0"]) {
                    return NO;
                }
            }
            
            if (ran.location > (maxNumber - 2 - decimalPlace) && ![string isEqualToString:@""]) {
                return NO;
            }
        }
    } else {
        // No decimal point
        if (textField.text && textField.text.length == (maxNumber - 1 - decimalPlace) && ![string isEqualToString:@""] && ![string isEqualToString:@"."] && isLackofbalance == NO) {
            [MBHUD hideInView:self.view];
            [MBHUD showInView:self.view withDetailTitle:NSLocalizedHome(@"insufficient_balance") withType:HUDTypeError];
        }
        
        if (textField.text.length == (maxNumber - 1 - decimalPlace) && ![string isEqualToString:@""] && ![string isEqualToString:@"."]) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - Next step

- (IBAction)nextAction:(id)sender {
    
    if (!self.transferModel.IsProfileVerified) {
        [MBHUD showInView:self.view withDetailTitle:NSLocalizedHome(@"transferInfo.isProfileNotVerifiedYet.warning") withType:HUDTypeWarning];
        return;
    }
    
    NSError *error;
    UserConfigResponse *userConfig = [HimalayaAuthKeychainManager loadUserConfigToKeychain:&error];
    if (!error 
        && userConfig.SendToGroupMaxAmountLimit
        && [userConfig.SendToGroupMaxAmountLimit floatValue] > 0
        && [self.moneyTF.text floatValue] > [userConfig.SendToGroupMaxAmountLimit floatValue]) {
        
        if ([self.infoArray count] > 1) {
            [MBHUD showInView:self.view withDetailTitle:[NSString stringWithFormat:NSLocalizedHome(@"group_send_amount_exceeded_with_amount"), userConfig.SendToGroupMaxAmountLimit, self.transferModel.CoinCode] withType:HUDTypeWarning];
            return;
        }
    }
    
    NSString *amount;
    NSString *money = @"0";
    NSString *price = @"0";
    if (self.moneyTF.text && self.moneyTF.text.length > 0) {
        money = self.moneyTF.text;
    }
    if (self.transferModel.Price && self.transferModel.Price.length > 0) {
        price = self.transferModel.Price;
    }
    if (self.transferModel && [self.fiatCurrencyBtn.titleLabel.text isEqualToString:self.transferModel.CoinCode]) {
        // BTC
        amount = [FPValueDP A:money chengyiB:@"1.0" withPlace:self.transferModel.CoinDecimalPlace];
    } else if (self.transferModel && [self.fiatCurrencyBtn.titleLabel.text isEqualToString:self.transferModel.FiatCurrency]) {
        // Fiat currency
        amount = [FPValueDP A:money chuyiB:price withPlace:self.transferModel.CoinDecimalPlace];
    } else {
        return;
    }
    if ([self.transferModel.ChargeFee doubleValue] > 0 && [FPValueDP A:amount xiaoyuDengyuB:self.transferModel.ChargeFee]) {
        [MBHUD showInView:self.view withDetailTitle:NSLocalizedHome(@"total_amount_must_be_greater_than_zero") withType:HUDTypeError];
        return;
    }
    
    if (self.transferModel.MinCount && self.transferModel.MinCount.length > 0 && [FPValueDP A:amount xiaoyuB:self.transferModel.MinCount]) {
        NSString *message = [NSString stringWithFormat:NSLocalizedHome(@"min_transfer_amount"), self.transferModel.MinCount, self.transferModel.CoinCode];
        [MBHUD showInView:self.view withDetailTitle:message withType:HUDTypeError];
        return;
    }
    
    if (self.transferModel.CoinBalance && self.transferModel.CoinBalance.length > 0 && [FPValueDP A:amount dayuB:self.transferModel.CoinBalance]) {
        [MBHUD showInView:self.view withDetailTitle:NSLocalizedWallet(@"insufficient_balance") withType:HUDTypeError];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (self.transferModel) {
        dict[@"CoinCode"] = self.transferModel.CoinCode;
        
        if (self.transferModel.email) {
            dict[@"toAccountType"] = @"1";
        } else if (self.transferModel.userhash) {
            //dict[@"Account"] = [NSString stringWithFormat:@"%@", self.transferModel.ToAccountName];
            dict[@"toAccountType"] = @"1";
            dict[@"userHash"] = self.transferModel.userhash;
        }
        else {
            //dict[@"Account"] = self.transferModel.ToAccountName;
            dict[@"toAccountType"] = @"0";
        }
        
        if (self.transferModel.ToFullname && ![self.transferModel.ToFullname isEqualToString:@""]){
            dict[@"Account"] = [NSString stringWithFormat:@"%@\n%@", self.transferModel.ToFullname, self.transferModel.ToAccountName];
        }
        else {
            dict[@"Account"] = [NSString stringWithFormat:@"%@", self.transferModel.ToAccountName];
        }
        dict[@"toAccountId"] = self.transferModel.ToAccountId;
    }
    
    if ([self.transferModel.ChargeFee doubleValue] > 0) {
        dict[@"Amount"] = [FPValueDP A:amount jianB:self.transferModel.ChargeFee withPlace:self.transferModel.CoinDecimalPlace];
    } else {
        dict[@"Amount"] = amount;
    }
    dict[@"CoinId"] = self.transferModel.CoinId;
    
    dict[@"Reference"] = @"";
    if (![NSString textIsEmpty:_referenceTextField.text]) {
        dict[@"Reference"] = _referenceTextField.text;
    }
    
    dict[@"CoinDecimalPlace"] = @(self.transferModel.CoinDecimalPlace);
    
    if ([self.infoArray count] > 1) {
        dict[@"Account"] = [NSString stringWithFormat:@"%ld %@ x %@ %@", [self.infoArray count], NSLocalizedString(@"accounts", nil), amount, dict[@"CoinCode"]];
        dict[@"Amount"] = [self calcTotalAmountTranfered];
        dict[@"AmountToSend"] = amount;
        dict[@"Receivers"] = self.infoArray;
    }
    
    PaymentViewController *paymentVC = (PaymentViewController *) [SB_HOME instantiateViewControllerWithIdentifier:@"PaymentViewController"];
    paymentVC.paymentType = FPPaymentTypeWithtransfer;
    paymentVC.dataDict = dict.copy;
    paymentVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    paymentVC.definesPresentationContext = YES;
    paymentVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:paymentVC animated:YES completion:^{
        paymentVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    }];
    
    __weak PaymentViewController *weakPaymentVC = paymentVC;
    paymentVC.clickBlock = ^(FPPaymentClickType type, NSObject *_Nullable data) {
        switch (type) {
            case FPPaymentDuplicateCancelType: {
                [self.router returnToHomeFromCancellationOfDuplicate];
            }
                
            case FPPaymentClickTopupType: {
                [weakPaymentVC dismiss:nil];
                // Insufficient balance, go to recharge
                FBCoin *coin = [FBCoin new];
                coin.Id = dict[@"CoinId"];
                coin.Code = dict[@"CoinCode"];
            }
                break;
            case FPPaymentClickCloseType: {
                [weakPaymentVC dismiss:nil];
            }
                break;
            case FPPaymentClickSuccessType: {
                [weakPaymentVC dismiss:nil];
                
                NSDictionary *infoDict = (NSDictionary *) data;
                if (infoDict) {
                    [self.router presentTransferPaySuccessPageWith:infoDict];
                }
            }
                break;
            
            case FPGroupPaymentClickSuccessType: {
                [weakPaymentVC dismiss:nil];
                
                NSDictionary *infoDict = (NSDictionary *) data;
                if (infoDict) {
                    [self.router presentGroupTransferPaySuccessPageWith:infoDict];
                }
            }
                break;
                
            case FPPaymentClickCancelType: {
                [weakPaymentVC dismiss:nil];
            }
                break;
            case FPPaymentClickLinkType: {
                //Contact Customer Service
                [weakPaymentVC dismiss:nil];
                
                // Withdrawal is prohibited, click to contact customer service
                [self.router pushToHelpFeedback];
            }
                break;
                
            default:
                break;
        }
    };
}

#pragma mark - Contact Customer Service

- (void)linkCustomer {
    [self.cPayView hide];
    [self.router pushToHelpFeedback];
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

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.infoArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConfirmationReceiverListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmationReceiverListViewCellId" forIndexPath:indexPath];
    if(cell == nil) {
        cell = [[ConfirmationReceiverListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ConfirmationReceiverListViewCellId"];
    }
    PreTransferModel *item = self.infoArray[indexPath.row];
    cell.name.text = [NSString stringWithFormat:@"%@ - %@", item.ToAccountName, item.ToFullname];
    [cell setValueToAmount: item.groupSendAmount];
    cell.coin.text = self.transferModel.CoinCode;
    cell.amount.delegate = self;
    cell.amount.tag = indexPath.row;
    [cell.amount addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    TransferInfoReceiverListHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TransferInfoReceiverListHeaderViewId"];
    
    headerView.headerText.text = [NSString stringWithFormat:NSLocalizedString(@"transfer.send_to_group.transfer_info.list_title", nil), [self calcTotalAmountTranfered], self.transferModel.CoinCode, self.infoArray.count];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

@end
