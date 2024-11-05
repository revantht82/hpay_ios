//
//  UIButton+Extension.h
//  GrandeurCollect
//
//  Created by 陈伟鑫 on 2017/7/5.
//  Copyright © 2017年 fiiipay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)
@property (nonatomic,copy)IBInspectable NSString *localizeKey;
- (void)setClickAction:(void(^)(UIButton *btn))block;

/**
 *  一句话解决倒计时问题
 *
 *  @param timeLine 倒计时总时间
 *  @param title    还没倒计时Button的title
 *  @param subTitle 倒计时中Button的title
 *  @param mColor   还没倒计时的字体颜色
 *  @param color    倒计时中的字体颜色
 *  @param completBlock 完成回调
 */
- (void)startWithTime:(NSInteger)timeLine
                title:(NSString *)title
       countDownTitle:(NSString *)subTitle
            mainColor:(UIColor *)mColor
           countColor:(UIColor *)color
       countDownBlock:(void(^)(NSInteger countIndex))countDownBlock
         completBlock:(void(^)(void))completBlock;

@end
