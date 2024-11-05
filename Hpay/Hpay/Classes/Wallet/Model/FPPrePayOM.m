//
//  FPPrePayOM.m
//  FiiiPay
//
//  Created by apple on 2018/4/10.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "FPPrePayOM.h"
#import "FBCoin.h"

@implementation FPPrePayOM
MJCodingImplementation

- (id)copyWithZone:(NSZone *)zone {
    FPPrePayOM *copy = [[[self class] allocWithZone:zone] init];

    copy.MarkupRate = self.MarkupRate;
    copy.FiatCurrency = self.FiatCurrency;
    copy.WaletList = self.WaletList;

    return copy;
}

+ (NSDictionary *)mDataReplaceDictionary {
    return @{
            @"MarkupRate": @"MarkupRate",
            @"FiatCurrency": @"FiatCurrency",
            @"WaletList": @"WaletList"
    };
}

+ (NSArray *)mModelWithData:(NSArray *)data {
    [FPPrePayOM mj_setupObjectClassInArray:^NSDictionary * {
        return @{
                @"WaletList": @"FBCoin"
        };
    }];

    [FPPrePayOM mj_setupReplacedKeyFromPropertyName:^NSDictionary * {
        return [FPPrePayOM mDataReplaceDictionary];
    }];

    [FBCoin mj_setupReplacedKeyFromPropertyName:^NSDictionary * {
        return [FBCoin mDataReplaceDictionary];
    }];
    return [self mj_objectArrayWithKeyValuesArray:data];
}

+ (instancetype)objectWithKeyValuesWithM:(NSDictionary *)modelDict {
    [FPPrePayOM mj_setupObjectClassInArray:^NSDictionary * {
        return @{
                @"WaletList": @"FBCoin"
        };
    }];

    [FPPrePayOM mj_setupReplacedKeyFromPropertyName:^NSDictionary * {
        return [FPPrePayOM mDataReplaceDictionary];
    }];

    [FBCoin mj_setupReplacedKeyFromPropertyName:^NSDictionary * {
        return [FBCoin mDataReplaceDictionary];
    }];
    return [self mj_objectWithKeyValues:modelDict];
}

//+ (instancetype)objectWithKeyValuesWithStore:(NSDictionary *)store
//{
//    ReportModel * data = [self mj_objectWithKeyValues:store];
//    NSMutableArray *itemArr = [NSMutableArray arrayWithCapacity:10];
//    for (NSDictionary * itemDict in data.List) {
//        ReportModel * item = [ReportModel mj_objectWithKeyValues:itemDict];
//        [itemArr addObject:item];
//    }
//    data.List = nil;
//    data.List = [itemArr mutableCopy];
//    return data;
//}

@end
