//
//  VerifyPinViewController.m
//  Hpay
//
//  Created by Ugur Bozkurt on 29/09/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "VerifyPinViewController.h"
#import "SafeAuthViewController.h"
#import "HCAmountTextField.h"
#import "FPPasswordDotCell.h"
#import "VerifyPinUseCase.h"
#import "UIViewController+Alert.h"
#import "NSObject+Extension.h"
#import "SecurityRouter.h"
#import "HimalayaPayAPIManager.h"
#import "StatementViewController.h"
#import "HimalayaAuthKeychainManager.h"
#import "HPAYBioAuth.h"

@interface VerifyPinViewController () <UICollectionViewDelegate, UICollectionViewDataSource, SafeAuthDelegate>

@property(weak, nonatomic) IBOutlet UILabel *hintLabel;
@property(weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(weak, nonatomic) IBOutlet HCAmountTextField *textField;
@property(strong, nonatomic) VerifyPinUseCase *verifyPinUseCase;
@property (weak, nonatomic) IBOutlet UIButton *bioButton;

@end

@implementation VerifyPinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self checkServerNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
    [self setIsShowingVerifyPinViewController:YES];
    
    //Skip PIN screen ONLY FOR DEGUB!!!
    #if TARGET_IPHONE_SIMULATOR
    HCIdentityUser *userConfig = [GCUserManager manager].user;
    NSLog(@"userConfig.sub = %@", userConfig.sub);
    //if (userConfig.sub != nil && [userConfig.sub isEqualToString:@"19272027-898b-46a3-a18d-d4c4c865280d"]) {
        [self executeVerifyPinWithInputText:@"235689"];
    //}
    #endif
    
    if ([[[HPAYBioAuth sharedInstance] getBioAuthOn] boolValue]){
        self.bioButton.hidden = NO;
    } else {
        self.bioButton.hidden = YES;
    }
    
    
}

-(void) viewDidAppear:(BOOL)animated{
    if ([[[HPAYBioAuth sharedInstance] getBioAuthOn] boolValue]){
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"HPAYBioAuth_getPIN"];
        //NSLog(@"HPAYBioAuth_getPIN = %d", [[NSUserDefaults standardUserDefaults] boolForKey:@"HPAYBioAuth_getPIN"]);
        NSString *pin = [[HPAYBioAuth sharedInstance] getPIN];
        if (pin && ![pin isEqualToString:@""]) {
            [self executeVerifyPinWithInputText:pin];
        } else {
            [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"HPAYBioAuth_getPIN"];
            //NSLog(@"HPAYBioAuth_getPIN = %d", [[NSUserDefaults standardUserDefaults] boolForKey:@"HPAYBioAuth_getPIN"]);
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [self updateNotificationKeyIfNecessary];
    [super viewWillDisappear:animated];
    [self setIsShowingVerifyPinViewController:NO];
    NSString *LOADED_FROM_NOTIFICATION = @"loaded_fromnotification";
    if([[[NSUserDefaults standardUserDefaults] valueForKey:LOADED_FROM_NOTIFICATION] isEqualToString:@"YES"]){
        StatementViewController *statementVC = (StatementViewController *) [SB_STATEMENT instantiateViewControllerWithIdentifier:@"StatementViewController"];
        statementVC.title = NSLocalizedDefault(@"transactionHistoryTitle");
        FPNavigationController *navStatement = [[FPNavigationController alloc] initWithRootViewController:statementVC];
        [super presentViewController:navStatement animated:YES completion:nil];
    }
}

- (IBAction)useBiometricPressed:(id)sender {
    NSString *pin = [[HPAYBioAuth sharedInstance] getPIN];
    if (pin && ![pin isEqualToString:@""]) {
        [self executeVerifyPinWithInputText:pin];
    }
}

-(void)updateNotificationKeyIfNecessary {
    NSString *FCM_KEY = @"The_Fcm_Key";
    NSString *FCM_UPDATE_NEED_ONAPI = @"Fcm_Update_Needed";

    if ([NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:FCM_UPDATE_NEED_ONAPI]] == [NSString stringWithFormat:@"YES"]) {
        NSMutableDictionary *param = @{}.mutableCopy;
        NSString *PLATFORM = @"IOS";
        param[@"registrationToken"] = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:FCM_KEY]];
        param[@"platform"] = [NSString stringWithFormat:@"%@", PLATFORM];
        [HimalayaPayAPIManager POST:PushNotificationsRegistrationURL parameters:param successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
            NSLog(@"\\Success on registration to Api");
            [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:FCM_UPDATE_NEED_ONAPI];
        } failureBlock:^(NSInteger code, NSString *_Nullable message) {
            NSLog(@"\\Failure on registration to Notifications API. With message");
        }];
    }
    else{
        NSLog(@"\\FCM up to date no need to update on HPAY Api");
    }
}

