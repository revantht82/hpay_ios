//
//  NSString+UTCTimeStamp.m
//  FiiiPay
//
//  Created by apple on 2018/4/16.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "NSString+UTCTimeStamp.h"

@implementation NSString (UTCTimeStamp)
//时间戳字符串1469193006001（毫秒）1469193006.001（毫秒，1469193006001234（微秒）1469193006.001234（微秒）转 UTC时间2016-08-11T07:00:55.611Z
+ (NSString *)timespToUTCFormat:(NSString *)timesp
{
    NSString *timeString = [timesp stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (timeString.length >= 10) {
        NSString *second = [timeString substringToIndex:10];
        NSString *milliscond = [timeString substringFromIndex:10];
        NSString * timeStampString = [NSString stringWithFormat:@"%@.%@",second,milliscond];
        NSTimeInterval _interval=[timeStampString doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormatter setTimeZone:timeZone];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        NSString *dateString = [dateFormatter stringFromDate:date];
        
        return dateString;
    }
    return @"";
}

//UTC时间戳转当前系统时区时间yyyy-MM-dd hh:mm(需要自己截取)
+ (NSString *)timespToSystemTimeZoneFormat:(NSString *)timesp
{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *localDate = [NSDate dateWithTimeIntervalSince1970:[timesp doubleValue]/1000.0];     //＋0000 表示的是当前时间是个世界时间。
//    NSDate *d = [self getNowDateFromatAnDate:localDate];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *responseTime = [dateFormatter stringFromDate:localDate];
    return responseTime;
}

+ (NSString *)datespToSystemTimeZoneFormat:(NSString *)timesp
{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *localDate = [NSDate dateWithTimeIntervalSince1970:[timesp doubleValue]/1000.0];     //＋0000 表示的是当前时间是个世界时间。
//    NSDate *d = [self getNowDateFromatAnDate:localDate];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *responseTime = [dateFormatter stringFromDate:localDate];
    return responseTime;
}

//UTC时间戳转当前系统时区时间yyyy-MM-dd hh:mm:ss(需要自己截取)
+ (NSString *)timespToSystemTimeZoneFormatSecond:(NSString *)timesp
{
    //2013-08-03T12:53:51+0800     UTC时间格式下的北京时间，可以看到北京时间＝ UTC + 8小时。
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *localDate = [NSDate dateWithTimeIntervalSince1970:[timesp doubleValue]/1000.0];     //＋0000 表示的是当前时间是个世界时间。
//    NSDate *d = [self getNowDateFromatAnDate:localDate];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *responseTime = [dateFormatter stringFromDate:localDate];
    return responseTime;
}

+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate] ;
    return destinationDateNow;
}
@end
