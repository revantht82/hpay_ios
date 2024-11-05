#import "HPProfileBaseRouter.h"

@protocol SecurityRouterInterface <HPProfileBaseRouterInterface>

- (void)presentToPinSetForVerify:(BOOL)isMustReset;
- (void)presentToPinSetForReSetNewPIN;
- (void)presentSecurityAuthWithSuccessHandler:(void(^_Nullable)(NSString * _Nullable securityPassword))setSecurityAuthSuccessBlock;

@end

NS_ASSUME_NONNULL_BEGIN

@interface SecurityRouter : HPProfileBaseRouter <SecurityRouterInterface>

@end

NS_ASSUME_NONNULL_END
