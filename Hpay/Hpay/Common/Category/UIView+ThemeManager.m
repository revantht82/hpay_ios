//
//  UIView+ThemeManager.m
//  Hpay
//
//  Created by Ugur Bozkurt on 15/11/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "UIView+ThemeManager.h"

@implementation UIView (ThemeManager)

- (id<ThemeProtocol>)getCurrentTheme{
    return [[ThemeManager sharedInstance] getCurrentThemeForView:self];
}

- (void)setUserInterfaceStyle:(UIUserInterfaceStyle)style{
    [NSUserDefaults.standardUserDefaults setInteger:(NSInteger)style forKey:kUserInterfaceStyle];
    self.window.overrideUserInterfaceStyle = style;
    
    [[ThemeManager sharedInstance] applySelectedUserInterfaceStyle:self.window];
}

@end
