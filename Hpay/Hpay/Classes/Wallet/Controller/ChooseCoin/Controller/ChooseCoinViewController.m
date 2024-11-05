#import "ChooseCoinViewController.h"
#import "ChooseCoinTableViewCell.h"
#import "WalletModelHelper.h"
#import "HomeHelperModel.h"
#import "ChooseCoinRouter.h"
#import "TransferRouter.h"
#import "DecimalUtils.h"
#import "FPBluetoothMerchant.h"

#define kAlphaNum @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

typedef void(^DidSelectBlock)(FBCoin *coin, NSInteger idx);

@interface ChooseCoinViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property(weak, nonatomic) IBOutlet UITableView *mTableView;

@property(copy, nonatomic) NSString *FiatCurrency;
@property(assign, nonatomic) CoinActionType actionType;
@property(assign, nonatomic) BOOL isSearch;
@property(assign, nonatomic) NSInteger idx;
@property(strong, nonatomic) FPBluetoothMerchant *merchant;
@property(strong, nonatomic) NSMutableArray *coinArr;
@property(strong, nonatomic) NSMutableArray *searchArr;
@property(strong, nonatomic) ChooseCoinRouter<ChooseCoinRouterInterface> *router;
@property(strong, nonatomic) TransferRouter<TransferRouterInterface> *transferRouter;

- (IBAction)txtValueChange:(UITextField *)sender;
- (IBAction)closePageEvent:(id)sender;

@end

@implementation ChooseCoinViewController

- (ChooseCoinRouter<ChooseCoinRouterInterface> *)router {
    if (_router == nil) {
        _router = [[ChooseCoinRouter alloc] init];
        _router.currentControllerDelegate = self;
        _router.navigationDelegate = self.navigationController;
        _router.tabBarControllerDelegate = self.tabBarController;
    }
    return _router;
}

- (TransferRouter<TransferRouterInterface> *)transferRouter {
    if (_transferRouter == nil) {
        _transferRouter = [[TransferRouter alloc] init];
        _transferRouter.currentControllerDelegate = self;
        _transferRouter.navigationDelegate = self.navigationController;
        _transferRouter.tabBarControllerDelegate = self.tabBarController;
    }
    return _transferRouter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.transferModel && [self.infoArray count] > 0){
        NSLog(@"%@", self.infoArray[0]);
        self.transferModel = self.infoArray[0];
    }
    
    [self configureViewStateHandlingWithAlignment:kAlignmentFull height:NULL];
    self.title = NSLocalizedHome(@"select_currency");
    self.searchArr = [NSMutableArray array];
    self.mTableView.rowHeight = UITableViewAutomaticDimension;
    UIView *hv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    self.mTableView.tableHeaderView = hv;
    // Active payment (Bluetooth, static code) comes in to choose coins and get data from the network
    [self loadData];
    [self applyTheme];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self applyTheme];
}

- (void)applyTheme{
    self.mTableView.backgroundColor = [self getCurrentTheme].background;
    self.view.backgroundColor = [self getCurrentTheme].background;
}

- (void)loadData{
    [self fetchCoinList:NO];
}

#pragma mark -

- (void)fetchCoinList:(BOOL)isPayLife {
    [self showLoadingState];
    
    [WalletModelHelper fetchCoinList:isPayLife andFiatCurrency:self.FiatCurrency completeBlock:^(NSArray *coinList, NSString *FiatCurrency, NSInteger errorCode, NSString *errorMessage) {
        if (errorCode == kFPNetRequestSuccessCode) {
            [self hideStatefulViewController];
            self.coinArr = [NSMutableArray arrayWithArray:coinList];
            if (!isPayLife) {
                self.FiatCurrency = FiatCurrency;
            }
            [self.mTableView reloadData];
        }else if (errorCode == kErrorCodeMarketPriceNotAvailable){
            [self showAlertForMarketPriceNotAvailable];
        } else {
            [self handleErrorWithErrorCode:errorCode message:errorMessage];
        }
    }];
}

/// FiiiPos merchant currency column
- (void)fetchCoinListByMerchant {
    [self showLoadingState];
    
    [HomeHelperModel fetchOrderPrePayByMerchantId:self.merchant.Id orMerchantCode:nil completeBlock:^(FPPrePayOM *model, NSInteger errorCode, NSString *errorMessage) {
        if (errorCode == kFPNetRequestSuccessCode) {
            [self hideStatefulViewController];
            self.coinArr = [NSMutableArray arrayWithArray:[model.WaletList mutableCopy]];
            self.merchant.MarkupRate = model.MarkupRate;
            self.merchant.FiatCurrency = model.FiatCurrency;
            self.FiatCurrency = model.FiatCurrency;
            [self.mTableView reloadData];
        } else {
            [self handleErrorWithErrorCode:errorCode message:errorMessage];
        }
    }];
}

