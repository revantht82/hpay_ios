#import "HPNavigationRouter.h"
#import "FBCoin.h"
#import "PreTransferModel.h"

@class FBCoin;

@protocol ChooseCoinRouterInterface <HPNavigationRouterDelegate>

- (void)pushToWithdrawalCoinWithCoin:(FBCoin *)coin;
- (void)pushToTransferWithCoin:(FBCoin *)coin userHash:(NSString*)userHash;
- (void)pushToTransferInfoViewController:(PreTransferModel*)request withDict:(NSDictionary*) dict;
- (void)pushToTransferInfoViewControllerBulk:(PreTransferModel*)request withDict:(NSArray*) array;
- (void)pushToHelpFeedback;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ChooseCoinRouter : HPNavigationRouter <ChooseCoinRouterInterface>

@end

NS_ASSUME_NONNULL_END
