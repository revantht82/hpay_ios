//
//  VerifyPinUseCase.m
//  Hpay
//
//  Created by Ugur Bozkurt on 29/09/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "VerifyPinUseCase.h"
#import "HimalayaPayAPIManager.h"
#import "AES128.h"
#import "ApiError.h"

@implementation VerifyPinUseCase

- (void)executeWithRequest:(id)request completionHandler:(void (^)(id _Nullable, NSInteger, NSString * _Nullable))completionHandler{
    NSString *pin = [AES128 encryptAES128:request];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
    [HimalayaPayAPIManager POST:AccountVerifyPinURL parameters:@{@"Pin": pin} successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        completionHandler(data, kFPNetRequestSuccessCode, NULL);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        ApiError* error = [ApiError errorWithCode:code message:message];
        completionHandler(NULL, code, error.prettyMessage);
    }];
    });
}

@end
