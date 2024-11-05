#import "HPProfileBaseRouter.h"
#import "SafeAuthViewController.h"
#import "FetchPhoneCodeViewController.h"

typedef enum : NSUInteger {
    ProfilePhoneVerificationTypeUpdateCellPhone,//修改手机
    ProfilePhoneVerificationTypeBindCellPhone,//绑定手机
} ProfilePhoneVerificationType;

@implementation HPProfileBaseRouter

- (FetchPhoneCodeViewController *)fetchPhoneCodeViewController {
    FetchPhoneCodeViewController *vc = [SB_HOME instantiateViewControllerWithIdentifier:[FetchPhoneCodeViewController className]];
    return vc;
}

- (nonnull SafeAuthViewController *)presentToSafeAuthWithIsFirstSet:(BOOL)isFirstSet {
    
    SafeAuthType type = isFirstSet ? SafeAuthTypeBindEmail : SafeAuthTypeUpdateEmail;
    SafeAuthViewController *safeAuthVC = [[SafeAuthViewController alloc] initWithNibName:@"SafeAuthViewController" bundle:[NSBundle mainBundle]];
    [safeAuthVC configWithAuthType:type];
    FPNavigationController *nav = [[FPNavigationController alloc] initWithRootViewController:safeAuthVC];
    safeAuthVC.view.backgroundColor = [UIColor clearColor];
    nav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    nav.view.backgroundColor = [UIColor clearColor];
    [safeAuthVC performSelector:@selector(startAnimationEvent) withObject:nil afterDelay:0.35];
    [self.tabBarControllerDelegate presentViewController:nav animated:YES completion:nil];
    
    return safeAuthVC;
}

- (nonnull SafeAuthViewController *)presentToSafeAuthWithType:(SafeAuthType)safeAuthType {

    SafeAuthType type = (safeAuthType == ProfilePhoneVerificationTypeUpdateCellPhone) ? SafeAuthTypeUpdatePhone : SafeAuthTypeBindPhone;
    SafeAuthViewController *safeAuthVC = [[SafeAuthViewController alloc] initWithNibName:@"SafeAuthViewController" bundle:[NSBundle mainBundle]];
    [safeAuthVC configWithAuthType:type];
    FPNavigationController *nav = [[FPNavigationController alloc] initWithRootViewController:safeAuthVC];
    safeAuthVC.view.backgroundColor = [UIColor clearColor];
    nav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    nav.view.backgroundColor = [UIColor clearColor];
    [safeAuthVC performSelector:@selector(startAnimationEvent) withObject:nil afterDelay:0.35];
    [self.tabBarControllerDelegate presentViewController:nav animated:YES completion:nil];
    
    return safeAuthVC;
}

- (nonnull SafeAuthViewController *)presentSafeAuthWithPhoneType {
    
    SafeAuthViewController *safeAuthVC = [[SafeAuthViewController alloc] initWithNibName:[SafeAuthViewController className] bundle:[NSBundle mainBundle]];
    [safeAuthVC configWithAuthType:SafeAuthTypePhone];
    FPNavigationController *nav = [[FPNavigationController alloc] initWithRootViewController:safeAuthVC];
    safeAuthVC.view.backgroundColor = [UIColor clearColor];
    nav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    nav.view.backgroundColor = [UIColor clearColor];
    [safeAuthVC performSelector:@selector(startAnimationEvent) withObject:nil afterDelay:0.35];
    return safeAuthVC;
}

@end
