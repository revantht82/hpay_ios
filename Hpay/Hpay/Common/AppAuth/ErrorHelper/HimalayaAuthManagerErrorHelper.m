//
//  AuthManagerErrorHelper.m
//  Hpay
//
//  Created by Olgu Sirman on 08/05/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "HimalayaAuthManagerErrorHelper.h"

static NSString *const errorDomain = @"AuthManagerError";

@implementation HimalayaAuthManagerErrorHelper

+ (nonnull NSError *)errorOccuredWithType:(AuthManagerError)errorType withMessage:(nullable NSString *)message {
    
    NSString *errorDescription = [self errorDescriptionWithType:errorType withMessageIfNeeded:message];
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: errorDescription};
    
    NSError *error = [NSError errorWithDomain:self.domain
                                         code:errorType
                                     userInfo:userInfo];
    
    return error;
}

+ (nonnull NSError *)errorOccuredWithType:(AuthManagerError)errorType withCurrentError:(nonnull NSError*)currentError {
    
    NSString *errorDescription = [self errorDescriptionWithType:errorType withMessageIfNeeded:currentError.localizedDescription];
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: errorDescription};
    
    NSError *error = [NSError errorWithDomain:self.domain
                                         code:currentError.code
                                     userInfo:userInfo];
    
    return error;
}

+ (NSString *)domain {
    NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
    NSString *domain = [NSString stringWithFormat:@"%@.%@", bundleId, errorDomain];
    return domain;
}

+ (NSString *)errorDescriptionWithType:(AuthManagerError)errorType withMessageIfNeeded:(nullable NSString *)message {
    
    // TODO: Localized it later
    NSString *errorDesc = @"Some error occured";
    
    if (message) {
        errorDesc = message;
    }
    
    switch (errorType) {
        case AuthManagerErrorGeneric:
            errorDesc = NSLocalizedString(@"SomeErrorOccured", @"Can not serialized object");
            break;
        case AuthManagerErrorNoTokenResponse:
            errorDesc = NSLocalizedString(@"SomeErrorOccured", @"Can not serialized object");
            break;
        case AuthManagerErrorUserInfoResponse:
            errorDesc = NSLocalizedString(@"SomeErrorOccured", @"Can not serialized object");
            break;
        case AuthManagerErrorUserInfoNSHTTPURLResponse:
            errorDesc = NSLocalizedString(@"SomeErrorOccured", @"Can not serialized object");
            break;
        case AuthManagerErrorFetchFreshToken:
            errorDesc = NSLocalizedString(@"SomeErrorOccured", @"Can not serialized object");
            break;
        case AuthManagerErrorNoEndSessionURL:
            errorDesc = NSLocalizedString(@"unexpected_error", @"LogOut error happened");
        default:
            break;
    }
    
    return errorDesc;
}
@end
