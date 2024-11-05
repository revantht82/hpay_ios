//
//  ThemeManager.h
//  Hpay
//
//  Created by Ugur Bozkurt on 12/11/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface ThemeManager : NSObject

+ (instancetype)sharedInstance;

- (id<ThemeProtocol>)getCurrentThemeForView:(UIView *)view;

- (void)applySelectedUserInterfaceStyle:(UIWindow *)window;

@end

NS_ASSUME_NONNULL_END
