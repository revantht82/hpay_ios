#import "AppDelegate.h"
#import "FPTabBarController.h"
#import "PINSetViewController.h"
#import "LoginHelperModel.h"
#import "UIViewController+CurrentViewController.h"
#import "PaySuccessViewController.h"
#import "CBPayView.h"
#import "ChooseCoinViewController.h"
#import "FPNotice.h"
#import "HelpFeedbackViewController.h"
#import "NSDictionary+Extension.h"
#import "HomeViewController.h"
#import "HPayJailbreakDetection.h"
#import "FBCoin.h"
#import "SplashViewController.h"
#import "AppAuth.h"
#import "HPDeeplinkParser.h"
#import "HimalayaAuthKeychainManager.h"
#import "NSObject+Extension.h"
#import "ThemeManager.h"
#import "LightTheme.h"
#import "HimalayaPayAPIManager.h"
#import "ApiError.h"
#import "StatementViewController.h"
#import "HCPayMerchantRouter.h"
//#import "UIAlertController+Window.h"
#import "HPAYAnalytics.h"

#ifndef DISABLE_NETFOX
#import <netfox/netfox-Swift.h>
#endif

#define BLUR_BACKGROUND_SCREEN_TAG 8071

@import Firebase;
@import UserNotifications;
@import FirebaseCore;
@import FirebaseMessaging;

@interface AppDelegate () <UNUserNotificationCenterDelegate>
@end

@implementation AppDelegate
NSString *const kGCMMessageIDKey = @"gcm.message_id";
NSString *appLive = @"NO";

+ (nonnull UIWindow *)keyWindow {
    return ((AppDelegate*)UIApplication.sharedApplication.delegate).window;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if ([HPayJailbreakDetection isJailbroken]) {
        return NO;
    }
    NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [[NSUserDefaults standardUserDefaults] setValue:appVersionString forKey:@"APP_VERSION"];
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"HPAYBioAuth_getPIN"];
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"HPAYGroupSendInProgress"];
    //NSLog(@"HPAYBioAuth_getPIN = %d", [[NSUserDefaults standardUserDefaults] boolForKey:@"HPAYBioAuth_getPIN"]);
    NSLog(@"%@", appVersionString);
    [self deleteKeychainIfFirstRun];
    [self configureFirebase];
    [self setIsShowingVerifyPinViewController:NO];
    
#ifndef DISABLE_NETFOX
    [NFX.sharedInstance start];
#endif
    [FIRMessaging messaging].delegate = self;
    [UNUserNotificationCenter currentNotificationCenter].delegate = self; UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {}];
    [application registerForRemoteNotifications];
    [FPLanguageTool sharedInstance];
    [self setRootVC];
    [application registerForRemoteNotifications];
  
    return YES;
}

- (void)deleteKeychainIfFirstRun{
    NSString *FIRST_RUN_KEY = @"FirstRun";
    if (![[NSUserDefaults standardUserDefaults] objectForKey:FIRST_RUN_KEY]) {
        [NSUserDefaults.standardUserDefaults setInteger:UIUserInterfaceStyleDark forKey:kUserInterfaceStyle];
        [[[HimalayaAuthKeychainManager alloc] init] deleteCache];
        [[NSUserDefaults standardUserDefaults] setValue:@"did-first-run" forKey:FIRST_RUN_KEY];
    }
}

- (void)configureFirebase{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:kGoogleServiceInfoPlistFileName ofType:@"plist"];
    FIROptions *options = [[FIROptions alloc] initWithContentsOfFile:filePath];
    [FIRApp configureWithOptions:options];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
    fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  if (userInfo[kGCMMessageIDKey]) {
  }
  completionHandler(UIBackgroundFetchResultNewData);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
  NSDictionary *userInfo = notification.request.content.userInfo;
  if (userInfo[kGCMMessageIDKey]) {
  }
  completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionAlert);
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void(^)(void))completionHandler {
  NSDictionary *userInfo = response.notification.request.content.userInfo;
  if (userInfo[kGCMMessageIDKey]) {
  }
    NSString *LOADED_FROM_NOTIFICATION = @"loaded_fromnotification";
    [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:LOADED_FROM_NOTIFICATION];
    if([appLive isEqualToString:@"YES"]){
        HCPayMerchantRouter *router = [[HCPayMerchantRouter alloc] init];
        [router pushToStatementsList];
    }
    //if app killed before
    else{
        [self setRootVC];
    }
    completionHandler();
}

- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    NSDictionary *dataDict = [NSDictionary dictionaryWithObject:fcmToken forKey:@"token"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FCMToken" object:nil userInfo:dataDict];
    NSString *FCM_KEY = @"The_Fcm_Key";
    NSString *FCM_UPDATE_NEED_ONAPI = @"Fcm_Update_Needed";
    if ((![[NSUserDefaults standardUserDefaults] objectForKey:FCM_KEY]) || !([[NSUserDefaults standardUserDefaults] objectForKey:FCM_KEY]!=fcmToken) ) {
        [[NSUserDefaults standardUserDefaults] setValue:fcmToken forKey:FCM_KEY];
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:FCM_UPDATE_NEED_ONAPI];
        NSLog(@"\\FCM WAS NOT UP TO DATE SO I SET IT UP");
    }
    else{
        NSLog(@"\\FCM IS UP TO DATE");
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Unable to register for remote notifications: %@", error);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [FIRMessaging messaging].APNSToken = deviceToken;
}

- (void)setRootVC {
    UIWindow *window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window = window;
    [ThemeManager.sharedInstance applySelectedUserInterfaceStyle:self.window];
    SplashViewController *splashVC = [SplashViewController new];
    [self.window setRootViewController:splashVC];
    [self.window makeKeyAndVisible];
}

- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(UIApplicationExtensionPointIdentifier)extensionPointIdentifier{
    if ([extensionPointIdentifier isEqualToString: UIApplicationKeyboardExtensionPointIdentifier]) {
        return NO;
    }
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    if (_currentAuthorizationFlow && [_currentAuthorizationFlow resumeExternalUserAgentFlowWithURL:url]) {
      _currentAuthorizationFlow = nil;
    }
    return [self handleDeeplinkWithUrl:url];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler{
    NSURL *url = userActivity.webpageURL;
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb] && url) {
        if (_currentAuthorizationFlow && [_currentAuthorizationFlow resumeExternalUserAgentFlowWithURL:url]) {
          _currentAuthorizationFlow = nil;
        }
        return [self handleDeeplinkWithUrl:url];
    }
    return NO;
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:KPinVerifyTime];
}

-(void)applicationWillResignActive:(UIApplication *)application{
    //NSLog(@"read HPAYBioAuth_getPIN = %d", [[NSUserDefaults standardUserDefaults] boolForKey:@"HPAYBioAuth_getPIN"]);
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HPAYBioAuth_getPIN"]){
        return;
    }
    
    [[HPAYAnalytics sharedInstance] pushDataToServer];
    
    UIView *view = [self.window viewWithTag:BLUR_BACKGROUND_SCREEN_TAG];
    if (view != nil){
        view.alpha = 0.99;
    } else if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterial];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        //always fill the view
        blurEffectView.frame = self.window.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        blurEffectView.alpha = 0.99;
        blurEffectView.tag = BLUR_BACKGROUND_SCREEN_TAG;
        
        [self.window addSubview:blurEffectView];
    } else {
        UIView *blurEffectView = [[UIView alloc] initWithFrame:self.window.rootViewController.view.bounds];
        blurEffectView.backgroundColor = [UIColor blackColor];
        blurEffectView.alpha = 0.99;
        blurEffectView.tag = BLUR_BACKGROUND_SCREEN_TAG;
        
        [self.window addSubview:blurEffectView];
    }
}

-(void)applicationDidBecomeActive:(UIApplication *)application {
    [self removeBlurView];
}
-(void)applicationWillEnterForeground:(UIApplication *)application{
    [self removeBlurView];
}

-(void) removeBlurView {
    UIView *view = [self.window viewWithTag:BLUR_BACKGROUND_SCREEN_TAG];
    if (view != nil && view.alpha != 0) {
        [UIView animateWithDuration:0.4f animations:^{
            [view setAlpha:0];

        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application{
    NSLog(@"To be terminated!!!!");
    HPDeeplinkData *deeplink = [HPDeeplinkData retrieveFromLocal];
    [deeplink clearLocal];
    [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:KPinVerifyTime];
}

- (BOOL)handleDeeplinkWithUrl:(NSURL*)url{
    HPDeeplinkData* deeplinkData = [[HPDeeplinkParser sharedInstance] parseDeepLink:url];
    [deeplinkData saveToLocal];
    if (deeplinkData){
        [[NSNotificationCenter defaultCenter] postNotificationName:kOpenDeeplink object:nil];
        return YES;
    }
    return NO;
}

@end
