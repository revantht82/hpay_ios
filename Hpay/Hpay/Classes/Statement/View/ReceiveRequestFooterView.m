//
//  ReceiveRequestFooterView.m
//  Hpay
//
//  Created by Younes Soltan on 23/05/2022.
//  Copyright © 2022 Himalaya. All rights reserved.
//

#import "ReceiveRequestFooterView.h"
#import "FPSecurityAuthManager.h"

@implementation ReceiveRequestFooterView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self applyTheme];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self applyTheme];
}

- (void)applyTheme{
    self.approveButton.backgroundColor = [self getCurrentTheme].primaryButton;
}

@end



