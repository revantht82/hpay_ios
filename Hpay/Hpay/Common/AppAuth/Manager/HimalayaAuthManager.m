//
//  HimalayaAuthManager.m
//  Bit58
//
//  Created by Olgu Sirman on 23/02/2021.
//  Copyright © 2021 YG. All rights reserved.
//

#import "HimalayaAuthManager.h"
#import "HimalayaAuthManagerErrorHelper.h"
#import "HimalayaAuthNotificationHelper.h"
#import "HimalayaAuthUserManager.h"
#import "HimalayaAuthKeychainManager.h"
#import <QuartzCore/QuartzCore.h>
#import "AppAuth.h"
#import "AppDelegate.h"
#import "GCUserManager.h"
#import "HCIdentityUser.h"
#import "HimalayaAuthManagerErrorType.h"
#import "HimalayaAuthNotificationKeys.h"
#import "NSObject+Extension.h"

typedef void (^PostRegistrationCallback)(OIDServiceConfiguration *configuration,
                                         OIDRegistrationResponse *registrationResponse);

@interface HimalayaAuthManager () <OIDAuthStateChangeDelegate, OIDAuthStateErrorDelegate>

/// AuthState executes multiple times, for refresh token and userInfo mechanims we need that boolean filter
@property (nonatomic, assign) BOOL isFreshTokenFetchProcessActive;
@property (nonatomic, strong) HimalayaAuthUserManager *userAuthManager;
@property (nonatomic, strong) id<HimalayaAuthKeychainState> keychainManager;

@end

@implementation HimalayaAuthManager

#pragma mark - Singleton

- (instancetype)init {
    self = [super init];
    if (self) {
        self.userAuthManager = [[HimalayaAuthUserManager alloc] init];
        self.keychainManager = [[HimalayaAuthKeychainManager alloc] init];
    }
    return self;
}

+ (instancetype)sharedManager {
    static HimalayaAuthManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSUserDefaults.standardUserDefaults setBool:NO forKey:kSessionExpiryShowingKey];
        _sharedManager = [[HimalayaAuthManager alloc] init];
    });

    return _sharedManager;
}

#pragma mark - Auth

- (void)authorizeWithPresenter:(UIViewController *)presenter {
    if ([self handleNetworkError]){
        return;
    }
    
    NSURL *issuer = [NSURL URLWithString:kIssuer];
        
    // discovers endpoints
    [OIDAuthorizationService discoverServiceConfigurationForIssuer:issuer
                                                        completion:^(OIDServiceConfiguration *_Nullable configuration, NSError *_Nullable error) {
        
        if ([self handleNetworkError]){
            return;
        }
        
        if (!configuration) {
            [self setAuthState:nil];
            [presenter showAlertWithTitle:@""
                             message:NSLocalizedString(@"pay_merchant_refresh.backend_error.title_label", @"")
                             actions:[NSArray arrayWithObjects:[AlertActionItem defaultOKItem], nil]];
            return;
        }
                
        [self doAuthWithAutoCodeExchange:configuration clientID:kClientID clientSecret:nil presenter:presenter];
    }];
}

- (AppDelegate*)appDelegate{
    return (AppDelegate*)UIApplication.sharedApplication.delegate;;
}

- (void)endSessionWithPresenter:(UIViewController *)presenter handler:(EndSessionCallBack)endSessionHandler {
    
    if (![self appDelegate]) {
        return;
    }
    
    if ([self handleNetworkError]){
        return;
    }
    
    OIDServiceConfiguration *configuration = self.authState.lastAuthorizationResponse.request.configuration;

    if (!configuration.endSessionEndpoint) {
        NSError *authError = [HimalayaAuthManagerErrorHelper errorOccuredWithType:AuthManagerErrorNoEndSessionURL withMessage:nil];
        [presenter showAlertWithTitle:@""
                         message:authError.localizedDescription
                         actions:[NSArray arrayWithObjects:[AlertActionItem defaultOKItem], nil]];

        return;
    }
    
    OIDEndSessionRequest *endSessionRequest = [[OIDEndSessionRequest alloc] initWithConfiguration:configuration
                                                                                       idTokenHint:self.authState.lastTokenResponse.idToken
                                                                             postLogoutRedirectURL:[NSURL URLWithString:kRedirectURI]
                                                                                             state:self.authState.lastAuthorizationResponse.state
                                                                              additionalParameters:nil];
    
    OIDExternalUserAgentIOS<OIDExternalUserAgent> *externalUserAgent = [[OIDExternalUserAgentIOS alloc] initWithPresentingViewController:presenter];
    
    [self appDelegate].currentAuthorizationFlow = [OIDAuthorizationService presentEndSessionRequest:endSessionRequest
                                    externalUserAgent:externalUserAgent
                                             callback:^(OIDEndSessionResponse * _Nullable endSessionResponse, NSError * _Nullable error) {
        if ([self handleNetworkError]){
            return;
        }
        
        if (error) {
            NSError *authError = [HimalayaAuthManagerErrorHelper errorOccuredWithType:AuthManagerErrorEndSessionError withMessage:nil];
            [self handleError:&authError];
            
            if (endSessionHandler) {
                endSessionHandler(nil, authError);
            }
            return;
        }
        
        if (endSessionHandler) {
            [self clearAuthState];
            endSessionHandler(endSessionResponse, nil);
        }
        
    }];
    
}

#pragma mark - Public Helpers

- (void)clearAuthState {
    [self setUser:nil];
    [self setAuthState:nil];
    [self.keychainManager deleteCache];
}

