//
//  FPBluetoothMerchant.m
//  FiiiPay
//
//  Created by apple on 2018/4/10.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "FPBluetoothMerchant.h"

@implementation FPBluetoothMerchant

MJCodingImplementation

- (id)copyWithZone:(NSZone *)zone {
    FPBluetoothMerchant *copy = [[[self class] allocWithZone:zone] init];
    copy.Id = self.Id;
    copy.IconUrl = self.IconUrl;
    copy.MerchantName = self.MerchantName;
    copy.MerchantAccount = self.MerchantAccount;
    copy.IsVerified = self.IsVerified;
    copy.RandomCode = self.RandomCode;
    copy.IsAllowAcceptPayment = self.IsAllowAcceptPayment;
    return copy;
}

+ (NSDictionary *)mDataReplaceDictionary {
    return @{
            @"Id": @"Id",
            @"IconUrl": @"IconUrl",
            @"MerchantName": @"MerchantName",
            @"MerchantAccount": @"MerchantAccount",
            @"IsVerified": @"IsVerified",
            @"RandomCode": @"RandomCode",
            @"IsAllowAcceptPayment": @"IsAllowAcceptPayment"
    };
}

+ (NSArray *)mModelArrayWithData:(NSArray *)data {
    [FPBluetoothMerchant mj_setupReplacedKeyFromPropertyName:^NSDictionary * {
        return [FPBluetoothMerchant mDataReplaceDictionary];
    }];
    return [self mj_objectArrayWithKeyValuesArray:data];
}

+ (instancetype)mModelWithData:(NSDictionary *)data {
    [FPBluetoothMerchant mj_setupReplacedKeyFromPropertyName:^NSDictionary * {
        return [FPBluetoothMerchant mDataReplaceDictionary];
    }];
    return [self mj_objectWithKeyValues:data];
}
@end
