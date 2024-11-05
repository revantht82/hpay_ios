//
//  HimalayaAuthUserManager.h
//  Hpay
//
//  Created by Olgu Sirman on 17/05/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FreshTokenFetchProcessActivationCallback)(BOOL isFreshTokenFetchProcessActive);
typedef void (^GetUserInfoSuccessCallback)(HCIdentityUser * _Nonnull user);
typedef void (^GetUserInfoFailureCallback)(NSError * _Nonnull error);

@class OIDAuthState;

NS_ASSUME_NONNULL_BEGIN

@interface HimalayaAuthUserManager : NSObject

@property (strong, nonatomic, nullable) HCIdentityUser *user;
@property (strong, nonatomic, nullable) UIViewController *delegateController;

- (void)getUserInfoWith:(NSString * _Nonnull)accessToken
       userinfoEndpoint:(NSURL *)userinfoEndpoint
          withAuthState:(OIDAuthState *)authState
 withFreshTokenCallback:(FreshTokenFetchProcessActivationCallback)freshTokenCallback
    withFailureCallback:(GetUserInfoFailureCallback)failureCallback
    withSuccessCallback:(GetUserInfoSuccessCallback)successCallback;

@end

NS_ASSUME_NONNULL_END