- (void)setupUI{
    [self.textField resignFirstResponder];
    self.hintLabel.text = NSLocalizedProfile(@"please_enter_pin");
    self.navigationItem.title = NSLocalizedProfile(@"security_verification");
    
    self.textField.textColor = [UIColor clearColor];
    self.textField.tintColor = [UIColor clearColor];
    self.textField.font = UIFontMake(0);
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.textField.secureTextEntry = NO;
    self.textField.enablesReturnKeyAutomatically = YES;
    self.textField.clearsOnBeginEditing = NO;
    [self.textField addTarget:self action:@selector(textDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    CGFloat minimumInteritemSpacing = 16;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = minimumInteritemSpacing;
    [self.collectionView registerClass:[FPPasswordDotCell class] forCellWithReuseIdentifier:@"FPPasswordDotCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self applyTheme];
    
}

-(void)checkServerNotifications {
    
    UserConfigResponse *userConfigResponse = self.userConfig;
    
    if(userConfigResponse.isForceUpdateAvailable.boolValue) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedDefault(@"alert") message:NSLocalizedDefault(@"Force_update") preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedDefault(@"Update") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UIApplication *application = [UIApplication sharedApplication];
            NSURL *URL = [NSURL URLWithString:[self userConfig].updateUrl];
            [application openURL:URL options:@{} completionHandler:^(BOOL success) {
                if (success) {
                    NSLog(@"Opened url");
                }
            }];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedDefault(@"Close") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"cancelled");
            UIApplication *app = [UIApplication sharedApplication];
            [app performSelector:@selector(suspend)];
            [NSThread sleepForTimeInterval:2.0];
            exit(0);
            
        }]];
        [self presentViewController:alert animated:TRUE completion:nil];
        
    } else if(userConfigResponse.isRecommendedUpdateAvailable.boolValue) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedDefault(@"alert") message:NSLocalizedDefault(@"Update_available") preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedDefault(@"Update") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UIApplication *application = [UIApplication sharedApplication];
            NSURL *URL = [NSURL URLWithString:[self userConfig].updateUrl];
            [application openURL:URL options:@{} completionHandler:^(BOOL success) {
                if (success) {
                    NSLog(@"Opened url");
                }
            }];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedDefault(@"Remind") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"cancelled");
            
        }]];
        [self presentViewController:alert animated:TRUE completion:nil];
        
    } else if(userConfigResponse.isGlobalMessageBlockinUse.boolValue) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedDefault(@"alert") message:[self userConfig].globalMessage preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedDefault(@"Ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UIApplication *app = [UIApplication sharedApplication];
            [app performSelector:@selector(suspend)];
            [NSThread sleepForTimeInterval:2.0];
            exit(0);
            
        }]];
        [self presentViewController:alert animated:TRUE completion:nil];
    } else if(userConfigResponse.isGlobalMessageAvailable.boolValue){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedDefault(@"alert") message:[self userConfig].globalMessage preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedDefault(@"Ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }]];
        [self presentViewController:alert animated:TRUE completion:nil];
    } else {
        [self.textField becomeFirstResponder];
    }
}

- (UserConfigResponse *)userConfig{
    NSError *error;
    return [HimalayaAuthKeychainManager loadUserConfigToKeychain:&error];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self applyTheme];
}

- (void)applyTheme{
    self.view.backgroundColor = [self getCurrentTheme].background;
    self.hintLabel.textColor = [self getCurrentTheme].primaryOnBackground;
}

- (void)textDidChanged:(UITextField *)textField {
    [self.collectionView reloadData];
    if (textField.text.length == 6) {
        [self executeVerifyPinWithInputText:textField.text];
    }
    if (textField.text.length > 6) {
        textField.text = [textField.text substringToIndex:6];
    }
}

- (void)executeVerifyPinWithInputText:(NSString *)inputText{
    [self.textField resignFirstResponder];
    
    if (!self.verifyPinUseCase){
        self.verifyPinUseCase = [[VerifyPinUseCase alloc] init];
    }
    
    [MBHUD showInView:self.view withTitle:nil withType:HUDTypeLoading];
    
    WS(weakSelf)
    [self.verifyPinUseCase executeWithRequest:inputText
                            completionHandler:^(id  _Nullable response, NSInteger errorCode, NSString * _Nullable errorMessage) {
        [MBHUD hideInView:weakSelf.view];
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"HPAYBioAuth_getPIN"];
        //NSLog(@"HPAYBioAuth_getPIN = %d", [[NSUserDefaults standardUserDefaults] boolForKey:@"HPAYBioAuth_getPIN"]);
        
        
        if (response){
            [self showOrSkipSavePINAlert:inputText];
            
        }else{
            if (errorCode == 30002 && [[[HPAYBioAuth sharedInstance] getBioAuthOn] boolValue]) {
                [[HPAYBioAuth sharedInstance] deletePIN];
                [[HPAYBioAuth sharedInstance] saveIsBioAuthOn:[NSNumber numberWithBool:NO]];
                [[HPAYBioAuth sharedInstance] saveIsNeedToSavePIN:YES];
            }
            
            [weakSelf clearPIN];
            [weakSelf.textField becomeFirstResponder];
            [weakSelf handleVerifyPinErrorWithErrorCode:errorCode errorMessage:errorMessage];
        }
    }];
}

