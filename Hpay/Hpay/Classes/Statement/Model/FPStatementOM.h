//
//  FPStatementOM.h
//  FiiiPay
//
//  Created by apple on 2018/4/16.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "FPBaseModel.h"

@interface FPStatementOM : FPBaseModel

@property(nonatomic, copy) NSString *OrderId;
@property(nonatomic, copy) NSString *IconUrl;
@property(nonatomic, copy) NSString *Code;
@property(nonatomic, copy) NSString *Status;       //状态，比如：1 Order 1:Pending, 2:Completed, 3:Refunded Deposit 以及 WithDraw 1:Confirmed, 2:Pendin, 3:Cancelled
@property(nonatomic, copy) NSString *StatusName;       //状态  已完成，确认中，已退款
@property(nonatomic, copy) NSString *Name; 
@property(nonatomic, copy) NSString *Timestamp;    //时间戳
@property(nonatomic, copy) NSString *FiatAmount;   //法币金额
@property(nonatomic, copy) NSString *FiatCurrency; //法币：比如：MRY
@property(nonatomic, copy) NSString *CryptoAmount; //加密货币金额
@property(nonatomic, copy) NSString *Type;         //0：充币，1：提币，2：消费，3：退款，客户端根据这个调用对应的接口查询详情，消费和退款都调用Order/Detail接口查询详情

@property(nonatomic, copy) NSString *utc2Local;    //utc时间戳转当前系统时区时间
@property(nonatomic, copy) NSString *dateGroupTitle; //分组头
@property(nonatomic, copy) NSString *typeName; 
@property(nonatomic, copy) NSString *BEtypeName; //类型名字
@property(nonatomic, copy) NSString *RefundStatusStr;//红包 已全额退款  已部分退款

@property(nonatomic, assign) NSInteger decimalPlace;

+ (NSDictionary *)mDataReplaceDictionary;

+ (NSArray *)mModelArrayWithData:(NSArray *)data;

+ (instancetype)mModelWithData:(NSDictionary *)data;
@end
