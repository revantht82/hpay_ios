//
//  FPDevice.h
//  FiiiPay
//
//  Created by Singer on 2019/3/7.
//  Copyright © 2019 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FPDevice : NSObject
@property(nonatomic, copy) NSString *Id;
@property(nonatomic, copy) NSString *Name;
@property(nonatomic, copy) NSString *LastActiveTime;
@property(nonatomic, copy) NSString *IP;
@property(nonatomic, copy) NSString *Address;
@property(nonatomic, copy) NSString *DeviceNumber;
@end

NS_ASSUME_NONNULL_END