- (void)handleErrorWithErrorCode:(NSInteger)code message:(NSString *)message{
    if ([self.mTableView numberOfSections] > 0){
        [MBHUD showInView:self.view withDetailTitle:message withType:HUDTypeError];
    }else{
        switch (code) {
            case kFPNetWorkErrorCode:{
                [self showNetworkErrorWithPrimaryButtonTitle:StateViewModel.retryButtonTitle
                                        secondaryButtonTitle:NULL didTapPrimaryButton:^(id  _Nonnull sender) {
                    [self didTapRefresh:sender];
                } didTapSecondaryButton:NULL];
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
}

- (void)configCoinActionType:(CoinActionType)actionType {
    self.actionType = actionType;
}

- (void)configCoinActionType:(CoinActionType)actionType withWalletList:(NSArray *)coinArr andCurIndex:(NSInteger)idx didSelectBlock:(void (^)(FBCoin *coin, NSInteger idx))selectBlock {
    self.idx = idx;
    self.coinArr = [NSMutableArray arrayWithArray:coinArr];
    [self configCoinActionType:actionType];
}

- (void)configCoinActionType:(CoinActionType)actionType withWalletList:(NSArray *)coinArr andCurIndex:(NSInteger)idx andFC:(NSString *)fCurrence didSelectBlock:(void (^)(FBCoin *coin, NSInteger idx))selectBlock {
    self.idx = idx;
    self.FiatCurrency = fCurrence;
    self.coinArr = [NSMutableArray arrayWithArray:coinArr];
    [self configCoinActionType:actionType];
}

- (IBAction)closePageEvent:(id)sender {
    [self hideKeyboard];
    [self.router pop];
}

- (void)addShandowWithView:(UIView *)view {
    view.layer.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:0.9].CGColor;
    view.layer.shadowOffset = CGSizeMake(0, 1);
    view.layer.shadowRadius = 8;
    view.layer.shadowOpacity = 1;
    view.layer.shadowColor = RGBA(0, 69, 212, 0.12).CGColor;
    view.clipsToBounds = NO;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isSearch) {
        return self.searchArr.count;
    } else {
        return self.coinArr.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChooseCoinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChooseCoinTableViewCellId" forIndexPath:indexPath];
    [self addShandowWithView:cell];
    
    NSMutableArray *tmpArr;
    if (self.isSearch) {
        tmpArr = self.searchArr;
    } else {
        tmpArr = self.coinArr;
    }
    if (tmpArr && tmpArr.count > indexPath.section) {
        FBCoin *coin = tmpArr[indexPath.section];
        if (!self.isSearch) {
            if (self.actionType == CoinActionTypeTransfer || self.actionType == CoinActionTypeTransferScan) {
                if (indexPath.section == self.idx && self.idx != -1) {
                    cell.leftLineImageView.image = [UIImage imageNamed:@"payment_bar_chosen_large"];
                } else {
                    cell.leftLineImageView.image = [UIImage imageNamed:@"pic_payment_bar_default"];
                }
            } else {
                cell.leftLineImageView.image = nil;
            }

        } else {
            if (self.actionType == CoinActionTypeTransfer || self.actionType == CoinActionTypeTransferScan) {
                
                if (self.coinArr.count > self.idx && self.idx != -1) {
                    FBCoin *c = self.coinArr[self.idx];
                    if ([coin.Code isEqualToString:c.Code]) {
                        cell.leftLineImageView.image = [UIImage imageNamed:@"payment_bar_chosen_large"];
                    } else {
                        cell.leftLineImageView.image = [UIImage imageNamed:@"pic_payment_bar_default"];
                    }
                } else {
                    cell.leftLineImageView.image = [UIImage imageNamed:@"pic_payment_bar_default"];
                }
                
            } else {
                cell.leftLineImageView.image = nil;
            }
        }
        
        cell.codeLabel.text = coin.Code;
        cell.nameLabel.text = coin.Name;
        cell.useableLabel.text = [DecimalUtils.shared stringInLocalisedFormatWithInput:coin.UseableBalance preferredFractionDigits:coin.DecimalPlace];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self hideKeyboard];
    switch (self.actionType) {
        case CoinActionTypeDeposit: // Recharge
        {
            NSMutableArray *tmpArr;
            if (self.isSearch) {
                tmpArr = self.searchArr;
            } else {
                tmpArr = self.coinArr;
            }
            if (tmpArr && tmpArr.count > indexPath.section) {
                FBCoin *coin = tmpArr[indexPath.section];
                
                if ([coin.Status integerValue] == 0 || !coin.canDeposit) {
                    // Deposit is disabled
                    [self coinExceptionToMCustomer];
                } else {
                    
                    // [self.router pushToDepositCoinWithCoin: coin];
                }
            }
        }
            break;
        case CoinActionTypeWithdrawal: // Withdraw
        {
            NSMutableArray *tmpArr;
            if (self.isSearch) {
                tmpArr = self.searchArr;
            } else {
                tmpArr = self.coinArr;
            }
            if (tmpArr && tmpArr.count > indexPath.section) {
                FBCoin *coin = tmpArr[indexPath.section];
                
                if ([coin.Status integerValue] == 0 || !coin.canWithdrawal) {
                    // Withdrawal disabled
                    [self coinExceptionToMCustomer];
                } else {
                    [self.router pushToWithdrawalCoinWithCoin:coin];
                }
            }
        }
            break;
            
        case CoinActionTypeTransferScan:
        case CoinActionTypeTransfer: {
            NSMutableArray *tmpArr;
            if (self.isSearch) {
                tmpArr = self.searchArr;
            } else {
                tmpArr = self.coinArr;
            }
            if (tmpArr && tmpArr.count > indexPath.section) {
                FBCoin *coin = tmpArr[indexPath.section];
                if ([coin.Status integerValue] == 0 || !coin.canTransfer) {
                    // Transfers are disabled
                    [self coinExceptionToMCustomer];
                } else {
                    NSInteger ix = [self.coinArr indexOfObject:coin];
                    self.idx = ix;
                    [tableView reloadData];
                    if (!coin.FiatCurrency) coin.FiatCurrency = self.FiatCurrency;
                    
                    
                    
                    if (self.userHash) {
                        [HomeHelperModel preTransfer:coin.Id toUserHash:self.userHash completBlock:^(NSInteger errorCode, NSString *message, PreTransferModel *transferModel) {
                            [MBHUD hideInView:self.view];
                            
                            if (errorCode == kFPNetRequestSuccessCode) {
                                struct TransferInfoNavigationRequest request;
                                request.transferModel = transferModel;
                                request.transferModel.CoinId = coin.Id;
                                request.transferModel.CoinCode = coin.Code;
                                request.transferModel.MinCount = coin.minAmount;
                                request.transferModel.CoinBalance = coin.UseableBalance;
                                request.transferModel.FiatCurrency = coin.FiatCurrency;
                                request.transferModel.Price = coin.FiatExchangeRate;
                                request.transferModel.CoinDecimalPlace = coin.DecimalPlace;
                                request.transferModel.ChargeFee = coin.ChargeFee;
                                request.userHash = self.userHash;
                                request.transferModel.userhash = self.userHash;
                                [self.transferRouter pushToTransferInfoWithRequest:request];
                            } else {
                                [self handleErrorWithErrorCode:errorCode message:NSLocalizedCommon(@"unexpected_error")];
                            }
                        }];
                    }
                    else {
                        //[self.router pushToTransferWithCoin:coin userHash:self.userHash];
                        if (self.transferModel){
                            self.transferModel.CoinId = coin.Id;
                            self.transferModel.CoinCode = coin.Code;
                            self.transferModel.MinCount = coin.minAmount;
                            self.transferModel.CoinBalance = coin.UseableBalance;
                            self.transferModel.FiatCurrency = coin.FiatCurrency;
                            self.transferModel.Price = coin.FiatExchangeRate;
                            self.transferModel.CoinDecimalPlace = coin.DecimalPlace;
                            self.transferModel.ChargeFee = coin.ChargeFee;
                        }
                        [self.router pushToTransferInfoViewControllerBulk:self.transferModel withDict:self.infoArray];
                    }
                    
                }
            }
            break;
        }
        
        default:
            break;
    }
}

#pragma mark - Contact customer service for abnormal currency

- (void)coinExceptionToMCustomer {
    AlertActionItem *cancelItem = [AlertActionItem defaultCancelItem];
    AlertActionItem *okItem = [AlertActionItem actionWithTitle:NSLocalizedCommon(@"contact") style:(AlertActionStyleDefault) handler:^{
        [self.router pushToHelpFeedback];
    }];
    [self showAlertWithTitle:@""
                     message:NSLocalizedCommon(@"abnomal_currency")
                     actions:[NSArray arrayWithObjects:cancelItem, okItem, nil]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (IBAction)txtValueChange:(UITextField *)sender {
    NSString *str = sender.text;
    if (str && str.length > 0) {
        self.isSearch = YES;
        [self.searchArr removeAllObjects];
        for (FBCoin *coin in self.coinArr) {
            if ([coin.Code rangeOfString:str].location != NSNotFound || [[coin.Code uppercaseString] rangeOfString:[str uppercaseString]].location != NSNotFound) {
                [self.searchArr addObject:coin];
            }
        }
    } else {
        self.isSearch = NO;
    }
    [self.mTableView reloadData];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //Separate the array by cs, and separate the string by ""
    BOOL canChange = [string isEqualToString:filtered];
    return canChange;
}
#pragma mark - StatefulViewController actions

- (void)didTapRefresh:(id)sender{
    [self loadData];
}

@end
