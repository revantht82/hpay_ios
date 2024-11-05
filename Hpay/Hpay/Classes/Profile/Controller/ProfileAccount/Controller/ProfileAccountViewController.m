//
//  ProfileAccountViewController.m
//  Hpay
//
//  Created by Olgu Sirman on 27/04/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "ProfileAccountViewController.h"
#import "ProfileHelperModel.h"
#import "SecurityRouter.h"
#import "LoginHelperModel.h"
#import "HimalayaAuthManager.h"
#import "UserConfigResponse.h"
#import "HimalayaAuthKeychainManager.h"
#import "NSObject+Extension.h"
#import "HimalayaAuthManager.h"
#import "ApiError.h"
#import "UIViewController+Alert.h"
#import "HimalayaPayAPIManager.h"
#import "NicknameViewController.h"
#import "HPAYBioAuth.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface ProfileAccountViewController () <HimalayaAuthManagerStateDelegate>

@property(strong, nonatomic) SecurityRouter<SecurityRouterInterface> *router;
@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *itemBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *closeAccountBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *closeTitleLabel;

@property (weak, nonatomic) IBOutlet UIView *bioBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *bioTitleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *bioSwitch;

@property (weak, nonatomic) IBOutlet UIButton *closeAccountButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIView *nicknameBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameTitleLable;

@end

@implementation ProfileAccountViewController

static NSString *cellIdentifier = @"cellIdentifier";

- (SecurityRouter<SecurityRouterInterface> *)router {
    if (_router == nil) {
        _router = [[SecurityRouter alloc] init];
        _router.currentControllerDelegate = self;
        _router.navigationDelegate = self.navigationController;
        _router.tabBarControllerDelegate = self.tabBarController;
    }
    return _router;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self applyTheme];
}

-(void)viewWillAppear:(BOOL)animated{
    [[HPAYBioAuth sharedInstance] checkIsBioAvailable];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    if ([[HPAYBioAuth sharedInstance] getIsBioAuthAvailable]){
        [self.bioSwitch setOn:[[[HPAYBioAuth sharedInstance] getBioAuthOn] boolValue]];
    } else {
        [self.bioSwitch setOn:NO];
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self applyTheme];
}

- (void)applyTheme{
    id<ThemeProtocol> theme = [self getCurrentTheme];
    
    self.view.backgroundColor = theme.background;
    self.headerTitleLabel.textColor = theme.primaryOnBackground;
    self.itemTitleLabel.textColor = theme.primaryOnSurface;
    self.itemBackgroundView.backgroundColor = theme.surface;
    self.closeTitleLabel.textColor = theme.primaryOnSurface;
    self.closeAccountBackgroundView.backgroundColor = theme.surface;
    
    self.bioBackgroundView.backgroundColor = theme.surface;
    self.bioTitleLabel.textColor = theme.primaryOnSurface;
    
    self.logoutButton.backgroundColor = theme.primaryButton;
    self.nicknameTitleLable.textColor = theme.primaryOnSurface;
    self.nicknameBackgroundView.backgroundColor = theme.surface;
    
    self.closeAccountButton.titleLabel.textColor = UIColor.redColor;
    [self.closeAccountButton setTitleColor: theme.primaryOnSurface
                                  forState: UIControlStateNormal];
}

- (IBAction)resetPinTapped:(id)sender {
    if ([self isKycVerified]){
        [self navigateToResetPin];
    }
}
- (IBAction)nicknamePressed:(id)sender {
    NicknameViewController *vc = [SB_NICKNAME instantiateViewControllerWithIdentifier:[NicknameViewController className]];
    [self.router pushTo:vc];
}

