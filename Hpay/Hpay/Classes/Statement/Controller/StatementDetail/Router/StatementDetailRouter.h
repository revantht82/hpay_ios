#import "HPNavigationRouter.h"

@class FPStatementDetailOM;

@protocol StatementDetailRouterInterface <HPNavigationRouterDelegate>
@end

NS_ASSUME_NONNULL_BEGIN

@interface StatementDetailRouter : HPNavigationRouter <StatementDetailRouterInterface>

-(void)pushToPaymentSuccessfulWith:(NSDictionary*)dictionary;

@end

NS_ASSUME_NONNULL_END
