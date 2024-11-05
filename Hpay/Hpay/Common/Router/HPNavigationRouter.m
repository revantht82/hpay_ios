#import "HPNavigationRouter.h"
#import "FPNavigationController.h"
#import "FPTabBarController.h"
#import "AppDelegate.h"
#import "HimalayaAuthManager.h"
#import "PayMerchantViewController.h"
#import "PayMerchantStatusViewController.h"
#import "StatementDetailViewController.h"
#import "SplashViewController.h"
#import "FPKeyBoardManager.h"
#import "UIViewController+CurrentViewController.h"
#import "FPUtils.h"
#import "ChooseCoinViewController.h"

@interface HPNavigationRouter ()

@end

@implementation HPNavigationRouter

/// TODO: Carry this category usage here later, look at UIViewController+CurrentViewController.h
+ (UIViewController *)getCurrentViewController {
    UIWindow * window = [AppDelegate keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [(UITabBarController *)result selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    return result;
}

- (UITabBarController *)tabBarController {
    
    if (self.tabBarControllerDelegate) {
        return self.tabBarControllerDelegate;
    } else if (self.currentControllerDelegate.tabBarController) {
        if ([self.currentControllerDelegate.tabBarController isKindOfClass:[UITabBarController class]]) {
            return self.currentControllerDelegate.tabBarController;
        }
    }
    
    UITabBarController *tabbarVC = (UITabBarController *)[AppDelegate keyWindow].rootViewController;
    if ([tabbarVC isKindOfClass:[UITabBarController class]]) {
        return tabbarVC;
    }
    
    return nil;
}

- (UINavigationController *)currentNavigationController {
    
    if (self.navigationDelegate) {
        return self.navigationDelegate;
    } else if (self.currentControllerDelegate) {
        return self.currentControllerDelegate.navigationController;
    }
    return nil;
}

#pragma mark - PUSH

- (void)pushTo:(UIViewController *_Nonnull)viewController animated:(BOOL)animated {
    [self.currentNavigationController pushViewController:viewController animated:animated];
}

- (void)pushTo:(UIViewController *_Nonnull)viewController {
    [self pushTo:viewController animated:YES];
}

#pragma mark - PRESENT

- (void)present:(UIViewController *_Nonnull)viewController animated:(BOOL)animated completion:(void (^_Nullable)(void))completion {

    [self.currentControllerDelegate presentViewController:viewController animated:animated completion:completion];
}

- (void)present:(UIViewController *_Nonnull)viewController animated:(BOOL)animated {
    [self present:viewController animated:animated completion:nil];
}

- (void)present:(UIViewController *_Nonnull)viewController {
    [self present:viewController animated:YES];
}

#pragma mark - POP

- (void)pop:(BOOL)animated {
    [self.currentNavigationController popViewControllerAnimated:animated];
}

- (void)pop {
    [self pop:YES];
}

- (void)popToRoot:(BOOL)animated {
    [self.currentNavigationController popToRootViewControllerAnimated:animated];
}

- (void)popToRoot {
    [self popToRoot:YES];
}

#pragma mark - Dismiss

- (void)dismiss {
    [self.currentControllerDelegate dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismissOrClose {
    if (self.currentControllerDelegate.presentingViewController) {
        [self dismiss];
    } else {
        [self pop];
    }
}

#pragma mark - Alert

- (void)showAlertWithTitle:(NSString *_Nullable)title
                   message:(NSString *_Nonnull)message
               cancelActionTitle:(NSString *_Nonnull)cancelActionTitle
             actionHandler:(void (^_Nullable)(UIAlertAction *_Nonnull))actionHandler {

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelActionTitle style:UIAlertActionStyleCancel handler:actionHandler];
    [alertVC addAction:cancelAction];
    alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.currentControllerDelegate presentViewController:alertVC animated:YES completion:nil];
}

/// Default alert with only contains one action and cancel
- (void)showAlertWithMessage:(NSString *_Nonnull)message
               actionHandler:(void (^_Nullable)(UIAlertAction *_Nonnull))actionHandler {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedDefault(@"confirm") style:UIAlertActionStyleCancel handler:actionHandler];
    [alertVC addAction:cancelAction];
    alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.currentControllerDelegate presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - Root
- (void)showSplashViewControllerAsRoot{
    SplashViewController *vc = [SplashViewController new];
    UIWindow *window = [AppDelegate keyWindow];
    [UIView transitionWithView:window duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        [window setRootViewController:vc];
        [UIView setAnimationsEnabled:oldState];
    }               completion:^(BOOL finished) {
    }];
}

- (void)updateTheWindowRootAsTabBarWithAnimation {
    FPTabBarController *tabbarVC = [FPTabBarController new];
    UIWindow *window = [AppDelegate keyWindow];
    
    [UIView transitionWithView:window duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        [window setRootViewController:tabbarVC];
        [UIView setAnimationsEnabled:oldState];
    }               completion:^(BOOL finished) {
    }];
}

#pragma mark - Deeplink

-(void)presentPayMerchantWithOrderId:(NSString * _Nonnull)orderId {
    PayMerchantViewController * merchantViewController = [SB_DEEPLINK instantiateViewControllerWithIdentifier:[PayMerchantViewController className]];
    merchantViewController.orderId = orderId;
    FPNavigationController *navigationController = [[FPNavigationController alloc] initWithRootViewController:merchantViewController];
    navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    UIViewController* vc = [UIViewController getCurrentViewController];
    if ([vc isKindOfClass:[PayMerchantViewController class]] || [vc isKindOfClass:[PayMerchantStatusViewController class]]){
        [vc dismissViewControllerAnimated:NO completion:NULL];
        [FPKeyBoardManager hideKeyBoard];
        [self.currentControllerDelegate presentViewController:navigationController animated:YES completion:nil];
    }else{
        [[UIViewController getCurrentViewController] presentViewController:navigationController animated:YES completion:nil];
    }
}

-(void)presentPaymentRequestWithOrderId:(NSString * _Nonnull)orderId {
    StatementDetailViewController *statementDetailViewController = [SB_STATEMENT instantiateViewControllerWithIdentifier:[StatementDetailViewController className]];
    StatementListType cType = StatementListInvalid;
    struct MStatement mStatement = [FPUtils fetchDetailMStatementByListType:cType];
    NSString *url = RequestFundRetriveURL;
    NSString *title = [FPUtils convertByChar:mStatement.title];
    statementDetailViewController.title = title;
    [statementDetailViewController configForFundRequestWithType:cType andId:orderId andUrl:url andSeuge:nil];
    UIViewController* vc = [UIViewController getCurrentViewController];
    
    [vc.navigationController pushViewController:statementDetailViewController animated:true];

}

-(void)presentPaymentRequestWithUserHash:(NSString * _Nonnull)userHash {
    ChooseCoinViewController *chooseCoinVC = [SB_WALLET instantiateViewControllerWithIdentifier:[ChooseCoinViewController className]];
    [chooseCoinVC configCoinActionType:CoinActionTypeTransferScan];
    chooseCoinVC.userHash = userHash;
    UIViewController* vc = [UIViewController getCurrentViewController];
    
    [vc.navigationController pushViewController:chooseCoinVC animated:true];

}

@end
