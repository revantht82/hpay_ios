#import "ChooseCoinRouter.h"
#import "TransferViewController.h"
#import "HelpFeedbackViewController.h"
#import "TransferInfoViewController.h"

@implementation ChooseCoinRouter

- (nonnull TransferViewController *)transferViewController {
    TransferViewController *vc = [SB_HOME instantiateViewControllerWithIdentifier:[TransferViewController className]];
    return vc;
}

- (nonnull HelpFeedbackViewController *)helpFeedbackViewController {
    HelpFeedbackViewController *vc = [SB_PROFILE instantiateViewControllerWithIdentifier:[HelpFeedbackViewController className]];
    return vc;
}

- (void)pushToTransferWithCoin:(FBCoin *)coin userHash:(NSString*)userHash {
    TransferViewController *vc = self.transferViewController;
    vc.isFromHome = YES;
    vc.coinModel = coin;
    vc.userHash = userHash;
    [self pushTo:vc];
}

- (void)pushToTransferInfoViewController:(PreTransferModel*)request withDict:(NSDictionary*) dict {
//    FBCoin *coin = [FBCoin new];
//    coin.Id = @"CoinId";
//    coin.Code = @"CoinCode";
    
    TransferInfoViewController *vc = [SB_HOME instantiateViewControllerWithIdentifier:[TransferInfoViewController className]];
    vc.transferModel = request;
    vc.infoDict = dict;
    [self pushTo:vc];
}

- (void)pushToTransferInfoViewControllerBulk:(PreTransferModel*)request withDict:(NSArray*) array{
//    FBCoin *coin = [FBCoin new];
//    coin.Id = @"CoinId";
//    coin.Code = @"CoinCode";
    
    TransferInfoViewController *vc = [SB_HOME instantiateViewControllerWithIdentifier:[TransferInfoViewController className]];
    
    vc.transferModel = request;
    vc.infoArray = array;
    [self pushTo:vc];
}

- (void)pushToHelpFeedback {
    [self pushTo:self.helpFeedbackViewController];
}

@end
