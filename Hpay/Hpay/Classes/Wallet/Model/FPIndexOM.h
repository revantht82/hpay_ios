//
//  FPIndexOM.h
//  FiiiPay
//
//  Created by apple on 2018/4/9.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "FPBaseModel.h"

@interface FPIndexOM : FPBaseModel
@property(nonatomic, copy) NSString *TotalAmount;  //所有加密币换算成当地币种的总金额
@property(nonatomic, copy) NSString *FiatCurrency; //法币
@property(nonatomic, strong) NSMutableArray *CurrencyItemList; //钱包账户币种列表
@property(nonatomic, strong) NSMutableArray *FiatCurrencyItemList; //法币账户币种列表
@property(nonatomic, strong) NSMutableArray *OTCCryptCurrencyItemList; //OTC账户币种列表

+ (NSDictionary *)mDataReplaceDictionary;
+ (NSArray *)mModelWithData:(NSArray *)data;
+ (instancetype)objectWithKeyValuesWithM:(NSDictionary *)modelDict;
@end
