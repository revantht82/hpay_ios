#import "FPSecurityAuthManager.h"

#import "AES128.h"
#import "ProfileHelperModel.h"
#import "FPKeyBoardManager.h"
#import "HelpFeedbackViewController.h"
#import "AppDelegate.h"
#import "UIViewController+CurrentViewController.h"

@interface FPSecurityAuthManager ()
@property(nonatomic, assign) FPSecurityAutType authType;
@property(nonatomic, copy) NSString *urlString;
@property(nonatomic, copy) NSString *result;
@end

@implementation FPSecurityAuthManager

- (instancetype)initWithAuthType:(FPSecurityAutType)type {
    self = [self init];
    if (self) {
        _authType = type;
    }
    return self;
}

- (void)securityAuth {
    if (self.isOnlyVerifyPin) {
        FPKeyBoardManager *manager = [self showPINPayKeyboardWithSuccessBlock:^(NSString *pin) {
            if (self.securityAuthSuccessBlock) {
                self.securityAuthSuccessBlock(pin);
            }
        }];
        manager.title = NSLocalizedProfile(@"security_verification");
        manager.subTitle = NSLocalizedProfile(@"please_enter_pin_to_verify_identity");
        return;
    }
    
    [self showPINPayKeyboardWithSuccessBlock:^(NSString *pin) {
        if (self.securityAuthSuccessBlock) {
            self.securityAuthSuccessBlock(pin);
        }
    }];
}

- (NSString *)verifyPinURL {
    NSString *urlString = nil;
    switch (self.authType) {
        case FPSecurityAutTypeWithdrawal:
            urlString = WithdrawVerifyWithdrawPINURL;
            break;
        case FPSecurityAutTypeUpdateLoginPasword:
            urlString = SecurityVerifyUpdatePasswordPinURL;
            break;
        default:
            break;
    }
    return urlString;
}

- (FPKeyBoardManager *)showPINPayKeyboardWithSuccessBlock:(void (^)(NSString *pin))successBlock {
    FPKeyBoardManager *manager = [FPKeyBoardManager new];
    [manager setKeyBoardCallBack:^(NSString *pwd, FPKeyBoardManager *keyBoard) {
        NSString *pin = [AES128 encryptAES128:pwd];
        NSString *urlString = [self verifyPinURL];
        [MBHUD showInView:[AppDelegate keyWindow] withDetailTitle:nil withType:HUDTypeLoading];
        [ProfileHelperModel verifyPin:pin urlString:urlString completeBlock:^(BOOL result, NSInteger errorCode, NSString *errorMessage) {
            [MBHUD hideInView:[AppDelegate keyWindow]];
            if (result) {
                successBlock(pin);
                [keyBoard hideKeyBoard];
            } else {
                [keyBoard clear];
                if (errorCode == 10013) {
                    //PIN码已被锁定，1小时后自动解锁。\n如忘记PIN码，请联系客服申诉
                    [[NSNotificationCenter defaultCenter] postNotificationName:kPinInputErrorFiveTimesNotification object:nil];
                    [keyBoard hideKeyBoard];
                    AlertActionItem *cancelItem = [AlertActionItem defaultCancelItem];
                    AlertActionItem *okItem = [AlertActionItem actionWithTitle:NSLocalizedProfile(@"contact") style:(AlertActionStyleDefault) handler:^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:kFPContactCSNotification object:nil];
                        HelpFeedbackViewController *vc = [SB_PROFILE instantiateViewControllerWithIdentifier:@"HelpFeedbackViewController"];
                        vc.navigationItem.title = NSLocalizedProfile(@"help_and_feedback");
                        UITabBarController *rootVC = (UITabBarController *) [UIApplication sharedApplication].delegate.window.rootViewController;
                        UINavigationController *nav = (UINavigationController *) rootVC.selectedViewController;
                        [nav pushViewController:vc animated:YES];
                    }];
                    [[UIViewController getCurrentViewController] showAlertWithTitle:@""
                                                                            message:errorMessage
                                                                            actions:[NSArray arrayWithObjects:cancelItem, okItem, nil]];
                } else {
                    [MBHUD showInView:[AppDelegate keyWindow] withDetailTitle:errorMessage withType:HUDTypeError];
                }
            }
        }];

    }];
    [manager setKeyBoardCloseCallBack:^{
        if (self.securityAuthCloseBlock) {
            self.securityAuthCloseBlock();
        }
    }];
    [manager showKeyBoard];
    return manager;
}

@end
