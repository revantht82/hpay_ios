//
//  NotificationCenterListKeyItem.m
//  Hpay
//
//  Created by Ugur Bozkurt on 29/11/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "NotificationCenterListKeyItem.h"

@implementation NotificationCenterListKeyItem

+ (instancetype)itemWithObject:(FPNotificationCenterOM *)object{
    NotificationCenterListKeyItem *item = [[NotificationCenterListKeyItem alloc] init];
    item.date = [NSDate dateWithTimeIntervalSince1970:[object.Timestamp doubleValue]/1000.0];
    item.key = [object dateGroupTitle];
    return item;
}

- (BOOL)isEqual:(NotificationCenterListKeyItem *)other
{
    return self.key == other.key;
}

- (id)copyWithZone:(NSZone *)zone {
    NotificationCenterListKeyItem *copy = [[[self class] allocWithZone:zone] init];
    copy.key = self.key;
    copy.date = self.date;
    return copy;
}

@end
