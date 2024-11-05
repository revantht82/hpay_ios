//
//  FPCountry.h
//  FiiiPay
//
//  Created by Singer on 2018/4/4.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FPCountry : NSObject <NSSecureCoding>
@property(nonatomic, copy) NSString *Name;
@property(nonatomic, copy) NSString *PhoneCode;
@property(nonatomic, copy) NSString *PinYin;
@end
