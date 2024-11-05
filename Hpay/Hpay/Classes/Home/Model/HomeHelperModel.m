//
//  HomeHelperModel.m
//  FiiiPay
//
//  Created by Singer on 2018/4/8.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "HomeHelperModel.h"
#import "ApiError.h"
//#import "UIAlertController+Window.h"

@implementation HomeHelperModel

+ (void)getPaymentCodeBlock:(void (^)(NSString *paymentCode, NSString *message, NSInteger errorCode))completBlock {
    
    [self GET:OrderGetPaymentCodeURL parameters:nil successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        NSString *paymentCode = (NSString *) data;
        completBlock(paymentCode, nil, kFPNetRequestSuccessCode);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        completBlock(nil, message, code);
    }];
}

/**
 获取首页数据，总金额已经由服务端计算
 
 @param completBlock <#completBlock description#>
 */
+ (void)fetchHomePageIndexCompleteBlock:(void (^)(FPIndexOM *model, NSInteger errorCode, NSString *errorMessage))completBlock {
    [self GET:HomePageIndexURL parameters:nil successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        NSDictionary *dict = (NSDictionary *) data;
        FPIndexOM *model = [FPIndexOM objectWithKeyValuesWithM:dict];
        completBlock(model, kFPNetRequestSuccessCode, nil);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        completBlock(nil, code, message);
    }];
}

#pragma mark - 主动支付（蓝牙、二维码、NFC都走这个流程） - 准备支付，将会传递溢价等参数

+ (void)fetchOrderPrePayByMerchantId:(NSString *)MerchantId orMerchantCode:(NSString *)MerchantCode completeBlock:(void (^)(FPPrePayOM *model, NSInteger errorCode, NSString *errorMessage))completBlock {
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithCapacity:1];
    if (MerchantId && MerchantId.length > 0) {
        mDict[@"MerchantId"] = MerchantId;
    } else if (MerchantCode && MerchantCode.length > 0) {
        mDict[@"MerchantCode"] = MerchantCode;
    }
    
    [self POST:OrderPrePayURL parameters:mDict successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        NSDictionary *dict = (NSDictionary *) data;
        FPPrePayOM *model = [FPPrePayOM objectWithKeyValuesWithM:dict];
        completBlock(model, kFPNetRequestSuccessCode, nil);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        completBlock(nil, code, message);
    }];
}

/// 获取待支付订单
/// @param orderId orderId description
/// @param completBlock <#completBlock description#>
+ (void)fetchToBePaidOrderWithOrderId:(NSString *)orderId
                        completeBlock:(void (^)(NSDictionary *dict, NSInteger errorCode, NSString *errorMessage))completBlock {
    [self GET:OrderToBePaidExistedOrderURL parameters:@{@"OrderId": orderId} successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        NSDictionary *dictt = (NSDictionary *) data;
        completBlock(dictt, kFPNetRequestSuccessCode, nil);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        completBlock(nil, code, message);
    }];
}

+ (void)payExistedOrder:(NSString *)OrderNO
                    Pin:(NSString *)Pin
                   type:(FPPaymentType)type
          completeBlock:(void (^)(FPOrderDetailModel *model, NSInteger errorCode, NSString *errorMessage))completBlock {
    NSString *url = OrderPayExistedOrderURL;
    if (type == FPPaymentTypeWithGatewayOrderQRCode) {
        url = GatewayOrderPayURL;
    }
    [self POST:url parameters:@{@"OrderId": OrderNO, @"Pin": Pin} successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        NSDictionary *dict = (NSDictionary *) data;
        FPOrderDetailModel *model = [FPOrderDetailModel mj_objectWithKeyValues:dict];
        completBlock(model, kFPNetRequestSuccessCode, nil);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        completBlock(nil, code, message);
    }];
}

