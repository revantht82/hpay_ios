//
//  UIViewController+ThemeManager.m
//  Hpay
//
//  Created by Ugur Bozkurt on 15/11/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "UIViewController+ThemeManager.h"

@implementation UIViewController (ThemeManager)

- (id<ThemeProtocol>)getCurrentTheme{
    return [self.view getCurrentTheme];
}

@end
