//
//  HCSSOHelper.m
//  Hpay
//
//  Created by Olgu Sirman on 06/07/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "HCSSOHelper.h"

@implementation HCSSOHelper

+ (void)getUserConfigWithCompletionBlock:(void (^)(UserConfigResponse * _Nullable response, NSInteger errorCode, NSString *errorMessage))completionBlock {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSString *appVersion= [[NSUserDefaults standardUserDefaults] valueForKey:@"APP_VERSION"];
        NSString *configurl = [NSString stringWithFormat:@"%@?platform=IOS&appVersion=%@", UserConfig, appVersion];
        [self GET:configurl parameters:nil successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        UserConfigResponse *response = [[UserConfigResponse alloc] initWithDictionary:(NSDictionary *)data];
        NSLog(@"USERCONFIG ASYNC THREAD RUNS");
        completionBlock(response, kFPNetRequestSuccessCode, nil);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        completionBlock(nil, code, message);
    }];
    });
}

+ (void)getUserInfoWithCompletionBlock:(void (^)(id _Nullable, NSInteger, NSString * _Nullable))completionBlock{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
    [self POST:UserInfoURL parameters:nil successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        completionBlock(data, kFPNetRequestSuccessCode, nil);
        NSLog(@"USERINFO ASYNC THREAD RUNS");
    } failureBlock:^(NSInteger code, NSString * _Nullable message) {
        completionBlock(nil, code, message);
    }];
    });
}

+ (void)getProductCategoryWithCompletionBlock:(void (^)(ProductCategoryResponse * _Nullable response, NSInteger errorCode, NSString *errorMessage))completionBlock {
    [self GET:MerchantProductCategory parameters:nil successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        ProductCategoryResponse *response = [[ProductCategoryResponse alloc] initWithDictionary:(NSDictionary *)data];
        completionBlock(response, kFPNetRequestSuccessCode, nil);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        completionBlock(nil, code, message);
    }];
}

@end
