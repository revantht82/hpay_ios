//
//  PINSetType.h
//  Hpay
//
//  Created by Olgu Sirman on 21/01/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#ifndef PINSetType_h
#define PINSetType_h

typedef enum : NSUInteger {
    PINSetTypeVerifyOldPIN,                 //修改PIN验证旧PIN码
    PINSetTypeVerifySetNewPIN,
    PINSetTypeVerifyCheckSetNewPIN,
    PINSetTypeVerifyReSetNewPIN,            //输入设置PIN
    PINSetTypeVerifyCheckReSetNewPIN,       //再次输入设置PIN
    PINSetTypeMustVerifyCheckReSetNewPIN,       //再次输入设置PIN //only for exceed limit
    PINSetTypeVerifyFirstSetNewPIN,
    PINSetTypeVerifyFirstCheckSetNewPIN,
    PINResetTypeVerifyPIN,
    PINResetTypeMustVerifyPIN
} PINSetType;

#endif /* PINSetType_h */
