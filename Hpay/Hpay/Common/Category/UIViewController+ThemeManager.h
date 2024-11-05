//
//  UIViewController+ThemeManager.h
//  Hpay
//
//  Created by Ugur Bozkurt on 15/11/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ThemeManager)

- (id<ThemeProtocol>)getCurrentTheme;

@end

NS_ASSUME_NONNULL_END
