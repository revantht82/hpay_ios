//
//  HimalayaAuthManagerErrorType.h
//  Hpay
//
//  Created by Olgu Sirman on 17/05/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#ifndef HimalayaAuthManagerErrorType_h
#define HimalayaAuthManagerErrorType_h

typedef NS_ENUM(NSInteger, AuthManagerError) {
    AuthManagerErrorGeneric = 990001,
    AuthManagerErrorNoTokenResponse = 990002,
    AuthManagerErrorUserInfoResponse = 990003,
    AuthManagerErrorUserInfoNSHTTPURLResponse = 990004,
    AuthManagerErrorFetchFreshToken = 990005,
    AuthManagerErrorUserSerialization = 990006,
    AuthManagerErrorUserObjectValidation = 990007,
    AuthManagerErrorNoUserInfoEndpoint = 990008,
    AuthManagerErrorAuthStateGeneric = 990009,
    AuthManagerErrorAuthStateRegistration = 990010,
    AuthManagerErrorAuthorizationError = 990012,
    AuthManagerErrorOAuthError = 990013,
    AuthManagerErrorEndSessionError = 990014,
    AuthManagerErrorNoEndSessionURL = 990015
};

#endif /* HimalayaAuthManagerErrorType_h */
