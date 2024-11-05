//
//  HimalayaPayAPIManager.h
//  Hpay
//
//  Created by Olgu Sirman on 18/05/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
@import AFNetworking;

NS_ASSUME_NONNULL_BEGIN

@interface HimalayaPayAPIManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

+ (void)POST:(NSString *_Nullable)URLString
  parameters:(nullable id)parameters
successBlock:(_Nullable FPRequestSuccessful)requestSuccessfulBlock
failureBlock:(_Nullable FPRequestFailed)requestFailureBlock;

+ (void)GET:(NSString *_Nullable)URLString
 parameters:(nullable id)parameters
successBlock:(_Nullable FPRequestSuccessful)requestSuccessfulBlock
failureBlock:(_Nullable FPRequestFailed)requestFailureBlock;

@end

NS_ASSUME_NONNULL_END
