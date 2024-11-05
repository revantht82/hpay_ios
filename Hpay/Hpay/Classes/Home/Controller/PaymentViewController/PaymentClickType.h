//
//  PaymentClickType.h
//  Hpay
//
//  Created by Olgu Sirman on 13/01/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#ifndef PaymentClickType_h
#define PaymentClickType_h

typedef NS_ENUM(NSInteger, FPPaymentClickType) {
    FPPaymentClickTopupType = 0, //Recharge
    FPPaymentClickCloseType,     //shut down
    FPPaymentClickSuccessType,   //Payment success callback
    FPPaymentClickCancelType,    //Insufficient balance, click cancel
    FPPaymentClickLinkType,      //Disable, contact customer service
    FPPaymentClickExchangeRateChange, //Living expenses, exchange rate changes, resulting in changes in amount
    FPPaymentClickRedPacket, //Red envelope
    FPPaymentClickFiiiPayStore, //FiiiPay store payment
    FPPaymentDuplicateCancelType,
    FPGroupPaymentClickSuccessType,   //Payment success callback
};

#endif /* PaymentClickType_h */
