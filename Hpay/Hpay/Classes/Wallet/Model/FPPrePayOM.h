//
//  FPPrePayOM.h
//  FiiiPay
//
//  Created by apple on 2018/4/10.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "FPBaseModel.h"

@interface FPPrePayOM : FPBaseModel
@property(nonatomic, copy) NSString *MarkupRate;  //溢价费率，比如，0.1，客户端需要自行转换显示为10%
@property(nonatomic, copy) NSString *FiatCurrency; //法币币种
@property(nonatomic, strong) NSMutableArray *WaletList; //币种列表

+ (NSDictionary *)mDataReplaceDictionary;

+ (NSArray *)mModelWithData:(NSArray *)data;

+ (instancetype)objectWithKeyValuesWithM:(NSDictionary *)modelDict;
//+ (instancetype)objectWithKeyValuesWithStore:(NSDictionary *)store;
@end
