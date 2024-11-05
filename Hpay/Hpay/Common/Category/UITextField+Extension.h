//
//  UITextField+Extension.h
//  GrandeurCollect
//
//  Created by 陈伟鑫 on 2017/7/12.
//  Copyright © 2017年 fiiipay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Extension)


@property (nonatomic,copy)IBInspectable NSString *localizeKey;
// 通过代码以及IB的方式添加UITextField左边的Icon
@property (nonatomic, copy) NSString *leftImageName;
@property (nonatomic, copy, getter=leftImageName) IBInspectable NSString *IB_leftImageName;

// 通过代码以及IB的方式添加UITextField左边的String
@property (nonatomic, copy) NSString *leftString;
@property (nonatomic, copy, getter=leftString) IBInspectable NSString *IB_leftString;

@property (nonatomic , assign) NSTextAlignment leftLabel_textAligment;

@property (nonatomic, strong) UIFont *leftLabelFont;
@property (nonatomic, strong) UIColor *leftLabelColor;

// 通过代码以及IB的方式添加UITextField左边的View的最大宽度
@property (nonatomic, assign) CGFloat leftLimitWidth;
@property (nonatomic, assign, getter=leftLimitWidth) IBInspectable CGFloat IB_leftLimitWidth;

// 通过代码以及IB的方式添加UITextField最大字数
@property (nonatomic, assign) NSInteger maxNumber;
@property (nonatomic, assign, getter=maxNumber) IBInspectable NSInteger IB_maxNumber;

@property (nonatomic, copy) void((^limitCallBackBlock)(void));

// 通过代码以及IB的方式添加UITextField下划线
@property (nonatomic, assign) BOOL isAddBottomLine;
@property (nonatomic, assign, getter=isAddBottomLine) IBInspectable BOOL IB_isAddBottomLine;

// YES就是为空，NO不为空
- (BOOL)textIsEmpty;

// 为空抖动动画
- (void)textEmpeyAnimation;


@end

