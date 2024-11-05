#import "HCPayMerchantRouter.h"
#import "PayMerchantStatusViewController.h"
#import "StatementDetailViewController.h"
#import "FPStatementOM.h"
#import "FPUtils.h"
#import "PayMerchantViewController.h"
#import "StatementViewController.h"
#import "HCPayMerchantRouter.h"
#import "FPNavigationController.h"

@implementation HCPayMerchantRouter

- (PayMerchantStatusViewController *)payMerchantStatusViewController {
    PayMerchantStatusViewController * vc = [SB_DEEPLINK instantiateViewControllerWithIdentifier:[PayMerchantStatusViewController className]];
    return vc;
}

- (StatementDetailViewController *)statementDetailViewController {
    StatementDetailViewController *vc = [SB_STATEMENT instantiateViewControllerWithIdentifier:[StatementDetailViewController className]];
    return vc;
}

- (void)pushToPayMerchantStatusWithRequest:(struct PayMerchantStatusNavigationRequest)request {
    PayMerchantStatusViewController *vc = self.payMerchantStatusViewController;
    vc.paymentResponse = request.paymantResponse;
    [self pushTo:vc];
}

- (void)pushToStatementsList{
    StatementViewController *statementVC = (StatementViewController *) [SB_STATEMENT instantiateViewControllerWithIdentifier:@"StatementViewController"];
    statementVC.title = NSLocalizedDefault(@"transactionHistoryTitle");
    FPNavigationController *navStatement = [[FPNavigationController alloc] initWithRootViewController:statementVC];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:navStatement animated:YES completion:nil];
}

- (void)pushToStatementDetailWithOrderId:(NSString*)orderId replaceBackButtonWithDismiss:(BOOL)dismissEnabled {
    StatementDetailViewController *vc = self.statementDetailViewController;
    if (dismissEnabled) {
        [vc configureDismissBarButtonItem];
    }
    
    StatementListType cType = StatementListTypeMerchantPaymentIn;
    struct MStatement mStatement = [FPUtils fetchDetailMStatementByListType:cType];
    NSString *url = [FPUtils convertByChar:mStatement.url];
    NSString *title = [FPUtils convertByChar:mStatement.title];
    vc.title = title;
    [vc configWithType:cType andId:orderId andUrl:url];
    [self pushTo:vc];
}
@end
