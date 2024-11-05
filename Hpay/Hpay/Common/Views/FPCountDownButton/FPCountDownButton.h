//
//  FPCountDownButton.h
//  FiiiPay
//
//  Created by Singer on 2018/4/4.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FPCountDownButton;

typedef NSString *(^CountDownChanging)(FPCountDownButton *countDownButton, NSUInteger second);

typedef NSString *(^CountDownFinished)(FPCountDownButton *countDownButton, NSUInteger second);

typedef void (^TouchedCountDownButtonHandler)(FPCountDownButton *countDownButton, NSInteger tag);

typedef enum : NSUInteger {
    FPCountDownButtonStateNormal,
    FPCountDownButtonStateChanging,
    FPCountDownButtonStateFinished
} FPCountDownButtonState;

@interface FPCountDownButton : UIButton

///倒计时按钮点击回调
- (void)countDownButtonHandler:(TouchedCountDownButtonHandler)touchedCountDownButtonHandler;

//倒计时时间改变回调
- (void)countDownChanging:(CountDownChanging)countDownChanging;

//倒计时结束回调
- (void)countDownFinished:(CountDownFinished)countDownFinished;

///开始倒计时
- (void)startCountDownWithSecond:(NSUInteger)second;

///停止倒计时
- (void)stopCountDown;

@property(nonatomic, assign) FPCountDownButtonState countDownButtonState;
@end
