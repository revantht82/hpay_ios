//
//  NSDate+Extension.m
//  GiiiPlus
//
//  Created by Mac on 2017/9/14.
//
//

#define SECONDS 1
#define MINUTES 60*SECONDS
#define HOURS 60*MINUTES
#define DAY 24*HOURS

@implementation NSDate (Extension)
+ (NSString *)getFormatTimeFromMilliSeconds:(long long)mili {
    NSDate *date = [self getDateTimeFromMilliSeconds:mili];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

+ (NSString *)getFormatTimeFromMillSeconds:(long long)mili timeFormat:(NSDateFormatter *)timeFormat {
    NSDate *date = [self getDateTimeFromMilliSeconds:mili];
    NSString *dateString = [timeFormat stringFromDate:date];
    return dateString;
}

+ (NSDate *)getDateTimeFromMilliSeconds:(long long)miliSeconds {
    NSTimeInterval tempMilli = (NSTimeInterval) miliSeconds;
    //这里的.0一定要加上，不然除下来的数据会被截断导致时间不一致(double转longlong会有精度缺失)
    NSTimeInterval seconds = tempMilli / 1000.0;
    return [NSDate dateWithTimeIntervalSince1970:seconds];
}

+ (long long)getDateTimeTOMilliSeconds:(NSDate *)datetime {
    NSTimeInterval interval = [datetime timeIntervalSince1970];
    long long totalMilliseconds = interval * 1000;
    return totalMilliseconds;
}

+ (long long)getDateTimeFromDateFormatString:(NSString *)formatString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:formatString];
    return [self getDateTimeTOMilliSeconds:date];
}

+ (NSDate *)getDateFormDateString:(NSString *)timeString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:timeString];
    return date;
}

+ (NSString *)getNowTimeFromTimeFormatString:(NSString *)formatString; {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = formatString;
    return [dateFormatter stringFromDate:[NSDate date]];
}

+ (NSString *)getTimeFromeDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)getTodayTimeString {
    return [self getNowTimeFromTimeFormatString:@"yyyy-MM-dd"];
}

+ (NSInteger)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {
        return 1;
    } else if (result == NSOrderedAscending) {
        return -1;
    }
    return 0;

}

- (NSString *)lastUpdateTimeString{
    if (!self){
        return @"";
    }
    
    NSTimeInterval elapsedTime = [[[NSDate alloc] init] timeIntervalSinceDate:self];
    
    if (elapsedTime < MINUTES){
        return NSLocalizedString(@"updated_seconds_ago", @"");
    }else if (elapsedTime < HOURS){
        return [NSString stringWithFormat:NSLocalizedString(@"updated_minutes_ago", @""), (int)(elapsedTime / (MINUTES))];
    }else if (elapsedTime < DAY){
        return [NSString stringWithFormat:NSLocalizedString(@"updated_hours_ago", @""), (int)(elapsedTime / (HOURS))];
    }else{
        return [NSString stringWithFormat:NSLocalizedString(@"updated_days_ago", @""), (int)(elapsedTime / (DAY))];
    }
}
@end




