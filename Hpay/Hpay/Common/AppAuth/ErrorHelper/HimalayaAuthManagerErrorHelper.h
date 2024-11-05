//
//  AuthManagerErrorHelper.h
//  Hpay
//
//  Created by Olgu Sirman on 08/05/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HimalayaAuthManagerErrorType.h"

NS_ASSUME_NONNULL_BEGIN

@interface HimalayaAuthManagerErrorHelper : NSObject

+ (nonnull NSError *)errorOccuredWithType:(AuthManagerError)errorType withMessage:(nullable NSString *)message;
+ (nonnull NSError *)errorOccuredWithType:(AuthManagerError)errorType withCurrentError:(nonnull NSError*)currentError;

@end

NS_ASSUME_NONNULL_END
