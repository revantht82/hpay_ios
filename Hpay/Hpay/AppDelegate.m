//
//  AppDelegate.m
//  FiiiPay
//
//  Created by Singer on 2018/3/23.
//  Copyright © 2018年 Singer. All rights reserved.
//

#import "AppDelegate.h"
#import "FPTabBarController.h"
#import "PINSetViewController.h"
#import "LoginHelperModel.h"
#import "UIViewController+CurrentViewController.h"
//#import "FaceOrTouchIDLoginViewController.h"
#import "PaySuccessViewController.h"
#import "CBPayView.h"
#import "ChooseCoinViewController.h"
#import "PayViewController.h"
#import "DepositCoinViewController.h"
#import "FPNotice.h"
#import "HelpFeedbackViewController.h"
#import "IdentityAuthViewController.h"
#import "AdvertisingOperation.h"
#import "LockOperation.h"
#import "VersionOperation.h"
#import "LaunchViewOperation.h"
#import "NSOperation+FPOperation.h"
#import "DownLoadAdvertisingfigureOperation.h"
#import "FPMQTTClientManager.h"
#import "NSDictionary+Extension.h"
#import "HomeViewController.h"
#import "GestureUnLockScreenSettingViewController.h"
#import "HPayJailbreakDetection.h"
#import "PrivacyProtectionHelper.h"
#import "FBCoin.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max

#import <UserNotifications/UserNotifications.h>

#endif

#ifdef DEBUG
#define kFPEnterBackgroundMaxTime 0
#else
#define kFPEnterBackgroundMaxTime 0
#endif

@import Firebase;

@interface AppDelegate () <FPMQTTClientManagerDelegate, UNUserNotificationCenterDelegate>

@property(nonatomic, copy) NSString *queryId;
@property(nonatomic, strong) CBPayView *payView;
@property(nonatomic, assign) BOOL delayShowPayView;
@property(nonatomic, assign) BOOL isEnterBackground;
//@property (nonatomic ,strong) CLLocationManager *locationManager;

@end

@implementation AppDelegate

+ (UIWindow *)keyWindow {
    UIWindow *foundWindow = nil;
    NSArray *windows = [[UIApplication sharedApplication]windows];
    for (UIWindow *window in windows) {
        if (window.isKeyWindow) {
            foundWindow = window;
            break;
        }
    }
    return foundWindow;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    if ([HPayJailbreakDetection isJailbroken]) {
        return NO;
    }

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];

    [FIRApp configure];
    //语言环境
    [self configLanguage];

    [self applicationLanuch];

    [self setStripPay];

    //注册apns
    [self initPushApplication];
    [self observerScreenDetection];

    return YES;
}

#pragma mark - 设置strip支付参数

- (void)setStripPay {
    [Stripe setDefaultPublishableKey:Pay_Stripe_Live_Key];
}

#pragma mark - 设置语言环境

- (void)configLanguage {
    [FPLanguageTool sharedInstance];
}

#pragma mark - APP启动顺序

- (void)applicationLanuch {
    LaunchViewOperation *launchViewOP = [[LaunchViewOperation alloc] initWithWindow:&_window];
    // 获取baseURL
//    GetBaseurlOperation *getBaseurlOP = [GetBaseurlOperation new];
    AdvertisingOperation *advertisingOP = [[AdvertisingOperation alloc] initWithWindow:&_window];
    LockOperation *lockOP = [LockOperation new];
    VersionOperation *versionOP = [VersionOperation new];
    // 获取广告接口
    DownLoadAdvertisingfigureOperation *downloadADOP = [DownLoadAdvertisingfigureOperation new];
    if ([self showAdvertisingfigure]) {
        [advertisingOP startAfterOperations:launchViewOP, nil];
        [lockOP startAfterOperations:advertisingOP, nil];
//        [getBaseurlOP startAfterOperations:lockOP];
//        [versionOP startAfterOperations:getBaseurlOP,nil];
        [versionOP startAfterOperations:lockOP, nil];
        [downloadADOP startAfterOperations:versionOP, nil];
        [NSOperationQueue syncStartOperations:launchViewOP, advertisingOP, nil];
//        [NSOperationQueue asyncStartOperations:lockOP,getBaseurlOP,versionOP,downloadADOP,nil];
        [NSOperationQueue asyncStartOperations:lockOP, versionOP, downloadADOP, nil];
    } else {
        [lockOP startAfterOperations:launchViewOP, nil];
//        [getBaseurlOP startAfterOperations:lockOP,nil];
//        [versionOP startAfterOperations:getBaseurlOP];
        [versionOP startAfterOperations:lockOP, nil];
        [downloadADOP startAfterOperations:versionOP, nil];
        [NSOperationQueue syncStartOperations:launchViewOP, lockOP, nil];
//        [NSOperationQueue asyncStartOperations:getBaseurlOP,versionOP,downloadADOP,nil];
        [NSOperationQueue asyncStartOperations:versionOP, downloadADOP, nil];
    }
}

