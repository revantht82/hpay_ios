@class HCRetrieveOrderResponseModel;
@class HCPaymentCreateResponseModel;
@class HCPaymentCancelResponseModel;

#ifndef DeeplinkRequestHandlers_h
#define DeeplinkRequestHandlers_h

typedef void(^RetrieveOrderSuccessfulHandler)(HCRetrieveOrderResponseModel *_Nonnull response);
typedef void(^RetrieveOrderFailureHandler)(NSInteger code, NSString * _Nullable message);

typedef void(^PaymentCreateSuccessfulHandler)(HCPaymentCreateResponseModel *_Nonnull response);
typedef void(^PaymentCreateFailureHandler)(NSInteger code, NSString * _Nullable message);

typedef void(^PaymentCancelSuccessfulHandler)(HCPaymentCancelResponseModel *_Nonnull response);
typedef void(^PaymentCancelFailureHandler)(NSInteger code, NSString * _Nullable message);

#endif /* DeeplinkRequestHandlers_h */
