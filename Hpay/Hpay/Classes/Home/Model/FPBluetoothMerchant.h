//
//  FPBluetoothMerchant.h
//  FiiiPay
//
//  Created by apple on 2018/4/10.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "FPBaseModel.h"

typedef NS_ENUM(NSInteger, FPPayType) {
    FPBluetoothPayType = 0, //蓝牙主动付款
    FPStaticCodePayType = 1,     //静态二维码付款
    FPFiiiPayStorePayType = 2   //FiiiPay门店支付
};

@interface FPBluetoothMerchant : FPBaseModel

@property(nonatomic, assign) FPPayType payType;
@property(nonatomic, copy) NSString *Id; //商家id
@property(nonatomic, copy) NSString *Avatar;
@property(nonatomic, copy) NSString *MarkupRate; //溢价
@property(nonatomic, copy) NSString *FiatCurrency; //法币币种
@property(nonatomic, copy) NSString *IconUrl;
@property(nonatomic, copy) NSString *MerchantName;
@property(nonatomic, copy) NSString *MerchantAccount;  //已经加过***
@property(nonatomic, assign) BOOL IsVerified;  //是否已经认证
// L1VerifyStatus 0 未提交， 1 已认证， 2 驳回， 3 审核中
@property(nonatomic, assign) NSInteger L1VerifyStatus;
@property(nonatomic, assign) NSInteger L2VerifyStatus;
@property(nonatomic, copy) NSString *RandomCode;   //随机码
@property(nonatomic, assign) CGFloat Distance; //距离
@property(nonatomic, assign) BOOL IsAllowAcceptPayment; // 是否支持交易

+ (NSDictionary *)mDataReplaceDictionary;

+ (NSArray *)mModelArrayWithData:(NSArray *)data;

+ (instancetype)mModelWithData:(NSDictionary *)data;
@end
