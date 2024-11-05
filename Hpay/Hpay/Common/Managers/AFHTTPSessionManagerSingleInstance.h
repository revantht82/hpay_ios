//
//  AFHTTPSessionManagerSingleInstance.h
//  GrandeurCollect
//
//  Created by apple on 2017/6/23.
//  Copyright © 2017年 fiiipay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface AFHTTPSessionManagerSingleInstance : NSObject
+ (AFHTTPSessionManager *)sharedHTTPSession;
@end