-(void) showOrSkipSavePINAlert:(NSString *)PIN {
    
    if ([[HPAYBioAuth sharedInstance] getIsBioAuthAvailable] && ![[[HPAYBioAuth sharedInstance] getAlreadyAskedForBioAuth] boolValue]){
        
        UIAlertController *alertController = [UIAlertController
          alertControllerWithTitle:NSLocalizedString(@"biometric.ivite.alert.title", @"")
          message:NSLocalizedString(@"biometric.ivite.alert.desc", @"")
          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"biometric.ivite.alert.cancel", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self handleVerifyPinSuccess:PIN];
            
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedDefault(@"biometric.ivite.alert.okay") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            
            if (![[HPAYBioAuth sharedInstance] checkForSystemAlert]) {
                [[HPAYBioAuth sharedInstance] getPIN];
                [[HPAYBioAuth sharedInstance] checkIsBioAvailable];
                if ([[HPAYBioAuth sharedInstance] getIsBioAuthAvailable]){
                    [[HPAYBioAuth sharedInstance] saveIsNeedToSavePIN:YES];
            
                }
            } else {
                [[HPAYBioAuth sharedInstance] saveIsNeedToSavePIN:YES];
            }
            
            [self handleVerifyPinSuccess:PIN];
        }];
      
        [alertController addAction:dismissAction];
        [alertController addAction:okAction];
        [alertController setPreferredAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        [[HPAYBioAuth sharedInstance] saveIsAlreadyAskedForBioAuth:[NSNumber numberWithBool:YES]];
    } else {
        [self handleVerifyPinSuccess:PIN];
    }
    
}

extern NSString *appLive;
- (void)handleVerifyPinSuccess:(NSString *)PIN {
    
    if ([[[HPAYBioAuth sharedInstance] getIsNeedToSavePIN] boolValue]){
        [[HPAYBioAuth sharedInstance] savePIN:PIN];
        [[HPAYBioAuth sharedInstance] saveIsBioAuthOn:[NSNumber numberWithBool:YES]];
    }
    
    appLive = @"YES";
    NSString *LOADED_FROM_NOTIFICATION = @"loaded_fromnotification";
    if([[[NSUserDefaults standardUserDefaults] objectForKey:LOADED_FROM_NOTIFICATION] isEqualToString:@"YES"]){
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadStatementsNotification" object:nil];
        }];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kOpenDeeplink object:nil];
        }];
    }
}

- (void)handleVerifyPinErrorWithErrorCode:(NSInteger)errorCode errorMessage:(NSString *)errorMessage{
    switch (errorCode) {
        case kErrorCodeMaxPinAttemptExceeded:{
            [self showAlertForPinAttemptExceededWithHandler:^{
                [self didTapContinue];
            }];
            break;
        }
        default:
            [MBHUD showInView:self.view withDetailTitle:errorMessage withType:HUDTypeFailWithoutImage];
            break;
    }
}

- (void)didTapContinue{
    SecurityRouter *router = [[SecurityRouter alloc] init];
    router.currentControllerDelegate = self;
    [router presentToPinSetForVerify:YES];
}

- (void)clearPIN {
    self.textField.text = nil;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat h = CGRectGetHeight(collectionView.frame);
    return CGSizeMake(h, h);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FPPasswordDotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FPPasswordDotCell class]) forIndexPath:indexPath];
    UIImage *image;
    if (self.textField.text.length > 0) {
        if (indexPath.item <= self.textField.text.length - 1) {
            image = [UIImage imageNamed:@"pic_pin_input"];
            cell.imageView.tintColor = [self getCurrentTheme].passwordDotFilled;
        } else {
            image = [UIImage imageNamed:@"pic_pin_input_none"];
            cell.imageView.tintColor = [self getCurrentTheme].passwordDot;
        }
    } else {
        image = [UIImage imageNamed:@"pic_pin_input_none"];
        cell.imageView.tintColor = [self getCurrentTheme].passwordDot;
    }
    cell.imageView.image = image;
    return cell;
}

@end
