//
//  WalletModelHelper.h
//  FiiiPay
//
//  Created by apple on 2018/4/13.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLCNetworkRequest.h"
#import "HimalayaPayAPIManager.h"

@interface WalletModelHelper : HimalayaPayAPIManager

/**
 * desc 充币以及提币的列表,生活缴费币种列表
 */
+ (void)fetchCoinList:(BOOL)isPayLife andFiatCurrency:(NSString *)FiatCurrency completeBlock:(void (^)(NSArray *coinList, NSString *FiatCurrency, NSInteger errorCode, NSString *errorMessage))completBlock;


/**
 * desc 获取商家收款币种列表数据(主动付款，蓝牙，静态码)
 */
+ (void)fetchCoinListByMerchantWithId:(NSString *)merchantID completeBlock:(void (^)(NSArray *coinList, NSInteger errorCode, NSString *errorMessage))completBlock;


/**
 * desc 获取充币地址
 */
+ (void)fetchCoinAddrById:(NSString *)Id completeBlock:(void (^)(NSString *addr, BOOL NeedTag, NSString *Tag, NSInteger errorCode, NSString *errorMessage))completBlock;

/**
 * desc : 提币
 */
+ (void)withdrawDataById:(NSString *)CoinId cryptoCode:(NSString *)CryptoCode andAddr:(NSString *)Address andTag:(NSString *)Tag andAmount:(NSString *)Amount smsCode:(NSString *)smsCode emailCode:(NSString *)emailCode googleCode:(NSString *)googleCode pin:(NSString *)pin completeBlock:(void (^)(NSDictionary *rsDict, NSInteger errorCode, NSString *errorMessage))completBlock;

/**
 * desc : 提币时综合验证
 */
+ (void)withdrawCombineValideWithSmsCode:(NSString *)SMSCode andGoogleCode:(NSString *)googleCode andDivisionCode:(NSString *)DivisionCode completeBlock:(void (^)(BOOL rs, NSInteger errorCode, NSString *errorMessage))completBlock;


/**
 * desc : 获取手续费
 */
+ (void)fetchCoinTransationFee:(NSString *)CoinId andAddr:(NSString *)TargetAddress andTag:(NSString *)TargetTag completeBlock:(void (^)(NSString *feeRate, NSString *feeAmount, NSInteger cryptoAddressType, NSInteger errorCode, NSString *errorMessage))completBlock;
@end
