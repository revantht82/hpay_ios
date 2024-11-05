//
//  HomeLoginView.m
//  Hpay
//
//  Created by Ugur Bozkurt on 21/07/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "HomeLoginView.h"

@implementation HomeLoginView

@synthesize delegate;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self setupUI];
}

- (void) setupUI{
    self.backgroundColor = [self getCurrentTheme].surface;
    self.clipsToBounds = YES;
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = kDarkNightColor.CGColor;
    self.layer.shadowOffset = CGSizeMake(0, -10);
    self.layer.shadowOpacity = 0.05;
    self.layer.shadowRadius = 6;
    self.layer.cornerRadius = 24;
    self.layer.maskedCorners = UIRectCornerTopLeft | UIRectCornerTopRight;
    
    NSString *titleLine1 = NSLocalizedString(@"non_user_popup_title_line_1", @"No logged in user popup title first line (black colour)");
    NSString *titleLine2 = NSLocalizedString(@"non_user_popup_title_line_2", @"No logged in user popup title second line (marigold colour)");
    NSString *title = [NSString stringWithFormat:@"%@\n%@", titleLine1, titleLine2];
    NSString *description = [NSString stringWithFormat:@"\n\n%@", NSLocalizedString(@"non_user_popup_description", @"No logged in user popup description (grey colour)")];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:title attributes:@{
        NSForegroundColorAttributeName: [self getCurrentTheme].background
    }];
    
    NSRange line1Range = [attributedText.string rangeOfString:titleLine1];
    [attributedText addAttributes:@{NSFontAttributeName: UIFontLightMake(32), NSForegroundColorAttributeName: [self getCurrentTheme].primaryOnSurface} range:line1Range];
    
    NSRange line2Range = [attributedText.string rangeOfString:titleLine2];
    [attributedText addAttributes:@{NSFontAttributeName: UIFontBoldMake(32), NSForegroundColorAttributeName: kMarigoldColor} range:line2Range];
    NSAttributedString *attributedDescription = [[NSAttributedString alloc] initWithString:description attributes:@{
        NSFontAttributeName: [UIFont systemFontOfSize:14 weight:UIFontWeightMedium], NSForegroundColorAttributeName: [self getCurrentTheme].secondaryOnSurface
    }];
    
    [attributedText appendAttributedString:attributedDescription];
    
    UILabel *labelDescription = [UILabel new];
    labelDescription.numberOfLines = 0;
    labelDescription.textAlignment = NSTextAlignmentCenter;
    labelDescription.lineBreakMode = NSLineBreakByWordWrapping;
    labelDescription.attributedText = attributedText;
    [self addSubview:labelDescription];
    [labelDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.right.mas_equalTo(-24);
        make.top.mas_equalTo(50);
    }];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [loginBtn setTitle:NSLocalizedString(@"please_login", @"登录后查看") forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateNormal];
    [self addSubview:loginBtn];
    loginBtn.titleLabel.font = UIFontMake(14);
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.equalTo(labelDescription);
        make.right.equalTo(labelDescription);
    }];
    [loginBtn addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void) loginButtonAction{
    if ([self.delegate respondsToSelector:@selector(didLoginTap)]) {
        [self.delegate didLoginTap];
    }
}

@end
