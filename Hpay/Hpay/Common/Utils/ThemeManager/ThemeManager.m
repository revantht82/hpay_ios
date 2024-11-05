//
//  ThemeManager.m
//  Hpay
//
//  Created by Ugur Bozkurt on 12/11/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "ThemeManager.h"
#import "ThemeProtocol.h"
#import "LightTheme.h"
#import "DarkTheme.h"

@interface ThemeManager()
@property (strong, nonatomic) id <ThemeProtocol> lightTheme;
@property (strong, nonatomic) id <ThemeProtocol> darkTheme;
@end

@implementation ThemeManager

NSInteger currentTheme;

+ (instancetype)sharedInstance {
    static ThemeManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[ThemeManager alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lightTheme = [[LightTheme alloc] init];
        self.darkTheme = [[DarkTheme alloc] init];
        currentTheme = UIUserInterfaceStyleDark;
    }
    return self;
}

- (id<ThemeProtocol>)getCurrentThemeForView:(UIView *)view{
    //id hhhh view.UITraitCollection.UIUserInterfaceStyle.UIUserInterfaceStyleDark
//    NSLog(@"%ld", view.traitCollection.userInterfaceStyle);
//    if (view.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
//        return _darkTheme;
//    }else if (view.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
//        return _lightTheme;
//    } else {
//        return _lightTheme;
//    }
    /////////////////////////////////////////////////////
    
//    UIUserInterfaceStyle style = [NSUserDefaults.standardUserDefaults integerForKey:kUserInterfaceStyle];
//    if (!style || style == UIUserInterfaceStyleDark){
//        return _darkTheme;
//    } else {
//        return _lightTheme;
//    }
    /////////////////////////////////////////////////////
//    NSArray<UIWindow *> *windows = [[UIApplication sharedApplication] windows];
//    for (UIWindow *window in windows) {
//        if (window.isKeyWindow) {
//            if (window.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
//                return _darkTheme;
//            } else if (window.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
//                return _lightTheme;
//            } else {
//                return _lightTheme;
//            }
//        }
//    }
//    return _darkTheme;
    
    if (currentTheme == UIUserInterfaceStyleDark) {
        return _darkTheme;
    } else if (currentTheme == UIUserInterfaceStyleLight) {
        return _lightTheme;
    } else {
        return _lightTheme;
    }
    
    
}

- (void)applySelectedUserInterfaceStyle:(UIWindow *)window{
    UIUserInterfaceStyle style = [NSUserDefaults.standardUserDefaults integerForKey:kUserInterfaceStyle];
    
    if (!style){
        style = window.traitCollection.userInterfaceStyle;
        //[NSUserDefaults.standardUserDefaults setInteger:style forKey:kUserInterfaceStyle];
    }
    window.overrideUserInterfaceStyle = style;
    currentTheme = style;
}

@end
