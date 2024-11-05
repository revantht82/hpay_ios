//
//  HimalayaPayAPIManager.m
//  Hpay
//
//  Created by Olgu Sirman on 18/05/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "HimalayaPayAPIManager.h"
#import "AFHTTPSessionManagerSingleInstance.h"
#import "HimalayaAuthManager.h"
#import "HimalayaAuthManagerErrorType.h"
#import "NSObject+Extension.h"
#import <AFNetworking/AFNetworking.h>

@implementation HimalayaPayAPIManager

+ (instancetype)sharedManager {
    static HimalayaPayAPIManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HimalayaPayAPIManager manager] initWithBaseURL:[NSURL URLWithString:kProductionBaseURL]];
        NSString *userAgent = [manager.requestSerializer.HTTPRequestHeaders valueForKey:@"User-Agent"];
        [[NSUserDefaults standardUserDefaults] setObject:userAgent forKey:@"Http-User-Agent"];
        manager.requestSerializer.timeoutInterval = 10;
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/plain", @"text/html", nil];
        [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        ((AFJSONResponseSerializer *) manager.responseSerializer).removesKeysWithNullValues = YES;
        [manager.requestSerializer setValue:kAppVersion forHTTPHeaderField:@"AppVersion"];
        [manager.requestSerializer setValue:@"HimalayaPay" forHTTPHeaderField:@"Referrer"];
        [manager.requestSerializer setValue:[NSUUID UUID].UUIDString forHTTPHeaderField:@"x-requestid"];
#if MOCK
        [manager.requestSerializer setValue:[@"sessionId=" stringByAppendingString:UIDevice.currentDevice.name] forHTTPHeaderField:@"Cookie"];
#endif
    });
    
    return manager;
}

+ (void)POST:(NSString *_Nullable)URLString
  parameters:(nullable id)parameters
successBlock:(_Nullable FPRequestSuccessful)requestSuccessfulBlock
failureBlock:(_Nullable FPRequestFailed)requestFailureBlock {
    WS(weakSelf);
    [[HimalayaAuthManager sharedManager] refreshAccessTokenIfNeededWithSuccessHandler:^(NSString * _Nullable accessToken) {
        [[HimalayaPayAPIManager sharedManager] POST:URLString parameters:parameters headers:[weakSelf prepareHeadersWithAccessToken:accessToken] progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [weakSelf handleSuccessConfigurationWithDictionary:responseObject
                                                  successBlock:requestSuccessfulBlock
                                                  failureBlock:requestFailureBlock];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [HimalayaPayAPIManager handleErrorWithError:[HimalayaPayAPIManager errorWithTask:task error:error] failureBlock:requestFailureBlock];
        }];
        } errorHandler:^(NSError * _Nullable error) {
            [HimalayaPayAPIManager handleErrorWithError:error failureBlock:requestFailureBlock];
        }];
}

+ (void)GET:(NSString *_Nullable)URLString
 parameters:(nullable id)parameters
successBlock:(_Nullable FPRequestSuccessful)requestSuccessfulBlock
failureBlock:(_Nullable FPRequestFailed)requestFailureBlock {
    WS(weakSelf);
    [[HimalayaAuthManager sharedManager] refreshAccessTokenIfNeededWithSuccessHandler:^(NSString * _Nullable accessToken) {
        [[HimalayaPayAPIManager sharedManager] GET:URLString parameters:parameters headers:[weakSelf prepareHeadersWithAccessToken:accessToken] progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [weakSelf handleSuccessConfigurationWithDictionary:(NSDictionary *)responseObject
                                                  successBlock:requestSuccessfulBlock
                                                  failureBlock:requestFailureBlock];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [HimalayaPayAPIManager handleErrorWithError:[HimalayaPayAPIManager errorWithTask:task error:error] failureBlock:requestFailureBlock];
        }];
    } errorHandler:^(NSError * _Nullable error) {
        [HimalayaPayAPIManager handleErrorWithError:error failureBlock:requestFailureBlock];
    }];
}

+ (NSError *)errorWithTask:(NSURLSessionDataTask *)task error:(NSError *)error{
    NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
    return [NSError errorWithDomain:error.domain code:response.statusCode userInfo:error.userInfo];
}

+ (void)handleErrorWithError:(NSError * _Nullable) error failureBlock:(_Nullable FPRequestFailed)requestFailureBlock{
    [HCLogger recordErrorWithError:error];
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"%@", error);
#endif
    if (![self isNetworkConnected]){
        requestFailureBlock(kFPNetWorkErrorCode, nil);
    }else if (error.code == 401){
        [GLCNetworkRequest handleAuthError];
        requestFailureBlock(kErrorCodeUserNotAuthorized, nil);
    } else {
        requestFailureBlock(kFPUnknownErrorCode, nil);
    }
}

+ (void)handleSuccessConfigurationWithDictionary:(NSDictionary * _Nullable)jsonDict
                                    successBlock:(_Nullable FPRequestSuccessful)requestSuccessfulBlock
                                    failureBlock:(_Nullable FPRequestFailed)requestFailureBlock {
    NSInteger code = [jsonDict[@"Code"] integerValue];
    if (code == kFPNetRequestSuccessCode || code == kErrorCodeMarketPriceNotAvailable) {
        if (jsonDict[@"Data"]){
            requestSuccessfulBlock(jsonDict[@"Data"], jsonDict[@"Extension"], jsonDict[@"Message"]);
        } else {
            requestSuccessfulBlock(jsonDict, NULL, NULL);
        }
        if (code == kErrorCodeMarketPriceNotAvailable) {
            requestFailureBlock(code, nil);
        }
    } else if (code == 10001) {
        requestFailureBlock(code, nil);
    } else if (code == kFPNetRequestServerErrorCode) {
        NSString *message = jsonDict[@"Message"];
        if (message.length == 0) {
            message = NSLocalizedCommon(@"unexpected_error");
        }
        requestFailureBlock(code, message);
    } else if (code == 10021) {
        requestFailureBlock(code, nil);
    } else {
        requestFailureBlock(code, jsonDict[@"Message"]);
    }
}

+ (nonnull NSDictionary<NSString *, NSString *> *)prepareHeadersWithAccessToken:(nullable NSString *)accessToken {
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    NSString *language = [FPLanguageTool sharedInstance].language;
    if (language) {
        [dictionary setValue:language forKey:@"Accept-Language"];
    }
    
    if (accessToken && (![accessToken isEqualToString:@""])) {
        NSString *authorizationStr = [NSString stringWithFormat:@"%@ %@", @"Bearer", accessToken];
        [dictionary setValue:authorizationStr forKey:@"Authorization"];
    }
    
    return dictionary;
}

@end
