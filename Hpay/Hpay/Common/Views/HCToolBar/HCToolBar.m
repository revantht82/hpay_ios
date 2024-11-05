//
//  HCToolBar.m
//  Hpay
//
//  Created by Olgu Sirman on 06/07/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "HCToolBar.h"

@implementation HCToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (instancetype)init {
    self = [self initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)configure {
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedDefault(@"done") style:UIBarButtonItemStyleDone target:self action:@selector(doneAction)];
    [self setItems:@[space, doneBtn]];

}

- (void)doneAction {
    if (self.didToolBarDoneSelected) {
        self.didToolBarDoneSelected();
    }
}

@end
