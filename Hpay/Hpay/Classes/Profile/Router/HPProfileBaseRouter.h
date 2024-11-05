#import "HPNavigationRouter.h"
#import "WithdrawalAddressNavigationRequest.h"

@class SafeAuthViewController;
@class FPCountry;

@protocol HPProfileBaseRouterInterface <HPNavigationRouterDelegate>

- (nonnull SafeAuthViewController *)presentSafeAuthWithPhoneType;
- (nonnull SafeAuthViewController *)presentToSafeAuthWithIsFirstSet:(BOOL)isFirstSet;
- (nonnull SafeAuthViewController *)presentToSafeAuthWithType:(SafeAuthType)safeAuthType;
- (void)pushToWithdrawalAddressWith:(struct WithdrawalAddressNavigationRequest)request;
- (void)pushToWithdrawalAddAddressWith:(struct WithdrawalAddressNavigationRequest)request;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HPProfileBaseRouter : HPNavigationRouter <HPProfileBaseRouterInterface>

@end

NS_ASSUME_NONNULL_END
