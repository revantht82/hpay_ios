#import "GLCNetworkRequest.h"
#import "HomeCurrentcy.h"
#import "FPIndexOM.h"
#import "FPPrePayOM.h"
#import "FPOrderDetailModel.h"
#import "PreTransferModel.h"
#import "PaymentViewController.h"
#import "HimalayaPayAPIManager.h"

@interface HomeHelperModel : HimalayaPayAPIManager
// 获取支付码
+ (void)getPaymentCodeBlock:(void (^)(NSString *paymentCode, NSString *message, NSInteger errorCode))completBlock;

/**
 获取首页数据，总金额已经由服务端计算

 @param completBlock <#completBlock description#>
 */
+ (void)fetchHomePageIndexCompleteBlock:(void (^)(FPIndexOM *model, NSInteger errorCode, NSString *errorMessage))completBlock;

/**
 * desc 主动支付（蓝牙、二维码、NFC都走这个流程） - 准备支付，将会传递溢价等参数
 * param MerchantId 商家Id，MerchantId与MerchantCode二者必填一个，两个都有值的话使用MerchantId
 * param MerchantCode 商家15位的随机码，MerchantId与MerchantCode二者必填一个，两个都有值的话使用MerchantId
 */
+ (void)fetchOrderPrePayByMerchantId:(NSString *)MerchantId orMerchantCode:(NSString *)MerchantCode completeBlock:(void (^)(FPPrePayOM *model, NSInteger errorCode, NSString *errorMessage))completBlock;

/// 获取待支付订单
/// @param orderId <#orderId description#>
/// @param completBlock <#completBlock description#>
+ (void)fetchToBePaidOrderWithOrderId:(NSString *)orderId
                        completeBlock:(void (^)(NSDictionary *dict, NSInteger errorCode, NSString *errorMessage))completBlock;


/**
 支付已经存在的订单

 @param OrderNO OrderId
 @param Pin 加密多的Pin
 */
+ (void)payExistedOrder:(NSString *)OrderNO
                    Pin:(NSString *)Pin
                   type:(FPPaymentType)type
          completeBlock:(void (^)(FPOrderDetailModel *model, NSInteger errorCode, NSString *errorMessage))completBlock;


/**
 准备转账

 @param coinId 币种ID
 @param toCountryId 国家ID
 @param toCellphone 手机号
 @param completBlock 回调
 */
+ (void)preTransfer:(NSString *)coinId
        toCountryId:(NSString *)toCountryId
        toCellphone:(NSString *)toCellphone
              email:(NSString *)email
       completBlock:(void (^)(NSInteger errorCode, NSString *message, PreTransferModel *transferModel))completBlock;

+ (void)fetchUser: (NSString*)hassedID
     completBlock:(void (^)(NSDictionary *message))completBlock;
       
+ (void)preTransfer:(NSString *)coinId
        toUserHash:(NSString *)toUserHash
       completBlock:(void (^)(NSInteger errorCode, NSString *message, PreTransferModel *transferModel))completBlock;
/**
 转账

 @param accountType 转账类型ID
 @param accountID 转账id
 @param coinId 转账加密币币种Id
 @param amount 转账金额
 @param pin Pin
 @param completBlock block
 */
+ (void)transferWithAccountType:(NSString *)accountType
                      accountID:(NSString *)accountID
                       userHash:(NSString *)userHash
                         coinId:(NSString *)coinId
                          amout:(NSString *)amount
                            pin:(NSString *)pin
                      reference:(NSString *)reference
      CheckDuplicateTransaction:(NSString*)CheckDuplicateTransaction
        completBlock:(void (^)(NSInteger errorCode, NSString *message, NSDictionary *dict))completBlock;

+ (void)transferToGroup:(NSArray *)users
                         coinId:(NSString *)coinId
                          amout:(NSString *)amount
                            pin:(NSString *)pin
                      reference:(NSString *)reference
           completBlock:(void (^)(NSInteger errorCode, NSString *message, NSDictionary *dict))completBlock;

// 验证用户是否可以转账
+ (void)checkTransferAbleCompletBlock:(void (^)(NSInteger errorCode, BOOL transferAble, NSString *message))completBlock;

#pragma mark - 划转

/// HPay 获取划转数据
/// @param completBlock 成功数据
+ (void)getHuaZhuanHomeMsgCompleteBlock:(void (^)(NSArray *huazhuanArr, NSInteger errorCode, NSString *errorMessage))completBlock;

+ (void)getCategoriesBlock:(void (^)(NSArray *categoriesArr, NSInteger errorCode, NSString *errorMessage))completBlock;

///  HPay 划转订单
/// @param amount 金额
/// @param CryptoId 币种id
/// @param pin pin码
/// @param completBlock 订单信息
+ (void)creatHuaZhuanOrderWithCryptoId:(NSString *)CryptoId
                                amount:(NSString *)amount
                                   pin:(NSString *)pin
             CheckDuplicateTransaction:(NSString *)CheckDuplicateTransaction
                         CompleteBlock:(void (^)(NSDictionary *orderDic, NSInteger errorCode, NSString *errorMessage))completBlock;


@end
