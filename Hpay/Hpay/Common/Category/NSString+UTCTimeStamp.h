//
//  NSString+UTCTimeStamp.h
//  FiiiPay
//
//  Created by apple on 2018/4/16.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (UTCTimeStamp)
//时间戳字符串1469193006001（毫秒）1469193006.001（毫秒，1469193006001234（微秒）1469193006.001234（微秒）转 UTC时间2016-08-11T07:00:55.611Z
+ (NSString *)timespToUTCFormat:(NSString *)timesp;

//UTC时间戳转当前系统时区时间yyyy-MM-dd hh:mm(需要自己截取)
+ (NSString *)timespToSystemTimeZoneFormat:(NSString *)timesp;
//UTC时间戳转当前系统时区时间yyyy-MM-dd hh:mm:ss(需要自己截取)
+ (NSString *)timespToSystemTimeZoneFormatSecond:(NSString *)timesp;
+ (NSString *)datespToSystemTimeZoneFormat:(NSString *)timesp;
+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;
@end
