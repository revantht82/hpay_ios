//
//  AFHTTPSessionManagerSingleInstance.m
//  GrandeurCollect
//
//  Created by apple on 2017/6/23.
//  Copyright © 2017年 fiiipay. All rights reserved.
//

#import "AFHTTPSessionManagerSingleInstance.h"

@interface AFHTTPSessionManagerSingleInstance ()
@end

@implementation AFHTTPSessionManagerSingleInstance

static AFHTTPSessionManager *manager;

+ (AFHTTPSessionManager *)sharedHTTPSession {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:kProductionBaseURL]];
        NSString *userAgent = [manager.requestSerializer.HTTPRequestHeaders valueForKey:@"User-Agent"];
        [[NSUserDefaults standardUserDefaults] setObject:userAgent forKey:@"Http-User-Agent"];
        manager.requestSerializer.timeoutInterval = 10;//设置请求超时时间为20秒
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/plain", @"text/html", nil];
        [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        ((AFJSONResponseSerializer *) manager.responseSerializer).removesKeysWithNullValues = YES;
        [manager.requestSerializer setValue:kAppVersion forHTTPHeaderField:@"AppVersion"];
        [manager.requestSerializer setValue:@"HPay" forHTTPHeaderField:@"Referrer"];
    });
    return manager;
}

@end
