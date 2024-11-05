//
//  UIImageView+AFNetworking.h
//  Hpay
//
//  Created by Venkatesh Mandapthi on 23/11/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (AFNetworking)

- (void)setImageWithURLRequestImage:(NSString *)url withTintColor:(UIColor *)tintColor;

@end

NS_ASSUME_NONNULL_END
