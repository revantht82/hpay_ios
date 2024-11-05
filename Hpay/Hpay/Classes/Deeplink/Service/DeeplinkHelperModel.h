#import "HimalayaPayAPIManager.h"
#import "DeeplinkRequestHandlers.h"
#import "PayMerchantRefreshErrorReason.h"

struct RetrieveOrderRequest {
    NSString * _Nonnull orderId;
};

struct PaymentCreateRequest {
    NSString * _Nonnull orderId;
};

struct PaymentCancelRequest {
    NSString * _Nonnull orderId;
};


NS_ASSUME_NONNULL_BEGIN

@interface DeeplinkHelperModel : HimalayaPayAPIManager

+ (void)retrieveOrder:(struct RetrieveOrderRequest)request
       successHandler:(RetrieveOrderSuccessfulHandler)successHandler
       failureHandler:(RetrieveOrderFailureHandler)failureHandler;

+ (void)paymentCreate:(struct PaymentCreateRequest)request
       successHandler:(PaymentCreateSuccessfulHandler)successHandler
       failureHandler:(PaymentCreateFailureHandler)failureHandler;

+ (void)paymentCancel:(struct PaymentCancelRequest)request
       successHandler:(PaymentCancelSuccessfulHandler)successHandler
       failureHandler:(PaymentCancelFailureHandler)failureHandler;

@end

NS_ASSUME_NONNULL_END
