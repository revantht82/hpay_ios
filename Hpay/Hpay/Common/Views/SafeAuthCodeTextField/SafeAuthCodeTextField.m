//
//  SafeAuthCodeTextField.m
//  FiiiPay
//
//  Created by apple on 2018/5/15.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "SafeAuthCodeTextField.h"
#import "HCToolBar.h"

@interface SafeAuthCodeTextField ()

@property(strong, nonatomic) HCToolBar *toolBar;

@end

@implementation SafeAuthCodeTextField

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configure];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)configure {
    self.inputAccessoryView = self.toolBar;
}

- (HCToolBar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[HCToolBar alloc] init];
        MJWeakSelf
        [_toolBar setDidToolBarDoneSelected:^{
            [weakSelf finishAction];
        }];
    }
    return _toolBar;
}

- (void)finishAction {
    if (self.barDelegate && [self.barDelegate respondsToSelector:@selector(barFinishEvent:)]) {
        [self.barDelegate barFinishEvent:self];
    }
}

@end
