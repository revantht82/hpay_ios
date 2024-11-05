//
//  NSDictionary+Extension.m
//  FiiiPay
//
//  Created by Singer on 2019/5/20.
//  Copyright © 2019 Himalaya. All rights reserved.
//

#import "NSDictionary+Extension.h"

@implementation NSDictionary (Extension)


/**
 获取url的所有参数
 @param url 需要提取参数的url
 @return NSDictionary
 */
+(NSDictionary *) parameterWithURL:(NSURL *) url{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    //传入url创建url组件类
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url.absoluteString];
    
    //回调遍历所有参数，添加入字典
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        parm[obj.name] = obj.value;
    }];
    
    return parm;

}
@end
