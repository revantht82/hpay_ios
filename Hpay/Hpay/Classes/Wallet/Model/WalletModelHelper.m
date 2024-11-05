//
//  WalletModelHelper.m
//  FiiiPay
//
//  Created by apple on 2018/4/13.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "WalletModelHelper.h"
#import "FBCoin.h"

@implementation WalletModelHelper

#pragma mark - 充币以及提币的列表

+ (void)fetchCoinList:(BOOL)isPayLife andFiatCurrency:(NSString *)FiatCurrency completeBlock:(void (^)(NSArray *coinList, NSString *FiatCurrency, NSInteger errorCode, NSString *errorMessage))completBlock {
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    if (isPayLife && FiatCurrency && FiatCurrency.length > 0) {
        mDict[@"fiatCurrency"] = FiatCurrency;
    }
    [self      GET:(WalletListForDepositAndWithdrawalURL) parameters:mDict successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        NSDictionary *dict = (NSDictionary *) data;
        NSArray *arr = [FBCoin mModelArrayWithData:dict[@"List"]];
        NSString *Fiat = [NSString stringWithFormat:@"%@", dict[@"FiatCurrency"]];
        completBlock(arr, Fiat, kFPNetRequestSuccessCode, nil);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        completBlock(nil, nil, code, message);
    }];
}

#pragma mark - 获取商家收款币种列表数据(主动付款，蓝牙，静态码)

+ (void)fetchCoinListByMerchantWithId:(NSString *)merchantID completeBlock:(void (^)(NSArray *coinList, NSInteger errorCode, NSString *errorMessage))completBlock {
    [self     POST:WalletListForDepositAndWithdrawalURL parameters:nil successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        NSDictionary *dict = (NSDictionary *) data;
        NSArray *arr = [FBCoin mModelArrayWithData:dict[@"List"]];
        completBlock(arr, kFPNetRequestSuccessCode, nil);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        completBlock(nil, code, message);
    }];
}

#pragma mark - 获取充币地址

+ (void)fetchCoinAddrById:(NSString *)Id completeBlock:(void (^)(NSString *addr, BOOL NeedTag, NSString *Tag, NSInteger errorCode, NSString *errorMessage))completBlock {
    [self     POST:DepositPreDepositURL parameters:@{@"CryptoId": Id} successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        NSDictionary *dict = (NSDictionary *) data;
        NSNumber *needT = dict[@"NeedTag"];
        completBlock(dict[@"Address"], [needT boolValue], dict[@"Tag"], kFPNetRequestSuccessCode, nil);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        completBlock(nil, NO, nil, code, message);
    }];
}


#pragma mark - 获取预提币数据

#pragma mark - 提币综合认证

+ (void)withdrawCombineValideWithSmsCode:(NSString *)SMSCode andGoogleCode:(NSString *)googleCode andDivisionCode:(NSString *)DivisionCode completeBlock:(void (^)(BOOL rs, NSInteger errorCode, NSString *errorMessage))completBlock {
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    if (googleCode && googleCode.length > 0) {
        mDict[@"GoogleCode"] = googleCode;
    }
    
    if (DivisionCode && DivisionCode.length > 0) {
        mDict[@"DivisionCode"] = DivisionCode;
    }
    if (SMSCode && SMSCode.length > 0) {
        mDict[@"SMSCode"] = SMSCode;
    }
    
    [self     POST:WithdrawVerifyWithdrawIMCombineURL parameters:mDict successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        BOOL results = [(NSNumber *) data boolValue];
        completBlock(results, kFPNetRequestSuccessCode, nil);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        completBlock(1, code, message);
    }];
}

#pragma mark - 提币

+ (void)withdrawDataById:(NSString *)CoinId cryptoCode:(NSString *)CryptoCode andAddr:(NSString *)Address andTag:(NSString *)Tag andAmount:(NSString *)Amount smsCode:(NSString *)smsCode emailCode:(NSString *)emailCode googleCode:(NSString *)googleCode pin:(NSString *)pin completeBlock:(void (^)(NSDictionary *rsDict, NSInteger errorCode, NSString *errorMessage))completBlock {
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    if (Tag && Tag.length > 0) {
        mDict[@"Tag"] = Tag;
    }
    if (googleCode.length > 0) {
        mDict[@"GoogleCode"] = googleCode;
    }
    mDict[@"CryptoId"] = CoinId;
    mDict[@"Address"] = Address;
    mDict[@"Amount"] = Amount;
    mDict[@"CryptoCode"] = CryptoCode;
    mDict[@"Pin"] = pin;
    if (smsCode.length > 0) {
        mDict[@"SMSCode"] = smsCode;
    }
    if (emailCode.length > 0) {
        mDict[@"EmailCode"] = emailCode;
    }
    
    [self     POST:WithdrawWithdrawURL parameters:mDict successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        NSDictionary *dict = (NSDictionary *) data;
        completBlock(dict, kFPNetRequestSuccessCode, nil);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        completBlock(nil, code, message);
    }];
}

#pragma mark - 获取手续费

+ (void)fetchCoinTransationFee:(NSString *)CoinId andAddr:(NSString *)TargetAddress andTag:(NSString *)TargetTag completeBlock:(void (^)(NSString *feeRate, NSString *feeAmount, NSInteger cryptoAddressType, NSInteger errorCode, NSString *errorMessage))completBlock {
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    mDict[@"CoinId"] = CoinId;
    mDict[@"TargetAddress"] = TargetAddress;
    if (TargetTag) {
        mDict[@"TargetTag"] = TargetTag;
    }
    
    [self     POST:WithdrawTransactionFeeRateURL parameters:mDict successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        NSDictionary *dict = (NSDictionary *) data;
        NSString *typeStr = [NSString stringWithFormat:@"%@", dict[@"CryptoAddressType"]];
        completBlock(dict[@"TransactionFeeRate"], dict[@"TransactionFee"], [typeStr integerValue], kFPNetRequestSuccessCode, nil);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        completBlock(nil, nil, code, 0, message);
    }];
}

@end
