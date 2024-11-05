//
//  UIViewController+Extension.h
//  Hpay
//
//  Created by Ugur Bozkurt on 22/07/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum Alignment : NSUInteger {
    kAlignmentBottom = 0,
    kAlignmentTop = 1,
    kAlignmentFull = 2
} Alignment;

@interface UIViewController (Extension)
- (void)m_addChild:(UIViewController*)child alignment:(Alignment)alignment height:(nullable NSNumber*)height;
- (void)m_removeChild:(UIViewController*)child;
- (void)showVerifyPinVC;
@end

NS_ASSUME_NONNULL_END
