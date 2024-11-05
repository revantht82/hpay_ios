//
//  FPCountryList.m
//  Hpay
//
//  Created by Ugur Bozkurt on 19/08/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "FPCountryList.h"

@implementation FPCountryList

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        FPCountryList *item = [FPCountryList mj_objectWithKeyValues:dict];
        NSArray<FPCountry *> *countries = [FPCountry mj_objectArrayWithKeyValuesArray:item.List];
        self.Language = item.Language;
        self.List = countries;
    }
    return self;
}

+ (instancetype)objectFromJSONDictionary:(NSDictionary *)dict{
    return [[FPCountryList alloc] initWithJSONDictionary:dict];
}

- (id)copyWithZone:(NSZone *)zone {
    FPCountryList *copy = [[[self class] allocWithZone:zone] init];
    copy.Language = self.Language;
    copy.List = self.List;
    return copy;
}
@end
