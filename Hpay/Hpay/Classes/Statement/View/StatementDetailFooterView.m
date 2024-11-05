//
//  StatementDetailFooterView.m
//  FiiiPay
//
//  Created by apple on 2018/3/27.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "StatementDetailFooterView.h"

@implementation StatementDetailFooterView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self applyTheme];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [self applyTheme];
}

- (void)applyTheme {
    self.viewQRButton.backgroundColor = [self getCurrentTheme].primaryButton;
}

@end
