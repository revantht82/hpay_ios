//
//  StatementListKeyItem.m
//  Hpay
//
//  Created by Ugur Bozkurt on 29/11/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "StatementListKeyItem.h"

@implementation StatementListKeyItem

+ (instancetype)itemWithObject:(FPStatementOM *)object{
    StatementListKeyItem *item = [[StatementListKeyItem alloc] init];
    item.date = [NSDate dateWithTimeIntervalSince1970:[object.Timestamp doubleValue]/1000.0];
    item.key = [object dateGroupTitle];
    return item;
}

- (BOOL)isEqual:(StatementListKeyItem *)other
{
    return self.key == other.key;
}

- (id)copyWithZone:(NSZone *)zone {
    StatementListKeyItem *copy = [[[self class] allocWithZone:zone] init];
    copy.key = self.key;
    copy.date = self.date;
    return copy;
}

@end