#pragma mark -- 是否显示广告图

- (BOOL)showAdvertisingfigure {
    NSDictionary *cacheADDict = [[NSUserDefaults standardUserDefaults] objectForKey:kADAdvertisingKey];
    BOOL showAdvertising = NO;
    if (cacheADDict) {
        long long StartTime = [cacheADDict[@"StartTime"] longLongValue] / 1000;
        long long EndTime = [cacheADDict[@"EndTime"] longLongValue] / 1000;
        BOOL Status = [cacheADDict[@"Status"] boolValue];
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        NSString *imageId = cacheADDict[@"ImageId"];
        if (kIsZhLanguageCode) {
            imageId = cacheADDict[@"CNImageId"];
        }
        NSString *urlKey = [NSString stringWithFormat:@"%@?id=%@", ImageDownloadCoinURL, imageId];
        UIImage *image = [[SDWebImageManager sharedManager].imageCache imageFromCacheForKey:urlKey];
        if (Status && time >= StartTime && time <= EndTime && image) {
            showAdvertising = YES;
        }
    }
    return showAdvertising;
}

#pragma mark - APP广告
#pragma mark  检查广告更新

- (void)initAdvertising {
    [LoginHelperModel fetchAppAdvertisingCompletBlock:^(NSDictionary *dict, NSString *message, NSInteger errorCode) {
        if (errorCode == kFPNetRequestSuccessCode) {
            NSDictionary *cacheADDict = [[NSUserDefaults standardUserDefaults] objectForKey:kADAdvertisingKey];
            if (cacheADDict) {
                if (dict) {
                    NSMutableDictionary *dictTmp = [dict mutableCopy];
                    NSInteger singleId = [dictTmp[@"SingleId"] integerValue];
                    NSString *version = dictTmp[@"Version"];

                    NSInteger oldSingleId = [cacheADDict[@"SingleId"] integerValue];
                    NSString *oldVersion = cacheADDict[@"Version"];
                    NSString *imageId = cacheADDict[@"ImageId"];
                    if (kIsZhLanguageCode) {
                        imageId = cacheADDict[@"CNImageId"];
                    }
                    NSString *urlKey = [NSString stringWithFormat:@"%@?id=%@", ImageDownloadCoinURL, imageId];
                    UIImage *image = [[SDWebImageManager sharedManager].imageCache imageFromCacheForKey:urlKey];
                    if (oldSingleId != singleId || oldVersion != version || !image) {
                        //当版本号和广告ID不一致则重新下载图片
                        [self downloadAdvertisingImage:dictTmp];
                    }
                } else {
                    //如果返回广告为null 则清楚本地广告缓存

                    [self removeAdvertisingCache:cacheADDict];

                }
            } else {
                //没有缓存广告 第一次缓存
                if (dict) {
                    NSMutableDictionary *dic = [dict mutableCopy];
                    [self downloadAdvertisingImage:dic];
                }

            }
        }
    }];
}

#pragma mark  下载广告图片

- (void)downloadAdvertisingImage:(NSMutableDictionary *)dict {
    //先删除旧的广告
    NSDictionary *cacheADDict = [[NSUserDefaults standardUserDefaults] objectForKey:kADAdvertisingKey];
    if (cacheADDict) {
        [self removeAdvertisingCache:cacheADDict];
    }

    NSString *imageId = dict[@"ImageId"];
    if (kIsZhLanguageCode) {
        imageId = dict[@"CNImageId"];
    }
    if (imageId.length != 0 && ![imageId isEqualToString:@"00000000-0000-0000-0000-000000000000"]) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?id=%@", ImageDownloadCoinURL, imageId]];
        [[SDWebImageManager sharedManager].imageDownloader setValue:kLocaleLanguageCode forHTTPHeaderField:@"Accept-Language"];
        [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:url options:0 progress:NULL completed:^(UIImage *_Nullable image, NSData *_Nullable data, NSError *_Nullable error, BOOL finished) {
            if (!error && image && finished) {
                [[SDWebImageManager sharedManager] saveImageToCache:image forURL:url];
                [[NSUserDefaults standardUserDefaults] setObject:dict forKey:kADAdvertisingKey];
            }
        }];
    }
}