- (void)refreshAccessTokenIfNeededWithSuccessHandler:(void (^)(NSString * _Nullable))successBlock errorHandler:(void (^)(NSError * _Nullable))errorBlock{
        
    __block OIDAuthState *authState = _authState;

    if (!authState){
        return;
    }
    
    NSURL *userinfoEndpoint =
    authState.lastAuthorizationResponse.request.configuration.discoveryDocument.userinfoEndpoint;
    
    if (!userinfoEndpoint) {
        NSError *authError = [HimalayaAuthManagerErrorHelper errorOccuredWithType:AuthManagerErrorNoUserInfoEndpoint withMessage:nil];
        errorBlock(authError);
    }
                    
    [authState performActionWithFreshTokens:^(NSString *_Nonnull accessToken,
                                                   NSString *_Nonnull idToken,
                                                   NSError *_Nullable error) {
        if (error) {
            NSError *authError = [HimalayaAuthManagerErrorHelper errorOccuredWithType:AuthManagerErrorFetchFreshToken withMessage:nil];
            errorBlock(authError);
            return;
        }
        
        successBlock(accessToken);
    }];
    
}

- (NSData *)archivedDataWithObject:(id)object{
    return [NSKeyedArchiver archivedDataWithRootObject:object requiringSecureCoding:YES error:nil];
}

- (id)unarchiveObjectWithData:(NSData *)data{
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

#pragma mark - AuthState Helpers

- (BOOL)isAuthorized{
    return (_authState && _authState.isAuthorized);
}

- (void)saveState {
    if (self.authState == nil) {
        return;
    }
    NSData *authStateData = [self archivedDataWithObject:_authState];
    [self.keychainManager saveAuthDataToKeychain:authStateData];
}

- (void)loadState {
    NSError *error = nil;
    NSData *userKeychainData = [self.keychainManager loadAuthStateDataWithError:&error];
    
    if (!error && userKeychainData) {
        OIDAuthState *authState = [self unarchiveObjectWithData:userKeychainData];
        if (authState) {
            [self setAuthState:authState];
        }
    }
}

- (void)setAuthState:(nullable OIDAuthState *)authState {
    if (_authState == authState) {
        return;
    }
    _authState = authState;
    _authState.stateChangeDelegate = self;
    [self stateChanged];
}


- (void)stateChanged {
    [self saveState];
}

#pragma mark - OIDAuthStateChangeDelegate

- (void)didChangeState:(OIDAuthState *)state {
    [self stateChanged];
}

- (void)authState:(OIDAuthState *)state didEncounterAuthorizationError:(nonnull NSError *)error {
    NSError *authError = [HimalayaAuthManagerErrorHelper errorOccuredWithType:AuthManagerErrorAuthStateGeneric withCurrentError:error];
    [self handleError:&authError];
}

#pragma mark - Authorization

- (void)doAuthWithAutoCodeExchange:(OIDServiceConfiguration *)configuration
                          clientID:(NSString *)clientID
                      clientSecret:(NSString *)clientSecret
                         presenter:(UIViewController *)presenter{
    
    NSURL *redirectURI = [NSURL URLWithString:kRedirectURI];
    // builds authentication request
    OIDAuthorizationRequest *request =
    [[OIDAuthorizationRequest alloc] initWithConfiguration:configuration
                                                  clientId:clientID
                                              clientSecret:clientSecret
                                                    scopes:[self scopes]
                                               redirectURL:redirectURI
                                              responseType:OIDResponseTypeCode
                                      additionalParameters:nil];
    // performs authentication request
    if (![self appDelegate]) {
        return;
    }
    
    [self appDelegate].currentAuthorizationFlow =
    [OIDAuthState authStateByPresentingAuthorizationRequest:request
                                   presentingViewController:presenter
                                                   callback:^(OIDAuthState *_Nullable authState, NSError *_Nullable error) {
        /// Don't handle response if the operation is cancelled
        if (error.code == OIDErrorCodeUserCanceledAuthorizationFlow
            || error.code == OIDErrorCodeProgramCanceledAuthorizationFlow){
            return;
        }
        
        if (authState) {
            [self setAuthState:authState];
            [self notifyLoginSuccess];
        } else {
            [self setAuthState:nil];
            NSError *authError = [HimalayaAuthManagerErrorHelper errorOccuredWithType:AuthManagerErrorAuthorizationError withCurrentError:error];
            [self handleError:&authError];
        }
    }];
}

#pragma mark - Error Helper

- (BOOL)handleNetworkError{
    if (![self isNetworkConnected]){
        [self notifyLoginFailedWithErrorCode:kFPNetWorkErrorCode];
        return YES;
    }else{
        return NO;
    }
}

- (void)handleError:(NSError **)error {
    [self notifyLoginFailedWithErrorCode:(*error).code];
    [HCLogger recordErrorWithError:*error];
    [self clearAuthState];
}

- (void)notifyLoginSuccess{
    if (self.stateDelegate && [self.stateDelegate respondsToSelector:@selector(didLoginSucceed)]) {
        [self.stateDelegate didLoginSucceed];
    }
}

- (void)notifyLoginFailedWithErrorCode:(NSInteger)errorCode{
    if (self.stateDelegate && [self.stateDelegate respondsToSelector:@selector(didLoginFailedWithErrorCode:)]) {
        [self.stateDelegate didLoginFailedWithErrorCode:errorCode];
    }
}

- (NSArray<NSString *> *)scopes {
    NSMutableArray *ssoScopes = [NSMutableArray array];
    NSArray<NSString*> *extraScopes = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"AUTH_SCOPES"] componentsSeparatedByString:@" "];
    [ssoScopes addObjectsFromArray:@[OIDScopeOpenID, OIDScopeProfile]];
    [ssoScopes addObjectsFromArray:extraScopes];
    return [ssoScopes copy];
}

@end
