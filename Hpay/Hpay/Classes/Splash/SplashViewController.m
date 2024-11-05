//
//  SplashViewController.m
//  Hpay
//
//  Created by Ugur Bozkurt on 20/08/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "SplashViewController.h"
#import "UseCase.h"
#import "FetchUserConfigAndInfoUseCase.h"
#import "UIViewController+UserConsent.h"
#import "HPDeeplinkNavigator.h"
#import "HimalayaAuthManager.h"
#import "HPNavigationRouter.h"
#import "ApiError.h"
#import "UIViewController+Alert.h"
#import "UserConfigResponse.h"
#import "HimalayaAuthKeychainManager.h"

@interface SplashViewController ()<TermsConditionsViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic) FetchUserConfigAndInfoUseCase *fetchUserConfigAndInfoUseCase;

@end

@implementation SplashViewController
HimalayaAuthManager *authManager;

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    HimalayaAuthManager *authManager = [HimalayaAuthManager sharedManager];
    [authManager loadState];
    if ([authManager isAuthorized]){
        [self fetchUserData];
    }else{
        [self hideProgress];
        [self navigateToHome];
    }
}

- (void)navigateToHome{
    [[[HPNavigationRouter alloc] init] updateTheWindowRootAsTabBarWithAnimation];
}

- (UserConfigResponse *)userConfig{
    NSError *error;
    return [HimalayaAuthKeychainManager loadUserConfigToKeychain:&error];
}

- (void)fetchUserData{
    
    
    
    _fetchUserConfigAndInfoUseCase = [[FetchUserConfigAndInfoUseCase alloc] init];

    WS(weakSelf)
    [_fetchUserConfigAndInfoUseCase executeWithRequest:NULL completionHandler:^(id  _Nullable response, NSInteger errorCode, NSString * _Nullable errorMessage) {

        switch (errorCode) {
            case kFPNetRequestSuccessCode:

                if( ([self userConfig].termsRequireAccepting.boolValue) || ([self userConfig].privacyRequireAccepting.boolValue) ){
                    [weakSelf showUserConsentViewWithDelegate:weakSelf];
                    [weakSelf hideProgress];
                    break;
                }
                else{
                    [self navigateToHome];
                    [weakSelf hideProgress];
                    break;
                }
                
               
            case kErrorCodeUserNotAuthorized:
                return;
            default:
                [weakSelf handleResponseWithErrorCode:errorCode errorMessage:errorMessage];
                break;
        }
    }];
}

- (void)handleResponseWithErrorCode:(NSInteger)errorCode errorMessage:(NSString *)errorMessage{
    WS(weakSelf)
    AlertActionItem *retryItem = [AlertActionItem defaultRetryItemWithHandler:^{
        [weakSelf fetchUserData];
    }];
    
    ApiError* error = [ApiError errorWithCode:errorCode message:errorMessage];
    
    [self showAlertWithTitle:error.prettyTitle
                     message:error.prettyMessage
                     actions:[NSArray arrayWithObject:retryItem]];
}

- (void)hideProgress{
    [self.activityIndicator stopAnimating];
}

- (void)conditionsAccepted{
    [self navigateToHome];
}

@end
