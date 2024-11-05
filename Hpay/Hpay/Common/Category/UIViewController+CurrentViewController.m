//
//  UIViewController+CurrentViewController.m
//  GLC
//
//  Created by Mac on 2018/1/25.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "UIViewController+CurrentViewController.h"
#import "AppDelegate.h"

@implementation UIViewController (CurrentViewController)
+ (UIViewController *)getCurrentViewController {
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIWindow * window = appDelegate.window;
    if (window.windowLevel != UIWindowLevelNormal)
    {
        // UIApplication 的window的windowLevel 默认就是UIWindowLevelNormal
        // 如果当前window 不是系统默认的window得话，就遍历所有window，找到系统默认的window
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    // 获取window的rootViewController
    UIViewController *result = window.rootViewController;
    // 获取 rootViewController present出来的ViewController
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    // 如果result 属于 UITabBarViewController,就获取当前选中的ViewController
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [(UITabBarController *)result selectedViewController];
    }
    // 如果result 属于UINavigationController, 就获取栈顶的UIViewController
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
@end