- (IBAction)bioSwitchTrigger:(id)sender {
    
    NSDictionary *bioData = [[HPAYBioAuth sharedInstance] getBioAuthData];
    
    if (_bioSwitch.isOn){
        
        if ([[HPAYBioAuth sharedInstance] getIsBioAuthAvailable]){
            if (![[HPAYBioAuth sharedInstance] checkForSystemAlert]) {
                [[HPAYBioAuth sharedInstance] getPIN];
                [[HPAYBioAuth sharedInstance] checkIsBioAvailable];
                if ([[HPAYBioAuth sharedInstance] getIsBioAuthAvailable]){
                    [[HPAYBioAuth sharedInstance] saveIsNeedToSavePIN:YES];
                    [self showVerifyPinVC];
                }
            } else {
                [[HPAYBioAuth sharedInstance] saveIsNeedToSavePIN:YES];
                [self showVerifyPinVC];
            }
        }else if ([bioData[@"errorCode"] intValue] == -6 && [bioData[@"biometryType"] intValue] == LABiometryTypeFaceID) {
            UIAlertController *alertController = [UIAlertController
              alertControllerWithTitle:NSLocalizedString(@"biometric.turnedoff.alert.title", @"")
              message:NSLocalizedString(@"biometric.turnedoff.alert.desc", @"")
              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"biometric.turnedoff.alert.cancel", @"") style:UIAlertActionStyleDefault handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedDefault(@"biometric.turnedoff.alert.okay") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
            }];
          
            [alertController addAction:dismissAction];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
            [_bioSwitch setOn:NO animated:YES];
            
        } else if ([bioData[@"errorCode"] intValue] == LAErrorBiometryNotEnrolled) {
            UIAlertController *alertController = [UIAlertController
              alertControllerWithTitle:NSLocalizedString(@"biometric.notenrolled.title", @"")
              message:NSLocalizedString(@"biometric.notenrolled.error", @"")
              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"biometric.turnedoff.alert.cancel", @"") style:UIAlertActionStyleDefault handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedDefault(@"biometric.notenrolled.alert.configure") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
                NSLog(@"%@", UIApplicationOpenSettingsURLString);
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
            }];
          
            [alertController addAction:dismissAction];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
            [_bioSwitch setOn:NO animated:YES];
        }
        else {
            UIAlertController *alertController = [UIAlertController
              alertControllerWithTitle:NSLocalizedString(@"biometric.unavailable.alert.title", @"")
              message:bioData[@"error"]
              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"biometric.turnedoff.alert.cancel", @"") style:UIAlertActionStyleDefault handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedDefault(@"biometric.turnedoff.alert.okay") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
                NSLog(@"%@", UIApplicationOpenSettingsURLString);
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
            }];
          
            [alertController addAction:dismissAction];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
            [_bioSwitch setOn:NO animated:YES];
        }
        
    } else {
        [[HPAYBioAuth sharedInstance] saveIsBioAuthOn:[NSNumber numberWithBool:NO]];
        [[HPAYBioAuth sharedInstance] deletePIN];
    }
}

-(IBAction)closeAccount:(id)sender {
    NSString *url = @"";
    if ([[FPLanguageTool sharedInstance].language isEqualToString:@"en"]) {
        url = @"https://himalaya-exchange.zendesk.com/hc/en-gb/requests/new";
    } else {
        url = @"https://himalaya-exchange.zendesk.com/hc/zh-cn/requests/new";
    }
    
    if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options: @{} completionHandler: nil];
}

- (UserConfigResponse *)userConfig{
    NSError *error;
    return [HimalayaAuthKeychainManager loadUserConfigToKeychain:&error];
}

- (BOOL)isKycVerified{
    if (![self userConfig].isKYCVerified.boolValue) {
        [self showKycAlert];
        return NO;
    }else{
        return YES;
    }
}

- (void)navigateToResetPin {
    [self.router presentToPinSetForVerify:NO];
}

- (IBAction)logoutAction:(UIButton *)sender {
    AlertActionItem *cancelItem = [AlertActionItem defaultCancelItem];
    
    AlertActionItem *confirmItem = [AlertActionItem actionWithTitle:NSLocalizedProfile(@"confirm") style:(AlertActionStyleDefault) handler:^{
        NSString *FCM_KEY = @"The_Fcm_Key";
        NSString *FCM_UPDATE_NEED_ONAPI = @"Fcm_Update_Needed";
        NSMutableDictionary *param = @{}.mutableCopy;
        param[@"registrationToken"] = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:FCM_KEY]];
        [HimalayaPayAPIManager POST:PushNotificationsRegistrationDisableURL parameters:param successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
            NSLog(@"\\HPAY api notification disable success");
            [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:FCM_UPDATE_NEED_ONAPI];
        } failureBlock:^(NSInteger code, NSString *_Nullable message) {
            NSLog(@"\\HPAY api notification disable error");
        }];
        [HimalayaAuthManager sharedManager].stateDelegate = self;
        [[HimalayaAuthManager sharedManager] endSessionWithPresenter:self handler:^(OIDEndSessionResponse * _Nullable endSessionResponse, NSError * _Nullable endSessionError) {

            if (endSessionError) {
                NSString *genericErrorDescription = NSLocalizedString(@"unexpected_error", @"Show generic error happened on logOut process");
                [MBHUD showInView:self.view withDetailTitle:genericErrorDescription withType:HUDTypeError];
                return;
            }
            
            [self handleSuccessLogOut];
            
        }];
    }];
    
    [self showAlertWithTitle:@""
                     message:NSLocalizedProfile(@"log_out_title")
                     actions:[NSArray arrayWithObjects:cancelItem, confirmItem, nil]];
}

- (void)handleSuccessLogOut {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[GCUserManager manager] logOut];
        [[NSNotificationCenter defaultCenter] postNotificationName:kLogOutNotification object:nil];
        [self.router updateTheWindowRootAsTabBarWithAnimation];
    });
}

#pragma mark HimalayaAuthManagerStateDelegate

- (void)didLoginSucceed{
    
}

- (void)didLoginFailedWithErrorCode:(NSInteger)errorCode{
    AlertActionItem *dismissItem = [AlertActionItem defaultDismissItem];
    
    ApiError* error = [ApiError errorWithCode:errorCode message:NULL];
    
    [self showAlertWithTitle:error.prettyTitle
                     message:error.prettyMessage
                     actions:[NSArray arrayWithObject:dismissItem]];
}

@end
