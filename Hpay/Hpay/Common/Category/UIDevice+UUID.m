//
//  UIDevice+UUID.m
//  FiiiPay
//
//  Created by Singer on 2019/6/24.
//  Copyright © 2019 Himalaya. All rights reserved.
//

#import "UIDevice+UUID.h"

@implementation UIDevice (UUID)

+ (NSString *)uuidForDevice {
    return [NSUUID UUID].UUIDString;
}

@end
