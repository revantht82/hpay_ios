//
//  FPCountDownButton.m
//  FiiiPay
//
//  Created by Singer on 2018/4/4.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "FPCountDownButton.h"

@interface FPCountDownButton () {
    NSInteger _second;
    NSUInteger _totalSecond;

    NSTimer *_timer;
    NSDate *_startDate;

//    CountDownChanging _countDownChanging;
//    CountDownFinished _countDownFinished;
//    TouchedCountDownButtonHandler _touchedCountDownButtonHandler;
}
@property(nonatomic, copy) CountDownChanging countDownChanging;
@property(nonatomic, copy) CountDownFinished countDownFinished;
@property(nonatomic, copy) TouchedCountDownButtonHandler touchedCountDownButtonHandler;
@end

@implementation FPCountDownButton
#pragma -mark touche action

- (void)countDownButtonHandler:(TouchedCountDownButtonHandler)touchedCountDownButtonHandler {
    _touchedCountDownButtonHandler = [touchedCountDownButtonHandler copy];
    [self addTarget:self action:@selector(touched:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)touched:(FPCountDownButton *)sender {
    if (self.touchedCountDownButtonHandler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.touchedCountDownButtonHandler(sender, sender.tag);
        });
    }
}

#pragma -mark count down method

- (NSString *)description
{
    return [NSString stringWithFormat:@"log: <%@: %p>", NSStringFromClass([self class]), self];
}

- (void)startCountDownWithSecond:(NSUInteger)totalSecond {
    _totalSecond = totalSecond;
    _second = totalSecond;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerStart:) userInfo:nil repeats:YES];
    _startDate = [NSDate date];
    _timer.fireDate = [NSDate distantPast];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)timerStart:(NSTimer *)theTimer {
    double deltaTime = [[NSDate date] timeIntervalSinceDate:_startDate];

    _second = _totalSecond - (NSInteger) (deltaTime + 0.5);


    if (_second < 0.0) {
        [self stopCountDown];
    } else {
        if (_countDownChanging) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.countDownButtonState = FPCountDownButtonStateChanging;
                NSString *title = self.countDownChanging(self, self->_second);
                [self setTitle:title forState:UIControlStateNormal];
                [self setTitle:title forState:UIControlStateDisabled];
            });
        } else {
            NSString *title = [NSString stringWithFormat:@"%ld秒", (long) _second];
            [self setTitle:title forState:UIControlStateNormal];
            [self setTitle:title forState:UIControlStateDisabled];

        }
    }
}

- (void)stopCountDown {
    if (_timer) {
        if ([_timer respondsToSelector:@selector(isValid)]) {
            if ([_timer isValid]) {
                [_timer invalidate];
                _second = _totalSecond;
                if (_countDownFinished) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.countDownButtonState = FPCountDownButtonStateFinished;
                        NSString *title = self.countDownFinished(self, self->_totalSecond);
                        [self setTitle:title forState:UIControlStateNormal];
                        [self setTitle:title forState:UIControlStateDisabled];
                    });
                } else {
                    NSString *reacquire = NSLocalizedString(@"Reacquire", @"Reacquire");
                    [self setTitle:reacquire forState:UIControlStateNormal];
                    [self setTitle:reacquire forState:UIControlStateDisabled];
                }
            }
        }
    }
}

#pragma -mark block

- (void)countDownChanging:(CountDownChanging)countDownChanging {
    _countDownChanging = [countDownChanging copy];
}

- (void)countDownFinished:(CountDownFinished)countDownFinished {
    _countDownFinished = [countDownFinished copy];
}
@end
