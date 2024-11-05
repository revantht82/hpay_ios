#import <Foundation/Foundation.h>

@interface PreTransferModel : NSObject
@property(nonatomic, copy) NSString *ToAvatar; //目标用户头像
@property(nonatomic, copy) NSString *ToAccountName; //目标用户名
@property(nonatomic, copy) NSString *ToAccountId; //目标用户id
@property(nonatomic, copy) NSString *ToFullname; //目标姓名
//是否允许转账
@property(nonatomic, assign) BOOL IsProfileVerified; //是否已实名认证
@property(nonatomic, copy) NSString *CoinId; //转账加密币币种ID
@property(nonatomic, copy) NSString *CoinCode; //转账加密币币种编码
@property(nonatomic, copy) NSString *MinCount; //加密币最小转账金额
@property(nonatomic, copy) NSString *CoinBalance; //加密币可用余额
@property(nonatomic, copy) NSString *FiatCurrency; //法币编码
@property(nonatomic, copy) NSString *Price; //加密币兑法币汇率
@property(nonatomic, copy) NSString *ChargeFee; //手续费
@property(nonatomic, assign) NSInteger CoinDecimalPlace; //小数点位数

@property(nonatomic, copy) NSString *email;
@property(nonatomic, copy) NSString *phone;
@property(nonatomic, copy) NSString *userhash;

@property(nonatomic, copy) NSString *groupSendAmount;


// TODO: Remove both givenName and familyName when backend is ready to return them separately (one field for each).
- (NSString *)givenName;
- (NSString *)familyName;

@end
