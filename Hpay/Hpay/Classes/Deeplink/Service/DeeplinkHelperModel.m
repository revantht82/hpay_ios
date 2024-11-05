#import "DeeplinkHelperModel.h"
#import "HCRetrieveOrderResponseModel.h"
#import "HCPaymentCreateResponseModel.h"
#import "HCPaymentCancelResponseModel.h"

@implementation DeeplinkHelperModel

+ (void)retrieveOrder:(struct RetrieveOrderRequest)request
       successHandler:(RetrieveOrderSuccessfulHandler)successHandler
       failureHandler:(RetrieveOrderFailureHandler)failureHandler {
    
    if (!request.orderId) {
        //throw failureHandler
        return;
    }
    
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:kMerchantOrderRetrieveURL];
    [components setQueryItems:@[[NSURLQueryItem queryItemWithName:@"orderId" value:request.orderId]]];
    
    [self GET:[[components URL] absoluteString] parameters:nil successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        
        if ((data != nil) && [data isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *responseModel = (NSDictionary *)data;
            HCRetrieveOrderResponseModel *retrieveOrderResponseModel = [HCRetrieveOrderResponseModel fromJSONDictionary:responseModel];
            
            if (retrieveOrderResponseModel) {
                successHandler(retrieveOrderResponseModel);
            } else {
                // TODO: localizedLater
                failureHandler(kFPNetRequestSuccessCode, @"Serialization error");
            }
        } else {
            // TODO: localizedLater
            failureHandler(kFPNetRequestSuccessCode, @"Response Data error");
        }
        
    } failureBlock:^(NSInteger code, NSString * _Nullable message) {
        failureHandler(code, message);
    }];
}

+ (void)paymentCreate:(struct PaymentCreateRequest)request
       successHandler:(PaymentCreateSuccessfulHandler)successHandler
       failureHandler:(PaymentCreateFailureHandler)failureHandler {
    
    if (!request.orderId) {
        //throw failureHandler
        return;
    }
    
    NSURL *paymentCreateURL = [NSURL URLWithString:kMerchantPaymentCreateURL];
    
    [self POST:[paymentCreateURL absoluteString] parameters:@{@"OrderId":request.orderId} successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        
        if ((data != nil) && [data isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *responseModel = (NSDictionary *)data;
            HCPaymentCreateResponseModel *paymentCreateResponseModel = [HCPaymentCreateResponseModel fromJSONDictionary:responseModel];
            
            if (paymentCreateResponseModel) {
                successHandler(paymentCreateResponseModel);
            } else {
                // TODO: localizedLater
                failureHandler(kFPNetRequestSuccessCode, @"Serialization error");
            }
        } else {
            // TODO: localizedLater
            failureHandler(kFPNetRequestSuccessCode, @"Response Data error");
        }
        
    } failureBlock:^(NSInteger code, NSString * _Nullable message) {
        failureHandler(code, message);
    }];
    
}

+ (void)paymentCancel:(struct PaymentCancelRequest)request
       successHandler:(PaymentCancelSuccessfulHandler)successHandler
       failureHandler:(PaymentCancelFailureHandler)failureHandler {
    
    if (!request.orderId) {
        // TODO: Throw?
        return;
    }
    
    NSURL *paymentCancelURL = [NSURL URLWithString:kMerchantPaymentCancelURL];
    
    [self POST:[paymentCancelURL absoluteString] parameters:@{@"OrderId":request.orderId} successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        if ((data != nil) && [data isKindOfClass:[NSDictionary class]]) {

            NSDictionary *responseModel = (NSDictionary *)data;
            HCPaymentCancelResponseModel *paymentCancelResponseModel = [HCPaymentCancelResponseModel fromJSONDictionary:responseModel];

            if (paymentCancelResponseModel) {
                successHandler(paymentCancelResponseModel);
            } else {
                // TODO: To be localised
                failureHandler(kFPNetRequestSuccessCode, @"Serialization error");
            }
        } else {
            // TODO: To be localised
            failureHandler(kFPNetRequestSuccessCode, @"Response Data error");
        }
    } failureBlock:^(NSInteger code, NSString * _Nullable message) {
        failureHandler(code, message);
    }];
}

@end
