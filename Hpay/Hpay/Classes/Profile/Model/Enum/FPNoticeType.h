//
//  FPNoticeType.h
//  Hpay
//
//  Created by Olgu Sirman on 19/01/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#ifndef FPNoticeType_h
#define FPNoticeType_h

typedef enum : NSUInteger {
    FPNoticeTypeToBePaid = 0,//待支付
    FPNoticeTypeReceiptSuccess = 1,//收款成功
    FPNoticeTypePaySuccess = 2,//（消费）付款成功
    FPNoticeTypeRefundSuccess = 3,//退款成功
    FPNoticeTypeArtice = 4,//系统公告
    FPNoticeTypeDepositSuccess = 5,//充币成功
    FPNoticeTypeWithdrawalSuccess = 6,//提币成功
    FPNoticeTypeWithdrawalReject = 7,//提币失败（被拒绝）
    FPNoticeTypeKYCLv1Verfiied = 8, //lv1审核通过
    FPNoticeTypeKYCLv1Reject = 9,//lv1审核被拒
    FPNoticeTypeKYCLv2Verfiied = 10, //lv2审核通过
    FPNoticeTypeKYCLv2Reject = 11,//lv2审核被拒
    FPNoticeTypeDepositFailed = 14,//充币失败
    FPNoticeTypeTransferReceived = 15,//用户收到转账
    FPNoticeTypeTransferSuccess = 16, //转账成功
//    FPNoticeTypeShoppingOnlinePaySuccess = 22,//线上消费成功
//    FPNoticeTypeShoppingOnlineRefundSuccess = 23,//线上消费退款成功
    FPNoticeTypePurchaseOrderReleased = 24,//买币已放币
    FPNoticeTypePurchaseOrderAuditFailure = 25,//购买币审核失败
    FPNoticeTypePaymentGatewayOrderIncome = 30,//网关订单收入
    FPNoticeTypePaymentGatewayOrderOutcome = 31,//网关订单支出
    FPNoticeTypePaymentGatewayOrderRefundOut = 32,//网关支付退单(网关商家)
    FPNoticeTypePaymentGatewayOrderRefundIn = 33,//网关支付退款(用户)
    FPNoticeTypeExchangeOut = 34,//划转（转出）
    FPNoticeTypeExchangeIn = 35,//划转（转入）
    FPNoticeTypeSellTokenSuccess = 36,//售币成功
    FPNoticeTypeSellTokenFailure = 37,//售币失败
} FPNoticeType;


#endif /* FPNoticeType_h */
