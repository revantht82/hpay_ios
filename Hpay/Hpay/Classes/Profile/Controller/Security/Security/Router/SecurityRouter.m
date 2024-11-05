#import "SecurityRouter.h"
#import "PINSetViewController.h"
#import "FPSecurityAuthManager.h"

@implementation SecurityRouter

- (nonnull PINSetViewController *)pinSetViewController {
    PINSetViewController *vc = [SB_PROFILE instantiateViewControllerWithIdentifier:[PINSetViewController className]];
    return vc;
}

- (nonnull FPSecurityAuthManager *)fpSecurityAuthManager {
    FPSecurityAuthManager *vc = [[FPSecurityAuthManager alloc] initWithAuthType:FPSecurityAutTypeDefault];
    return vc;
}

- (void)presentToPinSetForVerify:(BOOL)isMustReset {
    PINSetViewController *vc = self.pinSetViewController;
    vc.PINSetType = isMustReset ? PINResetTypeMustVerifyPIN : PINResetTypeVerifyPIN;
    FPNavigationController *nav = [[FPNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self present:nav];
}

- (void)presentToPinSetForReSetNewPIN {
    PINSetViewController *vc = self.pinSetViewController;
    vc.PINSetType = PINSetTypeVerifyReSetNewPIN;
    FPNavigationController *nav = [[FPNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self present:nav];
}

- (void)presentSecurityAuthWithSuccessHandler:(void(^_Nullable)(NSString * _Nullable securityPassword))setSecurityAuthSuccessBlock {
    FPSecurityAuthManager *manager = self.fpSecurityAuthManager;
    manager.isOnlyVerifyPin = YES;
    [manager setSecurityAuthSuccessBlock:setSecurityAuthSuccessBlock];
    [manager securityAuth];
}

@end
