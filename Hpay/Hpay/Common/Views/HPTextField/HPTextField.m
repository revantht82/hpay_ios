//
//  HPTextField.m
//  Hpay
//
//  Created by Olgu Sirman on 29/12/2020.
//  Copyright © 2020 Himalaya. All rights reserved.
//

#import "HPTextField.h"

@implementation HPTextField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

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


-(void)awakeFromNib {
    [super awakeFromNib];
    [self configure];
}

- (instancetype)initWithDisablePaste:(BOOL)disablePaste {
    self = [self init];
    if (self) {
        self.disablePaste = disablePaste;
    }
    return self;
}

-(void)setDisableCopy:(BOOL)disableCopy {
    _disableCopy = disableCopy;
    self.disableMenuController = disableCopy && self.disablePaste;
    
}

-(void)setDisablePaste:(BOOL)disablePaste {
    _disablePaste = disablePaste;
    self.disableMenuController = disablePaste && self.disableCopy;
    
}

- (void)configure {
    self.disableMenuController = YES;
    self.disablePaste = YES;
    self.disableCopy = YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {

    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (self.disableMenuController) {
            [[UIMenuController sharedMenuController] setMenuVisible:!self.disableMenuController animated:NO];
        }
    }];

    if (action == @selector(paste:)) return !self.disablePaste;
    if (action == @selector(copy:)) return !self.disableCopy;
    if (action == @selector(cut:)) return NO;
    if (action == @selector(select:)) return NO;
    if (action == @selector(selectAll:)) return NO;
    if (action == @selector(share)) return NO;
    return [super canPerformAction:action withSender:sender];
}

@end
