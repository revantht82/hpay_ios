//
//  AuthNotificationHelper.h
//  Hpay
//
//  Created by Olgu Sirman on 15/05/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OIDAuthState;

NS_ASSUME_NONNULL_BEGIN

@interface HimalayaAuthNotificationHelper : NSObject

+ (void)executeAuthStateNotificationWithUser:(nullable HCIdentityUser *)user withAuthState:(nullable OIDAuthState *)authState;
+ (void)executeLoginSuccess;

@end

NS_ASSUME_NONNULL_END
