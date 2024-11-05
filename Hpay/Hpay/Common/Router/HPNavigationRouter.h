//
//  HPNavigationRouter.h
//  Hpay
//
//  Created by Olgu Sirman on 30/12/2020.
//  Copyright © 2020 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol HPNavigationRouterDelegate <NSObject>

- (void)pushTo:(UIViewController *_Nonnull)viewController animated:(BOOL)animated;
- (void)pushTo:(UIViewController *_Nonnull)viewController;

- (void)present:(UIViewController *_Nonnull)viewController animated:(BOOL)animated completion:(void (^_Nullable)(void))completion;
- (void)present:(UIViewController *_Nonnull)viewController animated:(BOOL)animated;
- (void)present:(UIViewController *_Nonnull)viewController;

- (void)pop:(BOOL)animated;
- (void)pop;

- (void)popToRoot:(BOOL)animated;
- (void)popToRoot;

- (void)dismiss;
- (void)dismissOrClose;

- (void)showAlertWithTitle:(NSString *_Nullable)title
                   message:(NSString *_Nonnull)message
               cancelActionTitle:(NSString *_Nonnull)cancelActionTitle
             actionHandler:(void (^_Nullable)(UIAlertAction *_Nonnull))actionHandler;

- (void)showAlertWithMessage:(NSString *_Nonnull)message
               actionHandler:(void (^_Nullable)(UIAlertAction *_Nonnull))actionHandler;

#pragma mark - Root

- (void)updateTheWindowRootAsTabBarWithAnimation;
- (void)showSplashViewControllerAsRoot;

#pragma mark - Deeplink

-(void)presentPayMerchantWithOrderId:(NSString *_Nonnull)orderId;
-(void)presentPaymentRequestWithOrderId:(NSString * _Nonnull)orderId;
-(void)presentPaymentRequestWithUserHash:(NSString * _Nonnull)userHash;
@end

NS_ASSUME_NONNULL_BEGIN

@interface HPNavigationRouter : NSObject <HPNavigationRouterDelegate>

@property(weak, nonatomic, nullable) UINavigationController *navigationDelegate;
@property(weak, nonatomic, nullable) UIViewController *currentControllerDelegate;
@property(weak, nonatomic, nullable) UITabBarController *tabBarControllerDelegate;

@end

NS_ASSUME_NONNULL_END
