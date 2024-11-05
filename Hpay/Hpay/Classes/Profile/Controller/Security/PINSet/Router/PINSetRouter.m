//
//  PINSetRouter.m
//  Hpay
//
//  Created by Olgu Sirman on 21/01/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "PINSetRouter.h"
#import "PINSetViewController.h"
#import "HelpFeedbackViewController.h"
#import "SafeAuthViewController.h"

@implementation PINSetRouter

- (nonnull PINSetViewController *)pinSetViewController {
    PINSetViewController *vc = [SB_PROFILE instantiateViewControllerWithIdentifier:[PINSetViewController className]];
    return vc;
}

- (nonnull HelpFeedbackViewController *)helpFeedbackViewController {
    HelpFeedbackViewController *vc = [SB_PROFILE instantiateViewControllerWithIdentifier:[HelpFeedbackViewController className]];
    return vc;
}

- (void)pushToPinSetVerifyNewPinWithOldPin:(nonnull NSString *)oldPassword {
    PINSetViewController *vc = self.pinSetViewController;
    vc.PINSetType = PINSetTypeVerifySetNewPIN;
    vc.oldPin = oldPassword;
    [self pushTo:vc];
}

- (void)pushToHelpFeedback {
    HelpFeedbackViewController *vc = self.helpFeedbackViewController;
    vc.navigationItem.title = NSLocalizedProfile(@"help_and_feedback");
    [self pushTo:vc];
}

- (void)pushToPinSetVerifyCheckReSetNewPINWith:(nonnull NSString *)password forVerificationtype:(BOOL)isMustVerifyReset {
    PINSetViewController *vc = self.pinSetViewController;
    vc.PINSetType = isMustVerifyReset ? PINSetTypeMustVerifyCheckReSetNewPIN :  PINSetTypeVerifyCheckReSetNewPIN;
    vc.pinCode = password;
    [self pushTo:vc];
}

- (void)pushToPinSetWithVerifyFirstCheckSetNewPIN:(nonnull NSString *)password {
    PINSetViewController *vc = self.pinSetViewController;
    vc.PINSetType = PINSetTypeVerifyFirstCheckSetNewPIN;
    vc.pinCode = password;
    [self pushTo:vc];
}

- (void)pushToPinSetWith:(NSString *_Nullable)pinCode
             withPinText:(NSString *_Nullable)pinText
              withOldPin:(NSString *_Nullable)oldPin
                 smsCode:(NSString *_Nullable)smsCode {
    
    PINSetViewController *vc = self.pinSetViewController;
    vc.PINSetType = PINSetTypeVerifyCheckSetNewPIN;
    vc.pinCode = pinCode;
    vc.pinText = pinText;
    vc.oldPin = oldPin;
    vc.smsCode = smsCode;
    [self pushTo:vc];
}

- (void)clearThePinAndPop {
    // FIXME: Code smell, check it later, Find that controller with filter method and navigate if there is
    PINSetViewController *vc = self.navigationDelegate.viewControllers[self.navigationDelegate.viewControllers.count - 2];
    [vc clearPIN];
    [self pop];
}

- (SafeAuthViewController *_Nonnull)presentToSafeAuthWithAllWithDismissEvent:(void (^_Nullable)(void))dismissEvent {
    
    SafeAuthViewController *safeAuthVC = [[SafeAuthViewController alloc] initWithNibName:[SafeAuthViewController className] bundle:[NSBundle mainBundle]];
    [safeAuthVC configWithAuthType:SafeAuthTypeResetPIN];
    FPNavigationController *nav = [[FPNavigationController alloc] initWithRootViewController:safeAuthVC];
    safeAuthVC.view.backgroundColor = [UIColor clearColor];
    nav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    nav.view.backgroundColor = [UIColor clearColor];
    [safeAuthVC setDissMissEvent:^{
        if (dismissEvent) {
            dismissEvent();
        }
    }];
    [safeAuthVC performSelector:@selector(startAnimationEvent) withObject:nil afterDelay:0.35];
    [self present:nav];
    
    return safeAuthVC;
}

- (void)pushToVerifyReSetNewPIN {
    PINSetViewController *vc = self.pinSetViewController;
    vc.PINSetType = PINSetTypeVerifyReSetNewPIN;
    [self pushTo:vc];
}

@end