#pragma mark  删除本地广告

- (void)removeAdvertisingCache:(NSDictionary *)dict {
    NSString *imageId = dict[@"ImageId"];
    NSString *cnImageId = dict[@"CNImageId"];
    NSString *url = [NSString stringWithFormat:@"%@?id=%@", ImageDownloadURL, imageId];
    NSString *cnUrl = [NSString stringWithFormat:@"%@?id=%@", ImageDownloadURL, cnImageId];
    [[SDWebImageManager sharedManager].imageCache removeImageForKey:url withCompletion:^{
        NSLog(@"删除EN旧广告图片成功");
    }];
    [[SDWebImageManager sharedManager].imageCache removeImageForKey:cnUrl withCompletion:^{
        NSLog(@"删除CN旧广告图片成功");
    }];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kADAdvertisingKey];
}

//#pragma mark - 初始化友盟
//-(void)initUMeng{
//#if DEBUG
//
//#else
//    NSString *channel = @"App Store";
//    if (ENTERPRISE) {
//        channel = @"Enterprise";
//    }
//    [UMConfigure initWithAppkey:@"5af00c5cf29d9848a80000fc" channel:channel];
//#endif
//}

//#pragma mark - 初始化推送服务
- (void)initPushApplication {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError *_Nullable error) {
        if (granted) {
            [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *_Nonnull settings) {
                if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[UIApplication sharedApplication] registerForRemoteNotifications];
                    });
                }
            }];
        }
    }];
}

////收到通知 App处于前台接收通知时 只会是app处于前台状态 前台状态 and 前台状态下才会走，后台模式下是不会走这里的
//- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
//    completionHandler(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound);
//}
//
////App通知的点击事件 只是用户点击消息栏里的消息才会触发
//- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
//
//    completionHandler();
//}


#pragma mark - 收到极光自定义消息

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    if ([GCUserManager manager].isLogin == NO) {
        return;
    }
    NSDictionary *userInfo = [notification userInfo];
    NSDictionary *extra = userInfo[@"extras"];
    FPNotice *notice = [FPNotice mj_objectWithKeyValues:extra];
    if (notice.MsgType == FPNoticeTypeToBePaid) {

        if (notice.QueryId.length == 0) {
            return;
        }
        if (self.payView == nil) {
            self.payView = [CBPayView getPayView];
        }

        if (self.payView && [self.payView.queryId isEqualToString:notice.QueryId]) {
            // 如果极光推送同时推了相同的queryID 过来，则不弹框
            return;
        }
//        if (self.payView) {
//            // 如果同时收到不同queryID，默认选择最新的queryID
//            [self.payView hide];
//            self.payView = nil;
//        }
        if (notice.QueryId.length > 0) {
            UIViewController *VC = [UIViewController getCurrentViewController];
            if ([VC isKindOfClass:[GestureUnLockScreenSettingViewController class]]) {
                GestureUnLockScreenSettingViewController *screenVC = (GestureUnLockScreenSettingViewController *) VC;
                screenVC.dismissCompletBlock = ^{
                    [self showPayView:notice.QueryId];
                };
            } else {
                if ([self isNeedToPresentScreenLockVC]) {
                    self.delayShowPayView = YES;
                    self.queryId = notice.QueryId;
                } else {
                    [self showPayView:notice.QueryId];
                }
            }
        }
    } else if (notice.MsgType == FPNoticeTypePaySuccess || notice.MsgType == FPNoticeTypeRefundSuccess || notice.MsgType == FPNoticeTypeDepositSuccess || notice.MsgType == FPNoticeTypeWithdrawalSuccess || notice.MsgType == FPNoticeTypeWithdrawalReject) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNoticeNotification object:extra];
    }
}

