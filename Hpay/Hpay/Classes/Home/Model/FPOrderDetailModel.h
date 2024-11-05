//
//  FPOrderDetailModel.h
//  FiiiPay
//
//  Created by Mac on 2018/4/10.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FPOrderDetailModel : NSObject

@property(nonatomic, copy) NSString *OrderId;
@property(nonatomic, copy) NSString *OrderNo;
@property(nonatomic, copy) NSString *Timestamp;
@property(nonatomic, copy) NSString *Amount;
@property(nonatomic, copy) NSString *Currency;
@property(nonatomic, copy) NSString *CryptoCode;
@property(nonatomic, copy) NSString *MerchantName;
@property(nonatomic, copy) NSString *Balance;
@property(nonatomic, copy) NSString *CoinId;  //钱包Id

@property(nonatomic, copy) NSString *FaitAmount;    //法币的金额
@property(nonatomic, copy) NSString *CryptoAmount;


//+ (instancetype)mPayExistedOrderModelWithData:(NSDictionary *)data;
@end
