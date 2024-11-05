//
//  NSDate+Extension.h
//  GiiiPlus
//
//  Created by Mac on 2017/9/14.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)


/**
 根据毫秒时间戳返回一个Date

 @param miliSeconds 毫秒时间戳
 @return NSDate
 */
+ (NSDate *)getDateTimeFromMilliSeconds:(long long)miliSeconds;


/**
 根据一个NSDate返回一个毫秒时间戳

 @param datetime NSDate
 @return 毫秒时间戳
 */
+ (long long)getDateTimeTOMilliSeconds:(NSDate *)datetime;


/**
 根据毫秒时间戳返回一个 2017-05-10 的日期格式

 @param miliSeconds 毫秒时间戳
 @return 日期格式
 */
+ (NSString *)getFormatTimeFromMilliSeconds:(long long)miliSeconds;


/**
 根据毫秒时间戳和指定的日期格式 返回对应的时间

 @param mili 毫秒时间戳
 @param timeFormat 日期格式 。eg:"yyyy-MM-dd"
 @return 时间
 */
+ (NSString *)getFormatTimeFromMillSeconds:(long long)mili
                                timeFormat:(NSDateFormatter *)timeFormat;

/**
 根据一个 2017-10-10 的数据返回一个时间戳

 @param formatString 时间字符串
 @return 时间戳
 */
+ (long long)getDateTimeFromDateFormatString:(NSString *)formatString;


/**
 根据一个 2017 - 10 -10 的数据返回一个NSDate

 @param timeString 时间字符串
 @return NSDate
 */
+ (NSDate *)getDateFormDateString:(NSString *)timeString;

/**
 根据一个formatString返回一个对应当前时间的年月日

 @param formatString "yy-MM-dd" 也可以"yy-MM"
 */
+ (NSString *)getNowTimeFromTimeFormatString:(NSString *)formatString;


/**
 根据一个NSDate返回一个对应的年月日

 @param date 日期date
 @return "2017-10-10"
 */
+ (NSString *)getTimeFromeDate:(NSDate *)date;

/**
 返回今天的日期。如2017-10-10

 */
+ (NSString *)getTodayTimeString;


/**
 比较两个日期的大小

 @param oneDay Date
 @param anotherDay Date
 @return 0 表示两个日期一样， 1 表示 oneDay 比 anotherDay大， -1 表示 oneDay 比 anotherDay小
 */
+ (NSInteger)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;


- (NSString *)lastUpdateTimeString;

@end