- (void)fp_MQTTReceivedNewMessage:(NSDictionary *)dict {
    if ([GCUserManager manager].isLogin == NO) {
        return;
    }
    NSInteger type = [dict[@"MsgType"] integerValue];
    if (dict[@"MsgType"] && type == FPNoticeTypeToBePaid) {
        NSString *queryId = dict[@"QueryId"];


        if (queryId.length == 0) {
            return;
        }
        if (self.payView == nil) {
            self.payView = [CBPayView getPayView];
        }

        if (self.payView && [self.payView.queryId isEqualToString:queryId]) {
            // 如果极光推送同时推了相同的queryID 过来，则不弹框
            return;
        }
        //        if (self.payView) {
        //            // 如果同时收到不同queryID，默认选择最新的queryID
        //            [self.payView hide];
        //            self.payView = nil;
        //        }
        if (queryId.length > 0) {
            UIViewController *VC = [UIViewController getCurrentViewController];
            if ([VC isKindOfClass:[GestureUnLockScreenSettingViewController class]]) {
                GestureUnLockScreenSettingViewController *screenVC = (GestureUnLockScreenSettingViewController *) VC;
                screenVC.dismissCompletBlock = ^{
                    [self showPayView:queryId];
                };
            } else {
                if ([self isNeedToPresentScreenLockVC]) {
                    self.delayShowPayView = YES;
                    self.queryId = queryId;
                } else {
                    [self showPayView:queryId];
                }
            }
        }
    }
}


- (void)showPayView:(NSString *)QueryId {

    UIViewController *currentVC = [UIViewController getCurrentViewController];
    if ([currentVC isKindOfClass:[PayViewController class]]) {
        PayViewController *payVC = (PayViewController *) currentVC;
        [payVC paySuccessAction];
    }

//    CBPayView *payView = [CBPayView getPayView];
    self.payView.clickBlock = ^(CBPayViewClickType clickType, FPOrderDetailModel *model) {
        if (clickType == CBPayViewClickSuccessType) {
            // 支付完成,跳转到支付成功页面

            PaySuccessViewController *paySuccessVC = [SB_HOME instantiateViewControllerWithIdentifier:@"PaySuccessViewController"];
            paySuccessVC.orderDetailModel = model;
            FPNavigationController *nav = [[FPNavigationController alloc] initWithRootViewController:paySuccessVC];
            nav.modalPresentationStyle = UIModalPresentationFullScreen;
            [currentVC presentViewController:nav animated:YES completion:^{
                [currentVC.navigationController popToRootViewControllerAnimated:NO];
            }];
        } else if (clickType == CBPayViewClickTopupType) {
            if ([[NSUserDefaults standardUserDefaults] boolForKey:kFPIsLV1Verified] == NO) {
                [FPAlert alertPersonInfoCertificationViewCancelHandler:^{

                }                                            okHandler:^{
                    IdentityAuthViewController *vc = [SB_PROFILE instantiateViewControllerWithIdentifier:@"IdentityAuthViewController"];
                    [currentVC.navigationController pushViewController:vc animated:YES];
                }];
                return;
            }
            // 前往充值界面
            DepositCoinViewController *depositCoinVC = [SB_WALLET instantiateViewControllerWithIdentifier:@"DepositCoinViewController"];
            FBCoin *coin = [FBCoin new];
            coin.Id = model.CoinId;
            coin.Code = model.Currency;
            [depositCoinVC configWithCoin:coin];
            [currentVC.navigationController pushViewController:depositCoinVC animated:YES];
        } else if (clickType == CBPayViewClickLinkType) {
            // 禁止提币，点击联系客服
            HelpFeedbackViewController *vc = [SB_PROFILE instantiateViewControllerWithIdentifier:@"HelpFeedbackViewController"];
            [currentVC.navigationController pushViewController:vc animated:YES];
        }
    };
    [self.payView loadDataWithOrderId:QueryId];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    NSString *deviceTokenString;
    if (@available(iOS 13.0, *)) {
        NSMutableString *deviceTokenStr = [NSMutableString string];
        const char *bytes = deviceToken.bytes;
        NSInteger count = deviceToken.length;
        for (int i = 0; i < count; i++) {
            [deviceTokenStr appendFormat:@"%02x", bytes[i] & 0x000000FF];
        }
        deviceTokenString = deviceTokenStr;
    } else {
        NSString *deviceTokenStr = [[[[deviceToken description]
                stringByReplacingOccurrencesOfString:@"<" withString:@""]
                stringByReplacingOccurrencesOfString:@">" withString:@""]
                stringByReplacingOccurrencesOfString:@" " withString:@""];
        deviceTokenString = deviceTokenStr;
    }
    [[NSUserDefaults standardUserDefaults] setObject:deviceTokenString forKey:kPushDeviceToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self bindPushToken];
}

