//
//  FPIndexOM.m
//  FiiiPay
//
//  Created by apple on 2018/4/9.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "FPIndexOM.h"
#import "FBCoin.h"

@implementation FPIndexOM

MJCodingImplementation

- (id)copyWithZone:(NSZone *)zone {
    FPIndexOM *copy = [[[self class] allocWithZone:zone] init];

    copy.TotalAmount = self.TotalAmount;
    copy.FiatCurrency = self.FiatCurrency;
    copy.CurrencyItemList = self.CurrencyItemList;
    copy.FiatCurrencyItemList = self.FiatCurrencyItemList;
    return copy;
}

+ (NSDictionary *)mDataReplaceDictionary {
    return @{
            @"TotalAmount": @"TotalAmount",
            @"FiatCurrency": @"FiatCurrency",
            @"CurrencyItemList": @"CurrencyItemList",
            @"FiatCurrencyItemList": @"FiatCurrencyItemList",
            @"OTCCryptCurrencyItemList": @"OTCCryptCurrencyItemList"
    };
}

+ (NSArray *)mModelWithData:(NSArray *)data {
    [FPIndexOM mj_setupObjectClassInArray:^NSDictionary * {
        return @{
                @"CurrencyItemList": @"FBCoin",
                @"FiatCurrencyItemList": @"FBHomeFiat",
                @"OTCCryptCurrencyItemList": @"FBCoin"
        };
    }];

    [FPIndexOM mj_setupReplacedKeyFromPropertyName:^NSDictionary * {
        return [FPIndexOM mDataReplaceDictionary];
    }];

    [FBCoin mj_setupReplacedKeyFromPropertyName:^NSDictionary * {
        return [FBCoin mDataReplaceDictionary];
    }];
    return [self mj_objectArrayWithKeyValuesArray:data];
}

+ (instancetype)objectWithKeyValuesWithM:(NSDictionary *)modelDict {
    [FPIndexOM mj_setupObjectClassInArray:^NSDictionary * {
        return @{
                @"CurrencyItemList": @"FBCoin",
                @"FiatCurrencyItemList": @"FBHomeFiat",
                @"OTCCryptCurrencyItemList": @"FBCoin"
        };
    }];

    [FPIndexOM mj_setupReplacedKeyFromPropertyName:^NSDictionary * {
        return [FPIndexOM mDataReplaceDictionary];
    }];

    [FBCoin mj_setupReplacedKeyFromPropertyName:^NSDictionary * {
        return [FBCoin mDataReplaceDictionary];
    }];
    return [self mj_objectWithKeyValues:modelDict];
}

@end
