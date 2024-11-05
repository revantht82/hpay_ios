//
//  ProfileTableViewCell.m
//  FiiiPay
//
//  Created by Singer on 2018/3/27.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "ProfileTableViewCell.h"

@implementation ProfileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self applyTheme];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self applyTheme];
}

- (void)applyTheme{
    self.backgroundColor = [self getCurrentTheme].surface;
    [self.iconImageView setTintAdjustmentMode:(UIViewTintAdjustmentModeNormal)];
    self.iconImageView.tintColor = [UIColor colorNamed:@"mari_gold"];
    self.titleLabel.textColor = [self getCurrentTheme].primaryOnSurface;
    self.rightLabel.textColor = [self getCurrentTheme].secondaryOnSurface;
}

@end
