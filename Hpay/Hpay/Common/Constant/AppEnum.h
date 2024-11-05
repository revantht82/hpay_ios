//
//  AppEnum.h
//  HomeHealthNew
//
//  Created by cheungBoy on 2017/7/7.
//
//

#ifndef AppEnum_h
#define AppEnum_h


typedef NS_ENUM(NSInteger, StatementFilterType) {
    StatementFilterTypeAll = 0, //全部
    StatementFilterTypePay = 1, //付款
    StatementFilterTypeRefund = 2, //已退款
    StatementFilterTypeDeposit = 3, //充值
    StatementFilterTypeWithdraw = 4, //提现
    StatementFilterTypeTransfer = 5, //转账
    StatementFilterTypePayOnline = 6, //线上消费
    StatementFilterTypeGateway = 7,  //网关入账
    StatementFilterTypeGPayExchange = 8,//GPay兑换
    StatementFilterTypeBuyCryptoCode = 9,//购买币
    StatementFilterTypeExchange = 10,//划转

};

typedef NS_ENUM(NSInteger, StatementListType) {
    StatementListInvalid = -1,
    //充币 0
    StatementListTypeDeposit = 0,
    //提币 1
    StatementListTypeWithdraw = 1,
    //消费 2
    StatementListTypePay = 2,
    //退款 3
//    StatementListTypeRefund = 3,
    //转账出 4
    StatementListTypeTransferOut = 4,
    //转账入 5
    StatementListTypeTransferIn = 5,

    //GPay闪兑
    StatementListTypeGPayExchangeOut = 6,

    StatementListTypeGPayExchangeIn = 7,
    //买币
    StatementListTypeGPayBuyCrpytoCode = 8,
    //线上消费（网关消费）
    StatementListTypeGatewayOrderOutcome = 9,
    //线上消费退款
    StatementListTypeGatewayOrderRefund = 10,
    //网关入账
    StatementListTypeGateway = 11,
    //网关入账退单(商家端)
    StatementListTypeGatewayBack = 12,
    //划转 转出到HEX
    StatementListTypeHuazhuanOut = 13,
    //划转 转入
    StatementListTypeHuazhuanIn = 14,
    //售币
    StatementListTypeGPaySellCrpytoCode = 15,
    
    StatementListTypeMerchantPaymentOut = 16,
    StatementListTypeMerchantPaymentIn = 17,

    StatementListTypeMerchantRefund = 18,
    StatementListTypeMerchantRefundOut = 19,
    
    StatementListTypeRequestFundIn = 20,
    StatementListTypeRequestFundOut = 21,
    StatementListTypeRequestPaymentIn = 22,
    StatementListTypeRequestPaymentOut = 23
};

typedef NS_ENUM(NSInteger, TransactionStatusType) {
    Pending = 1,
    Complete = 2,
    Cancelled = 3,
    Reversed = 7,
    Expired = 8,
    Failed = 12
};

typedef NS_ENUM(NSInteger, CoinActionType) {
    CoinActionTypeDeposit = 1,  //充币
    CoinActionTypeWithdrawal = 2, //提币
    CoinActionTypeTransfer = 3, //转账
    CoinActionTypeTransferScan = 4,
    CoinActionTypeRequest = 5
};

typedef NS_ENUM(NSInteger, ActionResultVCFrom) {
    ActionResultVCFromNone = 0, //默认不处理
    ActionResultVCFromPay = 1,  //付款
    ActionResultVCFromWithdrawal = 2, //提现
    ActionResultVCFromTransfer = 3, //转账
    ActionResultVCFromExchange = 4  //划转
};

typedef NS_ENUM(NSInteger, SafeAuthType) {
    SafeAuthTypeAll = 0,                //所有只有有绑定谷歌且有开启验证的且是通过LV1认证的m，用于忘记PIN码
    SafeAuthTypeAllExceptLV1NO = 1,     //所有只有有绑定谷歌且有开启验证的（提币，修改手机号，修改pin码,所有关闭解绑操作）
    SafeAuthTypePhone = 2,              //用于绑定、解绑谷歌、
    SafeAuthTypeGoogle = 3,             //只验证谷歌,当已绑定谷歌，开启谷歌验证时使用此类型，登录
    SafeAuthTypeExceptionDevice = 4,     //检测新设备登录
    SafeAuthTypeOnlyLoginPassword = 5,  //用于开启关闭锁屏密码和指纹解锁
    SafeAuthTypeGesture = 6,     //手势密码点击
    SafeAuthTypeBindPhone = 7, //绑定手机号 （验证邮箱）
    SafeAuthTypeBindEmail = 8,  //绑定邮箱 （验证短信）
    SafeAuthTypeUpdatePhone = 9, //修改手机号 （验证短信）
    SafeAuthTypeUpdateEmail = 10, //修改邮箱 （验证邮箱）
    SafeAuthTypeResetPIN = 11
};

typedef NS_ENUM(NSInteger, CryptoAddressType) {
    CryptoAddressTypeNone = 0,
    CryptoAddressTypeFiiiPay = 1,
    CryptoAddressTypeFiiiPOS = 2,
    CryptoAddressTypeOther = 3,
    CryptoAddressTypeInsideWithError = 4
};

typedef NS_ENUM(NSInteger, ScanQRCodeSystem) {
    ScanQRCodeSystemFiiiPOS = 1, //扫码
};

typedef NS_ENUM(NSInteger, ScanQRCodeBusiness) {
    ScanQRCodeBusinessLogin = 1001, //FiiiPay扫码登录
    ScanQRCodeBusinessMerchantScanPay = 1100 //FiiiPay扫商家静态付款码
};
#endif /* AppEnum_h */
