#import "HPNavigationRouter.h"
#import "PayMerchantViewController.h"
#import "PayMerchantRefreshErrorReason.h"

@class HCPaymentCreateResponseModel;

struct PayMerchantStatusNavigationRequest {
    HCPaymentCreateResponseModel * _Nullable paymantResponse;
};

@protocol HPPaymentMerchantRouterInterface <HPNavigationRouterDelegate>

- (void)pushToPayMerchantStatusWithRequest:(struct PayMerchantStatusNavigationRequest)request;
- (void)pushToStatementDetailWithOrderId:(NSString* _Nonnull)orderId replaceBackButtonWithDismiss:(BOOL)dismissEnabled;
- (void)pushToStatementsList;
@end

NS_ASSUME_NONNULL_BEGIN

@interface HCPayMerchantRouter : HPNavigationRouter <HPPaymentMerchantRouterInterface>

@end

NS_ASSUME_NONNULL_END