+ (void)preTransfer:(NSString *)coinId
        toCountryId:(NSString *)toCountryId
        toCellphone:(NSString *)toCellphone
              email:(NSString *)email
       completBlock:(void (^)(NSInteger errorCode, NSString *message, PreTransferModel *transferModel))completBlock {
    
    NSMutableDictionary *params;
    if (email) {
        params = [NSMutableDictionary dictionaryWithDictionary:@{@"Email": email}];
    }
    else {
        params = [NSMutableDictionary dictionaryWithDictionary:@{@"ToCountryId": toCountryId, @"ToCellphone": toCellphone}];
    }
    
    if (coinId) {
        [params setValue:coinId forKey:@"CryptoId"];
    }
    
    [self POST:email ? TransferPreEmailTransferURL : TransferPreMobileTransferURL parameters:params successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        NSDictionary *dict = (NSDictionary *) data;
        PreTransferModel *model = [PreTransferModel mj_objectWithKeyValues:dict];
        completBlock(kFPNetRequestSuccessCode, nil, model);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        completBlock(code, message, nil);
    }];
}

+ (void)preTransfer:(NSString *)coinId
        toUserHash:(NSString *)toUserHash
        completBlock:(void (^)(NSInteger errorCode, NSString *message, PreTransferModel *transferModel))completBlock {
    
    [self POST:TransferPreHashTransferURL parameters:@{@"userHash": toUserHash} successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        NSDictionary *dict = (NSDictionary *) data;
        PreTransferModel *model = [PreTransferModel mj_objectWithKeyValues:dict];
        completBlock(kFPNetRequestSuccessCode, nil, model);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        completBlock(code, message, nil);
    }];
}

+ (void)fetchUser:(NSString *)hashedID completBlock:(void (^)(NSDictionary *__strong))completBlock {
    [self POST:HashedUser parameters:@{@"userHash": hashedID} successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        NSDictionary *dict = (NSDictionary *) data;
        completBlock(dict);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];

        completBlock(dict);
    }];
}

+ (void)transferWithAccountType:(NSString *)accountType
                      accountID:(NSString *)accountID
                      userHash:(NSString *)userHash
                         coinId:(NSString *)coinId
                          amout:(NSString *)amount
                            pin:(NSString *)pin
                      reference:(NSString *)reference
      CheckDuplicateTransaction:(NSString *)CheckDuplicateTransaction
                   completBlock:(void (^)(NSInteger errorCode, NSString *message, NSDictionary *dict))completBlock {
        
    NSMutableDictionary *parametersDict = [[NSMutableDictionary alloc]init];
    parametersDict[@"toAccountType"] = accountType;
    parametersDict[@"toAccountId"] = accountID;
    parametersDict[@"userHash"] = userHash;
    parametersDict[@"CryptoId"] = coinId;
    parametersDict[@"Amount"] = amount;
    parametersDict[@"Pin"] = pin;
    parametersDict[@"Reference"] = reference;
    
    if (CheckDuplicateTransaction != nil) {
        parametersDict[@"CheckDuplicateTransaction"] = @"true";
    }
    
    [self POST:TransferCreateURL parameters:parametersDict successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        NSDictionary *dict = (NSDictionary *) data;
        completBlock(kFPNetRequestSuccessCode, nil, dict);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        if(code == 11000){
            completBlock(code, nil, nil);
        }
        else{
            completBlock(code, message, nil);
        }
    }];
}

+ (void)transferToGroup:(NSArray *)users
                         coinId:(NSString *)coinId
                          amout:(NSString *)amount
                            pin:(NSString *)pin
                      reference:(NSString *)reference
                   completBlock:(void (^)(NSInteger errorCode, NSString *message, NSDictionary *dict))completBlock {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HPAYGroupSendInProgress"]){
        return;
    }
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"HPAYGroupSendInProgress"];
    
    NSMutableDictionary *parametersDict = [[NSMutableDictionary alloc]init];
    parametersDict[@"CryptoId"] = coinId;
    parametersDict[@"Pin"] = pin;
    parametersDict[@"Amount"] = amount;
    parametersDict[@"Reference"] = reference;
    parametersDict[@"Users"] = users;
    
    [self POST:GroupTransferCreateURL parameters:parametersDict successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"HPAYGroupSendInProgress"];
        
        NSDictionary *dict = (NSDictionary *) data;
        completBlock(kFPNetRequestSuccessCode, nil, dict);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"HPAYGroupSendInProgress"];
        
        if(code == 11000){
            completBlock(code, nil, nil);
        }
        else{
            completBlock(code, message, nil);
        }
    }];
}

