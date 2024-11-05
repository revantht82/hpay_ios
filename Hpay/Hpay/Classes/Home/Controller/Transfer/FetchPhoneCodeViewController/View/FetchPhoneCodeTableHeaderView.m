//
//  FetchPhoneCodeTableHeaderView.m
//  Hpay
//
//  Created by Olgu Sirman on 10/12/2020.
//  Copyright © 2020 Himalaya. All rights reserved.
//

#import "FetchPhoneCodeTableHeaderView.h"

@interface FetchPhoneCodeTableHeaderView ()

@property(strong, nonnull, nonatomic) NSString *alphabetChar;
@property(strong, nullable, nonatomic) UILabel *letterLabel;

@end

#pragma mark - Constants

static int const kLabelHeight = 12;

@implementation FetchPhoneCodeTableHeaderView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame with:(NSString *)alphabetChar {
    self = [super initWithFrame:frame];
    if (self) {
        self.alphabetChar = alphabetChar;
        [self configureUI];
    }
    return self;
}

- (void)updateConstraints {

    if (_letterLabel) {
        [_letterLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kLabelHeight);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }

    [super updateConstraints];
}

#pragma mark - Properties

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (BOOL)isOpaque {
    return YES;
}

#pragma mark - Helpers

- (void)configureUI {
    self.backgroundColor = [self getCurrentTheme].background;
    [self configureLetterLabel];
}

- (void)configureLetterLabel {
    [self addSubview:self.letterLabel];
    [self.letterLabel setText:self.alphabetChar];
}

#pragma mark - Lazy UI Initialization

- (UILabel *)letterLabel {
    if (!_letterLabel) {
        _letterLabel = [[UILabel alloc] init];
        _letterLabel.font = UIFontMake(14);
        _letterLabel.textColor = kDustyColor;
    }
    return _letterLabel;
}

@end
