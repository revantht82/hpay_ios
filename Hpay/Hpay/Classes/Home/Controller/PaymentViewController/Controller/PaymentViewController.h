//
//  PaymentViewController.h
//  FiiiPay
//
//  Created by Mac on 2018/10/8.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "FPViewController.h"
#import "PaymentClickType.h"
#import "PaymentType.h"

NS_ASSUME_NONNULL_BEGIN

@interface PaymentViewController : FPViewController

@property(nonatomic, copy) NSDictionary *dataDict;
@property(nonatomic, assign) FPPaymentType paymentType;
@property(nonatomic, copy) void (^clickBlock)(FPPaymentClickType type, NSObject *_Nullable data);
// 这个block是针对蓝牙主动付款页面，余额不足的回调
@property(nonatomic, copy) void (^lackBalanceBlock)(void);

- (void)dismiss:(void (^ __nullable)(void))completion;
@end

NS_ASSUME_NONNULL_END
