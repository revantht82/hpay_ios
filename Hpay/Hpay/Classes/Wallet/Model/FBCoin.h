//
//  FBCoin.h
//  FiiiPay
//
//  Created by apple on 2018/4/9.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "FPBaseModel.h"

@interface FBCoin : FPBaseModel
@property(nonatomic, copy) NSString *maxAmount;
@property(nonatomic, copy) NSString *minAmount;
@property(nonatomic, copy) NSString *Id;               //钱包Id
@property(nonatomic, copy) NSString *IconUrl;          //图标地址
@property(nonatomic, copy) NSString *BackgroundUrl;    //背景图地址
@property(nonatomic, copy) NSString *Name;             //名字,比如：Bitcoin
@property(nonatomic, copy) NSString *UseableBalance;   //可用余额
@property(nonatomic, copy) NSString *FrozenBalance;    //冻结的余额

//选择币种那里会补充多一个名字简写
@property(nonatomic, copy) NSString *Code;             //简称，比如：BTC
@property(nonatomic, copy) NSString *ExchangeRate;     //该加密币相对于商家法币的汇率
@property(nonatomic, copy) NSString *FiatExchangeRate; //法币兑换率
@property(nonatomic, copy) NSString *FiatCurrency;     //法币
@property(nonatomic, copy) NSString *FiatBalance;      //法币总额

@property(nonatomic, assign) BOOL MerchantSupported;   //商家是否支持

@property(nonatomic, assign) NSInteger DecimalPlace;   //小数位数

@property(nonatomic, copy) NSString *Discount;         //折扣，0.1表示9折，1免费

@property(nonatomic, copy) NSString *ChargeFee;
/**
 * desc : 规则，按顺序用0和1表示，0为不可用，1为可用 eg:1111表示都可以用
    Disable = 0,//币被禁用，下面所有功能不可用
    Pay = 1, //消费
    Withdrawal = 2,//提币
    Deposit = 4,//充币
    Transfer = 8//转账
    FastExchange = 16 //闪兑
    CurrencyPurchase = 32 //购买币
 */
@property(nonatomic, copy) NSString *Status;   //币种状态
//@property (nonatomic, copy) NSString *nStatus;  //新状态币种
//@property (nonatomic, assign) BOOL CryptoEnable;   //币种是否被禁用(0禁用 1可用)
@property(nonatomic, copy) NSString *ShowIcon; //是否显示异常(1显示，0不显示)
@property(nonatomic, assign) BOOL canPay;
@property(nonatomic, assign) BOOL canDeposit;
@property(nonatomic, assign) BOOL canWithdrawal;
@property(nonatomic, assign) BOOL canTransfer;
//@property (nonatomic, assign) BOOL canPayLife;
//@property (nonatomic, assign) BOOL canRedPacket;
@property(nonatomic, assign) BOOL canFastExchange;
@property(nonatomic, assign) BOOL canCurrencyPurchase;

+ (NSDictionary *)mDataReplaceDictionary;

+ (NSArray *)mModelArrayWithData:(NSArray *)data;

+ (instancetype)mModelWithData:(NSDictionary *)data;
@end
