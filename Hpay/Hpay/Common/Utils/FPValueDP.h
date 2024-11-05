//
//  FPValueDP.h
//  GiiiWalletMerchant
//
//  Created by apple on 2017/10/17.
//  Copyright © 2017年 fiipay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FPValueDP : NSObject
//获取中划线，用于旧价格划掉，参数textStr要加线的文字,原字符串textStr
+ (NSMutableAttributedString *)getCenterLineStr:(NSString *)lineStr WithString:(NSString *)textStr;

//获取下划线，用于超链接文字，参数textStr要加线的范围Range,原字符串textStr
+ (NSMutableAttributedString *)getUnderLineStr:(NSString *)lineStr WithString:(NSString *)textStr;

//金钱格式化
+ (NSString *)formatWithPriceBy:(NSString *)priceStr;


+ (NSString *)reviseString:(NSString *)str;


+ (NSString *)priceFormat:(NSString *)str;

+ (double)productFromAStr:(NSString *)aStr withBStr:(NSString *)bStr;

+ (double)pFromAStr:(NSString *)aStr withBStr:(NSString *)bStr;


+ (NSString *)A:(NSString *)a jiaB:(NSString *)b;

+ (NSString *)A:(NSString *)a jiaB:(NSString *)b withPlace:(NSInteger)place;

+ (NSString *)A:(NSString *)a jiaB:(NSString *)b withPlace:(NSInteger)place isKillEndingZero:(BOOL)kill;

+ (NSString *)A:(NSString *)a jianB:(NSString *)b;

+ (NSString *)A:(NSString *)a jianB:(NSString *)b withPlace:(NSInteger)place;

+ (NSString *)A:(NSString *)a jianB:(NSString *)b withPlace:(NSInteger)place isKillEndingZero:(BOOL)kill;

+ (NSString *)A:(NSString *)a chengyiB:(NSString *)b;


/**
 只舍去保留小数
 例如：1.255 保留2位小数 1.25
 */
+ (NSString *)A:(NSString *)a chengyiB:(NSString *)b withPlace:(NSInteger)place;

+ (NSString *)A:(NSString *)a chengyiB:(NSString *)b withPlace:(NSInteger)place isKillEndingZero:(BOOL)kill;

+ (NSString *)A:(NSString *)a chengyiB:(NSString *)b withPlace:(NSInteger)place roundingMode:(NSRoundingMode)roundingMode;

+ (NSString *)A:(NSString *)a chuyiB:(NSString *)b;

/**
 只舍去保留小数
 例如：1.255 保留2位小数 1.25
 */
+ (NSString *)A:(NSString *)a chuyiB:(NSString *)b withPlace:(NSInteger)place;

+ (NSString *)A:(NSString *)a chuyiB:(NSString *)b withPlace:(NSInteger)place isKillEndingZero:(BOOL)kill;

+ (NSString *)A:(NSString *)a chuyiB:(NSString *)b withPlace:(NSInteger)place roundingMode:(NSRoundingMode)roundingMode;

+ (BOOL)A:(NSString *)a dayuB:(NSString *)b;

+ (BOOL)A:(NSString *)a dayuDengyuB:(NSString *)b;

+ (BOOL)A:(NSString *)a dengyuB:(NSString *)b;

+ (BOOL)A:(NSString *)a xiaoyuB:(NSString *)b;

+ (BOOL)A:(NSString *)a xiaoyuDengyuB:(NSString *)b;

+ (NSString *)string:(NSString *)originStr withPlace:(NSInteger)place;


+ (NSString *)decimalSeparatorStr:(NSString *)string;
@end
