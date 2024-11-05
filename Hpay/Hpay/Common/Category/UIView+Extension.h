//
//  UIView+Extension.h
//  HVWWeibo
//
//  Created by hellovoidworld on 15/2/2.
//  Copyright (c) 2015年 hellovoidworld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

@property(nonatomic, assign) CGFloat x;
@property(nonatomic, assign) CGFloat y;

@property(nonatomic, assign, readonly) CGFloat right;
@property(nonatomic, assign, readonly) CGFloat bottom;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;
@property(nonatomic, assign) CGSize size;
@property(nonatomic, assign) CGFloat centerX;
@property(nonatomic, assign) CGFloat centerY;


/**
 * 可视化设置边框宽度
 */
@property(nonatomic, assign) IBInspectable CGFloat borderWidth;

/**
 * 可视化设置边框颜色
 */
@property(nonatomic, strong) IBInspectable UIColor *borderColor;

/**
 * 可视化设置圆角
 */
@property(nonatomic, assign) IBInspectable CGFloat cornerRadius;

- (void)configureBackgroundColorFor:(BOOL)enabled;
@end
