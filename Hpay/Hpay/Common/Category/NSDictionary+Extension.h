//
//  NSDictionary+Extension.h
//  FiiiPay
//
//  Created by Singer on 2019/5/20.
//  Copyright © 2019 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (Extension)

/**
 获取url的所有参数
 @param url 需要提取参数的url
 @return NSDictionary
 */
+(NSDictionary *) parameterWithURL:(NSURL *) url;
@end

NS_ASSUME_NONNULL_END
