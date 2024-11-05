//
//  UIButton+Extension.m
//  GrandeurCollect
//
//  Created by 陈伟鑫 on 2017/7/5.
//  Copyright © 2017年 fiiipay. All rights reserved.
//

static NSString * const kButtonCallBlockKey;

@implementation UIButton (Extension)

@dynamic localizeKey;

- (void)setClickAction:(void(^)(UIButton *btn))block {
    if (block) {
        objc_setAssociatedObject(self, &kButtonCallBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
        [self addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)buttonAction:(UIButton *)btn {
    void(^block)(UIButton *btn) = objc_getAssociatedObject(self, &kButtonCallBlockKey);
    if (block) {
       block(btn);
    }
}

- (void)startWithTime:(NSInteger)timeLine
                title:(NSString *)title
       countDownTitle:(NSString *)subTitle
            mainColor:(UIColor *)mColor
           countColor:(UIColor *)color
       countDownBlock:(void(^)(NSInteger countIndex))countDownBlock
         completBlock:(void(^)(void))completBlock{
    //倒计时时间
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        //倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.selected = YES;
                [self setTitleColor:mColor forState:UIControlStateNormal];
                [self setTitleColor:mColor forState:UIControlStateSelected];
                [self setTitle:title forState:UIControlStateNormal];
                [self setTitle:title forState:UIControlStateSelected];
                self.userInteractionEnabled = YES;
                completBlock();
            });
        }
        else{
            
            int allTime = (int)timeLine + 1;
            int seconds = timeOut % allTime;
            NSString *timeStr = [NSString stringWithFormat:@"%0.2d",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.selected = NO;
                if (countDownBlock) {
                    countDownBlock(seconds);
                }
                [self setTitleColor:color forState:UIControlStateNormal];
                if([kLocaleLanguageCode isEqualToString:@"zh"]) {
                    [self setTitle:[NSString stringWithFormat:@"%@ %@s",subTitle,timeStr] forState:UIControlStateNormal];
                    [self setTitle:[NSString stringWithFormat:@"%@ %@s",subTitle,timeStr] forState:UIControlStateSelected];
                }
                else {
                    [self setTitle:[NSString stringWithFormat:@"%@s %@",timeStr,subTitle] forState:UIControlStateNormal];
                    [self setTitle:[NSString stringWithFormat:@"%@s %@",timeStr,subTitle] forState:UIControlStateSelected];
                    self.titleLabel.adjustsFontSizeToFitWidth = YES;
                }
                
                self.userInteractionEnabled = NO;
                
            });
            timeOut --;
        }
    });
    dispatch_resume(_timer);
}

- (void)setLocalizeKey:(NSString *)localizeKey{
    if (localizeKey.length > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setTitle:NSLocalizedString(localizeKey, nil) forState:UIControlStateNormal];
        });
    }
}
@end
