//
//  FPProfileCoin.h
//  FiiiPay
//
//  Created by Singer on 2018/4/16.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FPProfileCoin : NSObject
@property(nonatomic, assign) NSInteger Id;

/**
 图标的地址，客户端需要拼接地址下载图片
 */
@property(nonatomic, copy) NSString *IconUrl;

/**
 币的简称，比如：BTC
 */
@property(nonatomic, copy) NSString *Code;

/**
 币的名称，比如：Bitcoin
 */
@property(nonatomic, copy) NSString *Name;

/**
 是否固定到顶端
 */
@property(nonatomic, assign) BOOL Fixed;
@end
