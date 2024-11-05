//
//  AuthNotificationHelper.m
//  Hpay
//
//  Created by Olgu Sirman on 15/05/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "HimalayaAuthNotificationHelper.h"
#import "HimalayaAuthNotificationKeys.h"

@implementation HimalayaAuthNotificationHelper

+ (void)executeAuthStateNotificationWithUser:(nullable HCIdentityUser *)user withAuthState:(nullable OIDAuthState *)authState {

    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    if (authState) {
        userInfo[AuthStateNotificationKey] = authState;
    }
    
    if (user) {
        userInfo[IdentityUserDidUpdateKey] = user;
    }
    
    [self executeAuthStateUpdateWithUserInfo:userInfo];
}

+ (void)executeLoginSuccess {
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:nil];
}

#pragma mark - Private Helpers

+ (void)executeAuthStateUpdateWithUserInfo:(nonnull NSDictionary *)userInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:AuthStateUserDidUpdateNotificationKey object:userInfo];
}

@end
