#import "HPNavigationRouter.h"

@class FPStatementOM;

@protocol StatementRouterInterface <HPNavigationRouterDelegate>

- (void)pushToStatementDetailWith:(FPStatementOM *)statementOM :(id)viewController;
-(void)pushToExport;

@end

NS_ASSUME_NONNULL_BEGIN

@interface StatementRouter : HPNavigationRouter <StatementRouterInterface>

@end

NS_ASSUME_NONNULL_END
