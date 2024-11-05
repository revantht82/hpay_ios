#import "HPHomeRouter.h"
#import "ChooseCoinViewController.h"
#import "HuaZhuanViewController.h"
#import "RequestmoneyViewController.h"
#import "HomeViewController.h"
#import "RequestmoneyIndividualViewController.h"
#import "StatementDetailViewController.h"
#import "FPUtils.h"
#import "NotificationCenterViewController.h"
#import "TransferViewController.h"

@implementation HPHomeRouter

#pragma mark - Controller Properties

- (ChooseCoinViewController *)chooseCoinViewControllerTransferActionType {
    ChooseCoinViewController *chooseCoinVC = [SB_WALLET instantiateViewControllerWithIdentifier:[ChooseCoinViewController className]];
    [chooseCoinVC configCoinActionType:CoinActionTypeTransfer];
    return chooseCoinVC;
}

- (ChooseCoinViewController *)chooseCoinViewControllerTransferActionTypeScan {
    ChooseCoinViewController *chooseCoinVC = [SB_WALLET instantiateViewControllerWithIdentifier:[ChooseCoinViewController className]];
    [chooseCoinVC configCoinActionType:CoinActionTypeTransferScan];
    return chooseCoinVC;
}

- (ChooseCoinViewController *)chooseRequestViewControllerActionType {
    ChooseCoinViewController *chooseCoinVC = [SB_WALLET instantiateViewControllerWithIdentifier:[ChooseCoinViewController className]];
    [chooseCoinVC configCoinActionType:CoinActionTypeRequest];
    return chooseCoinVC;
}

- (ChooseCoinViewController *)chooseCoinViewControllerDepositActionType {
    ChooseCoinViewController *chooseCoinVC = [SB_WALLET instantiateViewControllerWithIdentifier:[ChooseCoinViewController className]];
    [chooseCoinVC configCoinActionType:CoinActionTypeDeposit];
    return chooseCoinVC;
}

- (ChooseCoinViewController *)chooseCoinViewControllerWithdrawalActionType {
    ChooseCoinViewController *chooseCoinVC = [SB_WALLET instantiateViewControllerWithIdentifier:[ChooseCoinViewController className]];
    [chooseCoinVC configCoinActionType:CoinActionTypeWithdrawal];
    return chooseCoinVC;
}

- (HuaZhuanViewController *)huaZhuanViewController {
    HuaZhuanViewController *vc = [SB_HOME instantiateViewControllerWithIdentifier:[HuaZhuanViewController className]];
    return vc;
}

- (RequestmoneyViewController *)requestmoneyViewController {
    RequestmoneyViewController *vc = [SB_HOME instantiateViewControllerWithIdentifier:[RequestmoneyViewController className]];
    return vc;
}

- (NotificationCenterViewController *)NotificationCenterViewController {
    NotificationCenterViewController *vc = [SB_NOTIFICATION_CENTER instantiateViewControllerWithIdentifier:[NotificationCenterViewController className]];
    return vc;
}

- (RequestmoneyIndividualViewController *)requestmoneyIndividualViewController {
    RequestmoneyIndividualViewController *vc = [SB_HOME instantiateViewControllerWithIdentifier:[RequestmoneyIndividualViewController className]];
    return vc;
}

- (nonnull TransferViewController *)transferViewController {
    TransferViewController *vc = [SB_HOME instantiateViewControllerWithIdentifier:[TransferViewController className]];
    return vc;
}
#pragma mark - HPHomeRouterInterface

-(void)pushToChooseCoinTransfer {
    [self pushTo:self.chooseCoinViewControllerTransferActionType];
}

-(void)pushToChooseCoinTransferScan:(NSString *)userHash {
    ChooseCoinViewController* vc = self.chooseCoinViewControllerTransferActionTypeScan;
    vc.userHash = userHash;
    [self pushTo:vc];
}

- (void)pushToTransferWithCoin:(FBCoin *)coin userHash:(NSString*)userHash {
    TransferViewController *vc = self.transferViewController;
    vc.isFromHome = YES;
    //vc.coinModel = coin;
    //vc.userHash = userHash;
    [self pushTo:vc];
}

-(void)pushToChooseCoinDeposit {
    [self pushTo:self.chooseCoinViewControllerDepositActionType];
}

-(void)pushToRequest {
    [self pushTo:self.requestmoneyViewController];
}

-(void)pushToNotificationCenter {
    [self pushTo:self.NotificationCenterViewController];
}


-(void)pushToRequestIndividual {
    [self pushTo:self.requestmoneyIndividualViewController];
}

- (void)pushToChooseCoinWithdrawal {
    [self pushTo:self.chooseCoinViewControllerWithdrawalActionType];
}

- (void)pushToHuZhuan {
    [self pushTo:self.huaZhuanViewController];
}

- (void)presentToQrCodeReader:(HomeViewController *)homeViewController {
    
    self.qrReaderController = [[QRCodeReaderViewController alloc] initWithBackButtonAmdlpTitle:@""];
    self.qrReaderController.showAlbumBtn = YES;
    self.qrReaderController.ctititleLabel.text = NSLocalizedDefault(@"scan");
    self.qrReaderController.delegate = homeViewController.self;
    [self pushTo:self.qrReaderController];
}

- (void)pushToStatementDetailWith:(FPStatementOM *)statementOM {
    
    StatementDetailViewController *vc = [SB_STATEMENT instantiateViewControllerWithIdentifier:[StatementDetailViewController className]];
    StatementListType cType = StatementListInvalid;
    NSString *url = RequestFundRetriveURL;
    [vc configForFundRequestWithType:cType andId:statementOM.OrderId andUrl:url andSeuge:nil];
    [self pushTo:vc];
}
@end
