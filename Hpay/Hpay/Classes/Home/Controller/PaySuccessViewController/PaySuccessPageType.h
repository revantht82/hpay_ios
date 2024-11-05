//
//  PaySuccessPageType.h
//  Hpay
//
//  Created by Olgu Sirman on 13/01/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#ifndef PaySuccessPageType_h
#define PaySuccessPageType_h

typedef NS_ENUM(NSInteger, PageSuccess) {
    PageSuccessPay = 0,                 // Default
    PageSuccessWithdrawalApply = 1,     // Withdrawal application
    PageSuccessWithTransfer = 2,        // Successful transfer
    PageSuccessWithExchange = 3,        // Successful transfer
    PageSuccessWithLife = 4,            // Successful living payment
    PageSuccessWithStore = 5,           // Store payment successful
    PageSuccessWithGPayExchange = 6,    // GPay flash redemption successful
    PageSuccessWithGatewayOrder = 7,    // Gateway order payment is successful
    PageSuccessWithRequestFund = 8    // Request fund payment is successful
};

#endif /* PaySuccessPageType_h */