- (void)bindPushToken {
    if ([GCUserManager manager].isLogin) {
        NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:kPushDeviceToken];
        /// 绑定设备到推送服务
        [LoginHelperModel bindNoticeRegId:token CompleteBlock:^(BOOL isSuccess, NSString *message) {
        }];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOADMSG" object:nil];
    NSLog(@"userInfo：%@", userInfo);
    NSDictionary *apsDic = userInfo[@"aps"];
    if ([apsDic[@"badge"] integerValue] > 0) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = [apsDic[@"badge"] integerValue];
    } else {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
    }
    NSDictionary *userInfoDict = apsDic[@"userinfo"];
    NSMutableDictionary *userInfo2 = [userInfoDict mutableCopy];
    // Required, iOS 7 Support
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
//        NSDictionary *apsDict = userInfo[@"aps"];
//        NSInteger badge = [apsDict[@"badge"] integerValue] - 1;
//        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badge];

        NSObject *queryID = userInfoDict[@"QueryId"];

        if (queryID) {
            if ([queryID isKindOfClass:[NSNumber class]]) {
                NSString *queryIDStr = [((NSNumber *) queryID) stringValue];
                userInfo2[@"QueryId"] = queryIDStr;
            }
        }
        /// 杀死，后台点击通知栏 处理远程推送的跳转
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
            //挂起状态（App在后台没被杀死）
            [[NSNotificationCenter defaultCenter] postNotificationName:kOpenRemoteNotification object:[userInfo2 copy]];
        } else {
            //App被杀死后
            AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
            delegate.notificationUserInfo = [userInfo2 copy];
        }
    } else if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        [self fp_MQTTReceivedNewMessage:userInfo2];
    }
    completionHandler(UIBackgroundFetchResultNewData);
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"通知推送错误为: %@", error);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    [PrivacyProtectionHelper applyBlurEffectToWindow:self.window];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSDate *date = [NSDate date];
    NSTimeInterval old = [date timeIntervalSince1970];
    [[NSUserDefaults standardUserDefaults] setDouble:old forKey:@"kFPScreenLock"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    self.isEnterBackground = YES;
    [FPAlert close];

    //清除推送角标
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@">>>>>>>>>>>>>>>>>>>>>applicationDidBecomeActive");
    [PrivacyProtectionHelper hideBlurViewFromWindow:self.window];
    if ([self isNeedToPresentScreenLockVC]) {

        UIViewController *currentVC = [UIViewController getCurrentViewController];
        if ([currentVC isKindOfClass:[GestureUnLockScreenSettingViewController class]]) {
            return;
        }
        GestureUnLockScreenSettingViewController *lockVC = [GestureUnLockScreenSettingViewController new];
        lockVC.type = GestureViewControllerTypeLogin;
        lockVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        lockVC.dismissCompletBlock = ^{
            if (self.queryId && self.queryId.length > 0 && self.delayShowPayView) {
                [self showPayView:self.queryId];
                self.delayShowPayView = NO;
                self.queryId = nil;
                return;
            }
//            if (self.redPocketPassCode && self.redPocketPassCode.length > 0) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:kShowSimpleRedPocketNotification object:[self.redPocketPassCode copy]];
//                return;
//            }
//            [self checkPasteboard];

        };
        lockVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [currentVC presentViewController:lockVC animated:NO completion:^{

        }];
    } else {
//        NSLog(@">>>>>>>>>>>>>>>>>>>>>applicationDidBecomeActive 不锁屏");
//        [self checkPasteboard];
    }
    self.isEnterBackground = NO;
    //清除推送角标
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

