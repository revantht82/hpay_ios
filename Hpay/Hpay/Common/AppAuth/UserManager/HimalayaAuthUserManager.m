//
//  HimalayaAuthUserManager.m
//  Hpay
//
//  Created by Olgu Sirman on 17/05/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "HimalayaAuthUserManager.h"
#import "HimalayaAuthNotificationHelper.h"
#import "PINSetViewController.h"
#import "HimalayaAuthManagerErrorHelper.h"
#import "HimalayaAuthKeychainManager.h"
#import "AppAuth.h"

@interface HimalayaAuthUserManager ()

@end

@implementation HimalayaAuthUserManager

/// Creates request to the userinfo endpoint with access token in the Authorization header
- (void)getUserInfoWith:(NSString * _Nonnull)accessToken
       userinfoEndpoint:(NSURL *)userinfoEndpoint
          withAuthState:(OIDAuthState *)authState
 withFreshTokenCallback:(FreshTokenFetchProcessActivationCallback)freshTokenCallback
    withFailureCallback:(GetUserInfoFailureCallback)failureCallback
    withSuccessCallback:(GetUserInfoSuccessCallback)successCallback {
    
    #if MOCK
    userinfoEndpoint = [NSURL URLWithString:UserInfoURL];
    #endif
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:userinfoEndpoint];
    NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", accessToken];
    [request addValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionConfiguration *configuration =
    [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration
                                                          delegate:nil
                                                     delegateQueue:nil];
    
    NSURLSessionDataTask *postDataTask =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData *_Nullable data,
                                   NSURLResponse *_Nullable response,
                                   NSError *_Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^() {
            if (error) {
                NSError *authError = [HimalayaAuthManagerErrorHelper errorOccuredWithType:AuthManagerErrorUserInfoResponse withMessage:nil];
                [self handleError:&authError];

                if (freshTokenCallback) {
                    freshTokenCallback(NO);
                }
                return;
            }
            if (![response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSError *authError = [HimalayaAuthManagerErrorHelper errorOccuredWithType:AuthManagerErrorUserInfoNSHTTPURLResponse withMessage:nil];
                [self handleError:&authError];
                if (freshTokenCallback) {
                    freshTokenCallback(NO);
                }
                return;
            }
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            id userJsonObject =
            [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            
            if (httpResponse.statusCode != 200) {
                // server replied with an error
                if (httpResponse.statusCode == 401) {
                    // "401 Unauthorized" generally indicates there is an issue with the authorization
                    // grant. Puts OIDAuthState into an error state.
                    NSError *oauthError =
                    [OIDErrorUtilities resourceServerAuthorizationErrorWithCode:0
                                                                  errorResponse:userJsonObject
                                                                underlyingError:error];
                    [authState updateWithAuthorizationError:oauthError];

                    NSError *authError = [HimalayaAuthManagerErrorHelper errorOccuredWithType:AuthManagerErrorOAuthError withCurrentError:oauthError];
                    [self handleError:&authError];
                    
                    if (failureCallback && authError) {
                        failureCallback(authError);
                    }
                    
                } else {
                    NSError *authError = [HimalayaAuthManagerErrorHelper errorOccuredWithType:AuthManagerErrorUserInfoNSHTTPURLResponse withMessage:nil];
                    [self handleError:&authError];
                    
                    if (failureCallback && authError) {
                        failureCallback(authError);
                    }
                }
                
                if (freshTokenCallback) {
                    freshTokenCallback(NO);
                }
                return;
            }
            
            [self handleUserWithUserObject:userJsonObject
                             withAuthState:authState
                    withFreshTokenCallback:freshTokenCallback
                       withFailureCallback:failureCallback
                       withSuccessCallback:successCallback];
            
        });
    }];
    
    [postDataTask resume];
}

#pragma mark - Error Helper

- (void)handleError:(NSError **)error {
    [HCLogger recordErrorWithError:*error];
}

#pragma mark - UserHelper
- (nullable HCIdentityUser *)isUserObjectIsValidWith:(id)userObject withError:(NSError **)errorPtr {
    
    if (errorPtr) {
        if ((userObject != nil) && [userObject isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *userObjectDict = (NSDictionary *)userObject;
            HCIdentityUser *user = [HCIdentityUser fromJSONDictionary:userObjectDict];
            
            if (user.sub != nil) {
                return user;
            } else {
                NSError *userObjectValidationError = [HimalayaAuthManagerErrorHelper errorOccuredWithType:AuthManagerErrorUserObjectValidation withMessage:nil];
                *errorPtr = userObjectValidationError;
                return nil;
            }

        } else {
            NSError *userSerializationError = [HimalayaAuthManagerErrorHelper errorOccuredWithType:AuthManagerErrorUserSerialization withMessage:nil];
            *errorPtr = userSerializationError;
            return nil;
        }
    }
    
    return nil;
}

- (void)handleUserWithUserObject:(id)userObject
                   withAuthState:(OIDAuthState *)authState
          withFreshTokenCallback:(FreshTokenFetchProcessActivationCallback)freshTokenCallback
             withFailureCallback:(GetUserInfoFailureCallback)failureCallback
             withSuccessCallback:(GetUserInfoSuccessCallback)successCallback {
    
    NSError *userError;
    
    HCIdentityUser *user = [self isUserObjectIsValidWith:userObject withError:&userError];
    if (!user || userError) {
        [self handleError:&userError];
        
        if (failureCallback) {
            failureCallback(userError);
        }
        
        if (freshTokenCallback) {
            freshTokenCallback(NO);
        }
        return;
    }

    if (freshTokenCallback) {
        freshTokenCallback(NO);
    }
    
    [self updateUserWith:user withAuthState:authState withSuccessCallback:successCallback];
    [HimalayaAuthNotificationHelper executeAuthStateNotificationWithUser:user withAuthState:authState];
    [HimalayaAuthNotificationHelper executeLoginSuccess];
}

- (void)updateUserWith:(nonnull HCIdentityUser *)user
         withAuthState:(OIDAuthState *)authState
   withSuccessCallback:(GetUserInfoSuccessCallback)successCallback {
    
    self.user = user;
    [[GCUserManager manager] saveUser:user];
    [HimalayaAuthKeychainManager saveUserDataToKeychain:user];
    
    if (successCallback) {
        successCallback(user);
    }
}

@end
