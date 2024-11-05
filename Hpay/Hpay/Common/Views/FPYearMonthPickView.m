//
//  FPYearMonthPickView.m
//  FiiiPay
//
//  Created by Singer on 2019/11/16.
//  Copyright © 2019 Himalaya. All rights reserved.
//

#import "FPYearMonthPickView.h"
#import "AppDelegate.h"
#import "NTMonthYearPicker.h"

@interface FPYearMonthPickView ()
@property(nonatomic, strong) UIButton *backgrandBtnView;
@property(nonatomic, strong) NSDateFormatter *yearFormatter;
@property(nonatomic, strong) NSDateFormatter *monthFormatter;
@property(nonatomic, strong) NSDateFormatter *dayFormatter;
@property(nonatomic, strong) UIToolbar *pickerToolBar;
@property(nonatomic, strong) UIView *pickerBackgroundView;
@property(nonatomic, strong) UIButton *cancelBtn;
@property(nonatomic, strong) UIButton *doneBtn;
@end

static CGFloat const pickerHeight = 216.0f;
static CGFloat const dimBackgroundAlphaValue = 0.6f;
static NSTimeInterval const animationDuration = 0.25;

@implementation FPYearMonthPickView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.pickerView = [[NTMonthYearPicker alloc] init];
    [self addSubview:self.backgrandBtnView];
    [self addSubview:self.pickerBackgroundView];
    [self addSubview:self.pickerView];
    [self addSubview:self.pickerToolBar];
    
    [self applyTheme];
    [self setNeedsUpdateConstraints];
}

- (void)applyTheme{
    self.pickerView.backgroundColor = [self getCurrentTheme].surface;
    self.pickerView.tintColor = [self getCurrentTheme].primaryOnSurface;
    self.pickerView.datePickerMode = NTMonthYearPickerModeDayMonthAndYear;
    self.pickerView.date = [NSDate date];
    
    UIFont *font14 = UIFontMake(14);
    
    [_cancelBtn setTitle:NSLocalizedHome(@"Cancel") forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[self getCurrentTheme].primaryOnSurface forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = font14;
    
    [_doneBtn setTitle:NSLocalizedHome(@"confirm") forState:UIControlStateNormal];
    [_doneBtn setTitleColor:[self getCurrentTheme].primaryOnSurface forState:UIControlStateNormal];
    _doneBtn.titleLabel.font = font14;
    
    _pickerToolBar.barTintColor = [self getCurrentTheme].surface;
    _pickerToolBar.backgroundColor = [self getCurrentTheme].surface;
    
    _pickerBackgroundView.backgroundColor = [self getCurrentTheme].surface;
    _backgrandBtnView.backgroundColor = UIColorFromRGBA(0x000000, dimBackgroundAlphaValue);
    
    [self setDividerColor];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self applyTheme];
}

- (void)updateConstraints {
        
    [self.backgrandBtnView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.pickerBackgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(pickerHeight);
        make.bottom.equalTo(self).offset(pickerHeight);
    }];
    
    [self.pickerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self).offset(self.pickerPadding);
        make.height.mas_equalTo(pickerHeight);
        make.bottom.equalTo(self).offset(pickerHeight);
    }];
    
    [self.pickerToolBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.pickerView.mas_top);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(44);
    }];
    
    [super updateConstraints];
}

- (void)show {
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

    [appDelegate.window addSubview:self];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(appDelegate.window);
    }];

    [self layoutIfNeeded];
    self.backgrandBtnView.alpha = 0.0;
    [UIView animateWithDuration:animationDuration animations:^{
        
        self.backgrandBtnView.alpha = dimBackgroundAlphaValue;

        [self.pickerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(0);
        }];
        
        [self.pickerBackgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(0);
        }];
        
        [self layoutIfNeeded];
    }                completion:^(BOOL finished) {
        [self setDividerColor];
    }];
}

- (void)setDividerColor{
    for (UIView *speartorView in self.pickerView.subviews) {
        if (speartorView.frame.size.height < 1) {
            speartorView.backgroundColor = [self getCurrentTheme].verticalDivider;//隐藏分割线
        }
    }
}

- (void)hide {
    [UIView animateWithDuration:animationDuration animations:^{
        [self.pickerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(pickerHeight);
        }];
        
        [self.pickerBackgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(pickerHeight);
        }];

        self.backgrandBtnView.alpha = 0.0;
        
        [self layoutIfNeeded];
    }                completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)cancelAction {
    [self hide];
}

- (void)doneAction {
    if (self.doneBlock) {
        NSString *selectedYear = [self.yearFormatter stringFromDate:self.pickerView.date];
        NSString *selectedMonth = [self.monthFormatter stringFromDate:self.pickerView.date];
        NSString *selectedDay = [self.dayFormatter stringFromDate:self.pickerView.date];

        self.doneBlock(selectedYear, selectedMonth, selectedDay);
    }
    [self hide];
}

#pragma mark - Getter Setter

- (UIToolbar *)pickerToolBar {
    if (!_pickerToolBar) {
        _pickerToolBar = [[UIToolbar alloc] init];
        NSMutableArray *barItems = [NSMutableArray array];
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(0, 0, 80, 44);
        [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *cancelBarItem = [[UIBarButtonItem alloc] initWithCustomView:_cancelBtn];
        [barItems addObject:cancelBarItem];

        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [barItems addObject:flexSpace];

        _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _doneBtn.frame = CGRectMake(0, 0, 80, 44);
        [_doneBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithCustomView:_doneBtn];

        [barItems addObject:doneBarItem];
        _pickerToolBar.items = barItems;
    }
    return _pickerToolBar;
}

- (UIButton *)backgrandBtnView {
    if (!_backgrandBtnView) {
        _backgrandBtnView = [UIButton buttonWithType:UIButtonTypeCustom];
        _backgrandBtnView.frame = self.bounds;
        [_backgrandBtnView addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backgrandBtnView;
}

- (UIView *)pickerBackgroundView {
    if (!_pickerBackgroundView) {
        _pickerBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        _pickerBackgroundView.frame = self.bounds;
    }
    return _pickerBackgroundView;
}

- (NSDateFormatter *)yearFormatter {
    if (!_yearFormatter) {
        _yearFormatter = [NSDateFormatter new];
        _yearFormatter.dateFormat = @"yyyy";
    }
    return _yearFormatter;
}

- (NSDateFormatter *)monthFormatter {
    if (!_monthFormatter) {
        _monthFormatter = [NSDateFormatter new];
        _monthFormatter.dateFormat = @"MM";
    }
    return _monthFormatter;
}

- (NSDateFormatter *)dayFormatter {
    if (!_dayFormatter) {
        _dayFormatter = [NSDateFormatter new];
        _dayFormatter.dateFormat = @"dd";
    }
    return _dayFormatter;
}

- (CGFloat)pickerPadding {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGSize pickerSize = [self.pickerView sizeThatFits:CGSizeZero];
    CGFloat pickerPadding = (screenWidth - pickerSize.width) / 2;
    return pickerPadding;
}

@end
