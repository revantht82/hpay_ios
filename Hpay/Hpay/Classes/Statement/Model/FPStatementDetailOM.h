#import "FPBaseModel.h"

@interface FPStatementDetailOM : FPBaseModel


@property(nonatomic, copy) NSString *Id;
@property(nonatomic, copy) NSString *Code;         //加密货币币种名称：比如：BTC
@property(nonatomic, copy) NSString *Timestamp;
@property(nonatomic, copy) NSString *CreationTimeStamp;
@property(nonatomic, copy) NSString *ExpiredTimeStamp;
@property(nonatomic, copy) NSString *FiatAmount;   //法币金额
@property(nonatomic, copy) NSString *FiatCurrency; //法币：比如：MRY
@property(nonatomic, copy) NSString *CryptoAmount; //加密货币金额
@property(nonatomic, copy) NSString *Type;         //交易类型
@property(nonatomic, copy) NSString *Status;       //比如：已完成

@property(nonatomic, copy) NSString *CurrentExchangeRate; //当前加密币对法币汇率
@property(nonatomic, copy) NSString *IncreaseRate;        //涨幅

//提现
//@property (nonatomic, copy) NSString *StatusName;       //比如：已完成
@property(nonatomic, copy) NSString *TransactionFee;   //手续费
@property(nonatomic, copy) NSString *Address;          //地址
@property(nonatomic, copy) NSString *CheckTime;       //确认次数
@property(nonatomic, copy) NSString *TransactionId;   //交易ID
@property(nonatomic, copy) NSString *Note;
@property(nonatomic, copy) NSString *Notes;
@property(nonatomic, copy) NSString *ProductCategory;
@property(nonatomic, copy) NSString *Remark;          //备注
@property(nonatomic, copy) NSString *Tag;             //标签
@property(nonatomic, assign) BOOL NeedTag;            //是否需要Tag

//订单详情
@property(nonatomic, copy) NSString *MerchantName;
@property(nonatomic, copy) NSString *MarkUp;       //溢价率，比如：10.00%
@property(nonatomic, copy) NSString *TotalFiatAmount;
@property(nonatomic, copy) NSString *ExchangeRate; //当时的汇率，比如：1BTC = 1670.80MRY
@property(nonatomic, copy) NSString *RefundTimestamp; //退款时间，如果已经退款这个字段会有值，客户端根据这个字段是否有值显示即可
@property(nonatomic, copy) NSString *OrderNo;      //交易单号

//转账
//Status 1 Confirmed 2 Pending 3 Cancelled
@property(nonatomic, copy) NSString *TradeType;    //交易类型，转账
@property(nonatomic, copy) NSString *TransferType; //转账类型，转入或转出
@property(nonatomic, copy) NSString *RequestType;
@property(nonatomic, copy) NSString *CoinCode;     //币种编码
@property(nonatomic, copy) NSString *CoinName;     // For Request fund
@property(nonatomic, copy) NSString *Amount;       //转账金额
@property(nonatomic, copy) NSString *AvailableBalance;       //转账金额
@property(nonatomic, copy) NSString *AccountName;  //目标帐号名称
@property(nonatomic, copy) NSString *Fullname;     //目标全名
@property(nonatomic, copy) NSString *CorrespondingName;
@property(nonatomic, copy) NSString *RelatedAccountName;
@property(nonatomic, copy) NSString *RelatedUserName;

//划转
@property(nonatomic, copy) NSString *ExTransferTypeStr;  //划转的类型字符串
@property(nonatomic, assign) NSInteger ExTransferType; //FromEx 1,ToEx 2
@property(nonatomic, copy) NSString *CryptoCode;       //币种类型
//划转钱包

@property(nonatomic, copy) NSString *oTime;
@property(nonatomic, copy) NSString *refundOTime;
@property(nonatomic, copy) NSString *profitOTime;

@property(nonatomic, assign) BOOL SelfPlatform; //内部

//奖励收入详情
@property(nonatomic, copy) NSString *TradeDescription; //交易说明
@property(nonatomic, copy) NSString *BonusFrom;        //来自什么
@property(nonatomic, copy) NSString *TypeStr;

//网购
@property(nonatomic, copy) NSString *TradeNo;      //商户交易单号

//缴费
@property(nonatomic, copy) NSString *BillerCode;
@property(nonatomic, copy) NSString *ReferenceNumber;


//红包
@property(nonatomic, assign) BOOL HasRefund;  //红包是否退款
@property(nonatomic, copy) NSString *RefundAmount; //红包退款金额
@property(nonatomic, copy) NSString *PocketId;//红包id
@property(nonatomic, copy) NSString *redPocketRefundStr;//红包 退款记录

//门店
@property(nonatomic, copy) NSString *CryptoActualAmount; //订单金额，实际支付数量
@property(nonatomic, copy) NSString *UserAccountName;//客户账号
@property(nonatomic, copy) NSString *FeeCryptoCode;//交易手续费币种


//GPay
//交易类型名称
@property(nonatomic, copy) NSString *TransactionTypeName;
@property(nonatomic, copy) NSString *TransactionTypeId;

//原币种
@property(nonatomic, copy) NSString *FromCryptoCode;
//支出数量
@property(nonatomic, copy) NSString *FromAmount;
//兑换币种
@property(nonatomic, copy) NSString *ToCryptoCode;
//收入数量
@property(nonatomic, copy) NSString *ToAmount;

@property(nonatomic, copy) NSString *StatusName;
@property(nonatomic, copy) NSString *Name;

@property(nonatomic, copy) NSString *CreationTime;
@property(nonatomic, copy) NSString *oCreateTime;
@property(nonatomic, copy) NSString *fromAmountStr;
@property(nonatomic, copy) NSString *toAmountStr;

@property(nonatomic, copy) NSString *DetailTypeName;
@property(nonatomic, assign) NSInteger PayType;
@property(nonatomic, copy) NSString *PayTypeName;

@property(nonatomic, copy) NSString *ActualCryptoAmount;
@property(nonatomic, copy) NSString *CustomerAccount;
@property(nonatomic, copy) NSString *ActualPayAmount;
@property(nonatomic, copy) NSString *ActualSendAmount;

@property(nonatomic, copy) NSString *TranType;
@property(nonatomic, copy) NSString *TranPayType;
@property(nonatomic, copy) NSString *SellingAmount;
@property(nonatomic, copy) NSString *GetFiatAmount;
@property(nonatomic, copy) NSString *FiatCode;
@property(nonatomic, copy) NSString *OrderId;
@property(nonatomic, copy) NSString *Reference;
@property(nonatomic, copy) NSString *DeepLink;
@property(nonatomic, assign) NSInteger DecimalPlace;

@property(nonatomic, copy) NSString *filePath;
@property(nonatomic, copy) NSString *fileType;
@property(nonatomic, copy) NSString *fileName;

@property(nonatomic, copy) NSString *NickName;
@property(nonatomic, copy) NSString *GroupReference;


+ (NSDictionary *)mDataReplaceDictionary;

+ (NSArray *)mModelArrayWithData:(NSArray *)data;

+ (instancetype)mModelWithData:(NSDictionary *)data;

@end