+ (void)checkTransferAbleCompletBlock:(void (^)(NSInteger errorCode, BOOL transferAble, NSString *message))completBlock {
    [self GET:TransferCheckTransferAbleURL parameters:nil successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        
        NSNumber *able = (NSNumber *) data;
        completBlock(kFPNetRequestSuccessCode, [able boolValue], nil);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        completBlock(code, NO, message);
    }];
}

#pragma mark - 划转

/// HPay 获取划转数据
/// @param completBlock 成功数据
+ (void)getHuaZhuanHomeMsgCompleteBlock:(void (^)(NSArray *huazhuanArr, NSInteger errorCode, NSString *errorMessage))completBlock {
    
    [self GET:HuaZhuanPageInitURL parameters:nil successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        NSDictionary *dict = (NSDictionary *) data;
        NSArray *arr = dict[@"UserCryptoInfoList"];
        completBlock(arr, kFPNetRequestSuccessCode, nil);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        completBlock(nil, code, message);
    }];
}

+ (void)getCategoriesBlock:(void (^)(NSArray *categoriesArr, NSInteger errorCode, NSString *errorMessage))completBlock {
    
    [HimalayaPayAPIManager GET:MerchantProductCategory parameters:nil successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        NSDictionary *dict = (NSDictionary *) data;
        NSArray *arr = dict[@"ProductCategoryList"];
        completBlock(arr, kFPNetRequestSuccessCode, NULL);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        ApiError* error = [ApiError errorWithCode:code message:message];
        completBlock(NULL, code, error.prettyMessage);
    }];
}


///  HPay 划转订单
/// @param amount 金额
/// @param CryptoId 币种id
/// @param pin pin码
/// @param completBlock 订单信息
+ (void)creatHuaZhuanOrderWithCryptoId:(NSString *)CryptoId
                                amount:(NSString *)amount
                                   pin:(NSString *)pin
             CheckDuplicateTransaction:(NSString *)CheckDuplicateTransaction
                         CompleteBlock:(void (^)(NSDictionary *orderDic, NSInteger errorCode, NSString *errorMessage))completBlock {
    
    NSMutableDictionary *parametersDict = [[NSMutableDictionary alloc]init];
    parametersDict[@"CryptoId"] = CryptoId;
    parametersDict[@"Amount"] = amount;
    parametersDict[@"pin"] = pin;
    
    if (CheckDuplicateTransaction != nil) {
        parametersDict[@"CheckDuplicateTransaction"] = @"true";
    }
    
    [self POST:HuaZhuanCreateURL parameters: parametersDict successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        NSDictionary *dict = (NSDictionary *) data;
        completBlock(dict, kFPNetRequestSuccessCode, nil);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        if(code == 11000){
            
            NSLog(@"DUBLICATE DETECTED !!!");
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedDefault(@"alert") message:NSLocalizedDefault(@"possible_dublicate_transaction_text") preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedDefault(@"okay") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self POST:HuaZhuanCreateURL parameters:@{@"CryptoId": CryptoId, @"amount": amount, @"pin": pin} successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
                    NSDictionary *dict = (NSDictionary *) data;
                    completBlock(dict, kFPNetRequestSuccessCode, nil);
                    NSLog(@"Successteyiz");
                } failureBlock:^(NSInteger code, NSString *_Nullable message) {
                    NSLog(@"Failuredayiz");
                    completBlock(nil, code, message);
                }];
                
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedDefault(@"Cancel") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSLog(@"cancelled");
                completBlock(nil, code, message);
            }]];
            completBlock(nil, code, message);
            
        }
        else{
            completBlock(nil, code, message);
        }
    }];
}

@end