//-(void)checkPasteboard{
//    if (self.redPocketPassCode.length >0) {
////        NSLog(@">>>>>>>>>>>>>>>>>>>>>self.redPocketPassCode.length>0");
//        [[NSNotificationCenter defaultCenter] postNotificationName:kShowSimpleRedPocketNotification object:[self.redPocketPassCode copy]];
//    }else{
//        NSString *redPocketPassCode = [NSString queryRedPocketPassCodeWithPasteboard];
//        if (redPocketPassCode) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:kShowSimpleRedPocketNotification object:redPocketPassCode];
//        }
//    }
//
//}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
//    NSLog(@">>>>>>>>>>>>>>>>>>>>>openURL");
    NSString *scheme = url.scheme;
    if ([[scheme lowercaseString] isEqualToString:@"fiiipay"] && [url.host isEqualToString:@"redpocket"]) {

        if ([GCUserManager manager].isLogin) {
//            NSLog(@">>>>>>>>>>>>>>>>>>>>>user is login");
            NSDictionary *param = [NSDictionary parameterWithURL:url];
            NSString *redPocketPassCode = param[@"code"];

            if (redPocketPassCode.length > 0) {
//                NSLog(@">>>>>>>>>>>>>>>>>>>>>redPocketPassCode:%@",redPocketPassCode);
                /// 杀死，后台点击通知栏 处理远程推送的跳转
                if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
                    //挂起状态（App在后台没被杀死）
                    if ([self isNeedToPresentScreenLockVC]) {
                        self.redPocketPassCode = redPocketPassCode;
                    } else {
//                        NSLog(@">>>>>>>>>>>>>>>>>>>>>不锁屏");
                        self.redPocketPassCode = redPocketPassCode;
//                        [[NSNotificationCenter defaultCenter] postNotificationName:kShowSimpleRedPocketNotification object:redPocketPassCode];
                    }

                } else {
                    //App被杀死后
//                    NSLog(@">>>>>>>>>>>>>>>>>>>>>App被杀死后 Delegate设置redPocketPassCode");
                    self.redPocketPassCode = redPocketPassCode;

                }
            }
        } else {
            UIViewController *rootVC = [[UIApplication sharedApplication] delegate].window.rootViewController;
            if ([rootVC isKindOfClass:[FPTabBarController class]]) {
                UINavigationController *navVC = ((FPTabBarController *) rootVC).viewControllers.firstObject;
                HomeViewController *homeVC = navVC.viewControllers.firstObject;
                [homeVC login];
            }
        }
    }
//    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url options:options];
    // Add any custom logic here.
//    return handled;
    return YES;
}

#pragma mark -- 判断是否需要弹起锁屏VC

- (BOOL)isNeedToPresentScreenLockVC {

    if ([GCUserManager manager].isLogin == NO) {
        return NO;
    }


    NSDate *date = [NSDate date];
    NSTimeInterval now = [date timeIntervalSince1970];
    NSTimeInterval old = [[NSUserDefaults standardUserDefaults] doubleForKey:@"kFPScreenLock"];

    if (self.isEnterBackground && (now - old) > kFPEnterBackgroundMaxTime && old > 0 && now > 0) {

//        /// 本地是否开启 touch id 或者 faceID 解锁（硬件解锁）
//        BOOL isOpenBiometricsAuth = [[[NSUserDefaults standardUserDefaults] objectForKey:kisOpenBiometricsUnlockKey] boolValue];

        /// 本地是否开始 锁屏密码解锁
        BOOL isOpenLockScreenAuth = [[[NSUserDefaults standardUserDefaults] objectForKey:kisOpenPasswordUnlockKey] boolValue];

//        FPSecurityAuthManager *authManager = [[FPSecurityAuthManager alloc] init];

        if (isOpenLockScreenAuth) {
            return YES;
        } else {
            return NO;
        }

    } else {
        return NO;
    }

}

- (void)applicationWillTerminate:(UIApplication *)application {
    if ([[GCUserManager manager] user]) {
        [[GCUserManager manager] logOutAndUpdateTheService];
        // Every time logOut the user, The apps trigger that notification. This notification used only for the updateTheUI and closing webSocket. We don't need while we terminating the app.
        //[[NSNotificationCenter defaultCenter] postNotificationName:kLogOutNotification object:nil];
    }
}

#pragma mark ScreenDetection Helper

- (void)observerScreenDetection {
    if (@available(iOS 11.0, *)) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDetectRecording:) name:UIScreenCapturedDidChangeNotification object:nil];
    }
}


- (void)didDetectRecording:(NSNotification *)notification {

    if (@available(iOS 11.0, *)) {
        if ([[UIScreen mainScreen] isCaptured]) {
            [PrivacyProtectionHelper applyBlurEffectToWindow:self.window];
        } else {
            [PrivacyProtectionHelper hideBlurViewFromWindow:self.window];
        }
    }

}

@end
