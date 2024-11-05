//
//  WithdrawalAddressNavigationRequest.h
//  Hpay
//
//  Created by Olgu Sirman on 23/01/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#ifndef WithdrawalAddressNavigationRequest_h
#define WithdrawalAddressNavigationRequest_h

struct WithdrawalAddressNavigationRequest {
    NSInteger coinId;
    BOOL needTag;
    NSString * _Nullable coinCode;
};

#endif /* WithdrawalAddressNavigationRequest_h */
