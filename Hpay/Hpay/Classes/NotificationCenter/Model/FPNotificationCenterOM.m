//
//  FPNotificationCenterOM.m
//  FiiiPay
//
//  Created by apple on 2018/4/16.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "FPNotificationCenterOM.h"
#import "NSString+UTCTimeStamp.h"

@implementation FPNotificationCenterOM
MJCodingImplementation

- (id)copyWithZone:(NSZone *)zone {
    FPNotificationCenterOM *copy = [[[self class] allocWithZone:zone] init];
    copy.NotificationId = self.NotificationId;
    copy.Timestamp = self.Timestamp;
    copy.Title = self.Title;
    copy.Message = self.Message;
    copy.IsRead = self.IsRead;
    return copy;
}

+ (NSDictionary *)mDataReplaceDictionary {
    return @{
            @"NotificationId": @"Id",
            @"Timestamp": @"TimeStamp",
            @"Title": @"Title",
            @"Message": @"Message",
            @"IsRead": @"IsRead",
    };
}

+ (NSArray *)mModelArrayWithData:(NSArray *)data {
    [FPNotificationCenterOM mj_setupReplacedKeyFromPropertyName:^NSDictionary * {
        return [FPNotificationCenterOM mDataReplaceDictionary];
    }];
    return [self mj_objectArrayWithKeyValuesArray:data];
}

+ (instancetype)mModelWithData:(NSDictionary *)data {
    [FPNotificationCenterOM mj_setupReplacedKeyFromPropertyName:^NSDictionary * {
        return [FPNotificationCenterOM mDataReplaceDictionary];
    }];
    return [self mj_objectWithKeyValues:data];
}

- (NSString *)utc2Local {
    if (self.Timestamp) {
        NSString *str = [NSString datespToSystemTimeZoneFormat:self.Timestamp];
        return str;
    }
    return @"";
}

- (NSString *)dateGroupTitle {
    NSDate *localDate = [NSDate dateWithTimeIntervalSince1970:[self.Timestamp doubleValue]/1000.0];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    return [dateFormatter stringFromDate:localDate];
}

@end
