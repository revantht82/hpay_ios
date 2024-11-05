//
//  PaymentType.h
//  Hpay
//
//  Created by Olgu Sirman on 13/01/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#ifndef PaymentType_h
#define PaymentType_h

typedef NS_ENUM(NSInteger, FPPaymentType) {
    FPPaymentTypeNormal = 0,     //付款默认（扫码付款、二维码付款）
    FPPaymentTypeBlueTooth,      //蓝牙主动付款
    FPPaymentTypeWithdrawal,     //提币
    FPPaymentTypeWithtransfer,   //转账
    FPPaymentTypeWithScanQRCode, //扫描商家固态码付款
    FPPaymentTypeWithGatewayOrderQRCode,//扫描网关订单二维码
};

#endif /* PaymentType_h */
