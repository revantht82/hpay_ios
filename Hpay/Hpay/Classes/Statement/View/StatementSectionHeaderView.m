//
//  StatementSectionHeaderView.m
//  FiiiPay
//
//  Created by apple on 2018/3/27.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "StatementSectionHeaderView.h"

@implementation StatementSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = kCloudColor;
        [self initUI];
        [self applyTheme];
    }
    return self;
}

- (void)initUI {
    self.backgroundView = [[UIView alloc] init];
    self.backgroundView.frame = CGRectMake(15, 7, 200, 26);
    [self.contentView addSubview:self.backgroundView];
    
    if (self.titleLabel.superview == nil) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.frame = CGRectMake(15, 7, 200, 26);
        self.titleLabel.font = UIFontMake(13);
        self.titleLabel.text = @"";
        [self.contentView addSubview:self.titleLabel];
    }
}

- (void)applyTheme{
    self.backgroundView.backgroundColor = [self getCurrentTheme].background;
    self.titleLabel.textColor = [self getCurrentTheme].primaryOnBackground;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self applyTheme];
}


@end
