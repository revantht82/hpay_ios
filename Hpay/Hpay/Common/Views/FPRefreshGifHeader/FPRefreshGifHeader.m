//
//  FPRefreshGifHeader.m
//  FiiiPay
//
//  Created by apple on 2018/4/12.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "FPRefreshGifHeader.h"

@implementation FPRefreshGifHeader

- (void)prepare {
    [super prepare];
    [self applyTheme];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self applyTheme];
}

-(void)applyTheme{
    id<ThemeProtocol> theme = [self getCurrentTheme];
    self.stateLabel.hidden = YES;
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.textColor = theme.primaryOnBackground;
    self.backgroundColor = theme.background;
    self.tintColor = theme.primaryOnBackground;
}

@end
