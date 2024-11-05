//
//  GLCNetworkRequest.m
//  GrandeurLifestyleClub
//
//  Created by apple on 2017/6/23.
//  Copyright © 2017年 fiiipay. All rights reserved.
//

#import "AFHTTPSessionManagerSingleInstance.h"
#import "FPTabBarController.h"
#import "HomeViewController.h"
#import "HelpFeedbackViewController.h"
#import "AppDelegate.h"
#import "NSObject+Extension.h"
#import "UIViewController+CurrentViewController.h"
#import "NSString+Extension.h"
#import "HimalayaAuthManager.h"
#import "HimalayaPayAPIManager.h"

@implementation GLCNetworkRequest

+ (void)login {
    FPTabBarController *tabbarVC = [FPTabBarController new];
    UIWindow *window = [AppDelegate keyWindow];
    [UIView transitionWithView:window duration:0.5f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        [window setRootViewController:tabbarVC];
        [UIView setAnimationsEnabled:oldState];
    }               completion:^(BOOL finished) {
        UINavigationController *navVC = (UINavigationController *) tabbarVC.selectedViewController;
        HomeViewController *homeVC = navVC.viewControllers.firstObject;
        if ([homeVC isKindOfClass:[HomeViewController class]]) {
            [homeVC loginAction];
        }
    }];
}

+ (void)resetPassword {
    FPTabBarController *tabbarVC = [FPTabBarController new];
    UIWindow *window = [AppDelegate keyWindow];
    [UIView transitionWithView:window duration:0.5f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        [window setRootViewController:tabbarVC];
        [UIView setAnimationsEnabled:oldState];
    }               completion:^(BOOL finished) {
        UINavigationController *navVC = (UINavigationController *) tabbarVC.selectedViewController;
        HomeViewController *homeVC = navVC.viewControllers.firstObject;
        if ([homeVC isKindOfClass:[HomeViewController class]]) {
            [homeVC resetPassword];
        }
    }];
}

+ (void)handleAuthError{
    BOOL isShowing = [NSUserDefaults.standardUserDefaults boolForKey:kSessionExpiryShowingKey];
    if (isShowing){
        return;
    }
    [NSUserDefaults.standardUserDefaults setBool:YES forKey:kSessionExpiryShowingKey];
    
    [[GCUserManager manager] logOut];
    [[HimalayaAuthManager sharedManager] clearAuthState];
    
    AlertActionItem *okItem = [AlertActionItem actionWithTitle:NSLocalizedCommon(@"login_again") style:(AlertActionStyleCancel) handler:^{
        [NSUserDefaults.standardUserDefaults setBool:NO forKey:kSessionExpiryShowingKey];
        [self login];
    }];
    [[UIViewController getCurrentViewController] showAlertWithTitle:@""
                                                            message:NSLocalizedString(@"login_has_expired_please_login_again", @"")
                                                            actions:[NSArray arrayWithObject:okItem]];
}

@end
