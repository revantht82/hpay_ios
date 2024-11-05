//
//  FBCoin.m
//  FiiiPay
//
//  Created by apple on 2018/4/9.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "FBCoin.h"

@implementation FBCoin
MJCodingImplementation

- (NSString *)maxAmount {
    return @"9999999999.99999999";
}

//- (NSString *)minAmount {
//    return @"0.00000001";
//}

- (id)copyWithZone:(NSZone *)zone {
    FBCoin *copy = [[[self class] allocWithZone:zone] init];
    copy.Id = self.Id;
    copy.IconUrl = self.IconUrl;
    copy.BackgroundUrl = self.BackgroundUrl;
    copy.Name = self.Name;
    copy.UseableBalance = self.UseableBalance;
    copy.FrozenBalance = self.FrozenBalance;

    copy.Code = self.Code;
    copy.ExchangeRate = self.ExchangeRate;
    copy.MerchantSupported = self.MerchantSupported;
    copy.DecimalPlace = self.DecimalPlace;
    copy.Status = self.Status;
    copy.FiatExchangeRate = self.FiatExchangeRate;
    copy.FiatCurrency = self.FiatCurrency;
    copy.FiatBalance = self.FiatBalance;

//    copy.Enable = self.Enable;
    copy.ShowIcon = self.ShowIcon;
    copy.canTransfer = self.canTransfer;
    copy.canWithdrawal = self.canWithdrawal;
    copy.canDeposit = self.canDeposit;
    copy.canPay = self.canPay;
    copy.Discount = self.Discount;
    copy.canFastExchange = self.canFastExchange;
    copy.canCurrencyPurchase = self.canCurrencyPurchase;
//    copy.canPayLife = self.canPayLife;
    
    copy.minAmount = self.minAmount;
    copy.ChargeFee = self.ChargeFee;
    
    return copy;
}


+ (NSDictionary *)mDataReplaceDictionary {
    return @{
            @"Id": @"Id",
            @"IconUrl": @"IconUrl",
            @"BackgroundUrl": @"BackgroundUrl",
            @"Name": @"Name",
            @"UseableBalance": @"UseableBalance",
            @"FrozenBalance": @"FrozenBalance",
            @"Code": @"Code",
            @"ExchangeRate": @"ExchangeRate",
            @"MerchantSupported": @"MerchantSupported",
            @"DecimalPlace": @"DecimalPlace",
            @"Status": @"Status",
            @"FiatExchangeRate": @"FiatExchangeRate",
            @"FiatCurrency": @"FiatCurrency",
            @"FiatBalance": @"FiatBalance",
            @"Discount": @"Discount",
            @"minAmount": @"MinCount",
            @"ChargeFee": @"ChargeFee"
//             @"Enable":@"CryptoEnable"
    };
}

+ (NSArray *)mModelArrayWithData:(NSArray *)data {
    [FBCoin mj_setupReplacedKeyFromPropertyName:^NSDictionary * {
        return [FBCoin mDataReplaceDictionary];
    }];
    return [self mj_objectArrayWithKeyValuesArray:data];
}

+ (instancetype)mModelWithData:(NSDictionary *)data {
    [FBCoin mj_setupReplacedKeyFromPropertyName:^NSDictionary * {
        return [FBCoin mDataReplaceDictionary];
    }];
    return [self mj_objectWithKeyValues:data];
}

#pragma mark - 币种是否支持付款

- (BOOL)canPay {
    BOOL can = NO;
    if (self.Status && self.Status.length > 0) {
        return ([self.Status intValue] & 1);
    }
    return can;
}

#pragma mark - 币种是否支持充币

- (BOOL)canDeposit {
    BOOL can = NO;
    if (self.Status && self.Status.length > 0) {
        return ([self.Status intValue] & 4);
    }
    return can;
}

#pragma mark - 币种是否支持提币

- (BOOL)canWithdrawal {
    BOOL can = NO;
    if (self.Status && self.Status.length > 0) {
        return ([self.Status intValue] & 2);
    }
    return can;
}

#pragma mark - 币种是否支持转账

- (BOOL)canTransfer {
    BOOL can = NO;
    if (self.Status && self.Status.length > 0) {
        return ([self.Status intValue] & 8);
    }
    return can;
}

#pragma mark - 币种是否支持闪兑

- (BOOL)canFastExchange {
    BOOL can = NO;
    if (self.Status && self.Status.length > 0) {
        return ([self.Status intValue] & 16);
    }
    return can;
}

#pragma mark - 币种是否支持购买币

- (BOOL)canCurrencyPurchase {
    BOOL can = NO;
    if (self.Status && self.Status.length > 0) {
        return ([self.Status intValue] & 32);
    }
    return can;
}


#pragma mark - 是否展示ICON

- (NSString *)ShowIcon {
    NSString *str = @"1";
    if (self.canTransfer && self.canPay && self.canDeposit && self.canWithdrawal) {
        str = @"0";
    }
    return str;
}
@end
