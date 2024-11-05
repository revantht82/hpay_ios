//
//  GLCNetworkRequest.h
//  GrandeurLifestyleClub
//
//  Created by apple on 2017/6/23.
//  Copyright © 2017年 fiiipay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

typedef void (^RequestSuccessful)(NSDictionary *_Nullable jsonDict);
typedef void (^RequestFailed)(NSURLSessionDataTask *_Nullable task, NSError *_Nullable error);
typedef void(^RequestDownloadProgress)(NSProgress *_Nullable downloadProgress);
typedef void(^FPRequestSuccessful)(NSObject *_Nullable data, NSObject *_Nullable extension, NSString *_Nullable message);
typedef void(^FPRequestFailed)(NSInteger code, NSString *_Nullable message);

@interface GLCNetworkRequest : NSObject

+ (void)login;

+ (void)handleAuthError;
@end
