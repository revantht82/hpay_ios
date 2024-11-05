//
//  UITextField+Extension.m
//  GrandeurCollect
//
//  Created by 陈伟鑫 on 2017/7/12.
//  Copyright © 2017年 fiiipay. All rights reserved.
//

static const char LeftImageNameKey;
static const char maxNumberKey;
static const char leftLimitWidthKey;
static const char leftStringKey;
static const char leftLabelTextAligmentKey;
static const char bottomLineKey;
static const char leftLabelFontKey;
static const char leftLabelColorKey;
static const char limitCallBackBlockKey;

@implementation UITextField (Extension)
@dynamic localizeKey;
#pragma mark -- 设置 LeftView 的 Icon
- (void)setLeftImageName:(NSString *)leftImageName {
    objc_setAssociatedObject(self, &LeftImageNameKey, leftImageName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setupLeftImage:leftImageName];
}
- (NSString *)leftImageName {
    return objc_getAssociatedObject(self, &LeftImageNameKey);
}
- (void)setIB_leftImageName:(NSString *)IB_leftImageName {
    self.leftImageName = IB_leftImageName;
}

#pragma mark -- 设置 limitCallBackBlock
- (void)setLimitCallBackBlock:(void ((^)(void)))limitCallBackBlock {
    objc_setAssociatedObject(self, &limitCallBackBlockKey, limitCallBackBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void ((^)(void)))limitCallBackBlock {
    return objc_getAssociatedObject(self, &limitCallBackBlockKey);
}

#pragma mark -- 设置 LeftView 的 String
- (void)setLeftString:(NSString *)leftString {
    objc_setAssociatedObject(self, &leftStringKey, leftString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setupLeftString:leftString];
}
- (NSString *)leftString {
    return objc_getAssociatedObject(self, &leftStringKey);
}
- (void)setIB_leftString:(NSString *)IB_leftString {
}

#pragma mark -- 设置 LeftLabel 的 对齐方式
- (void)setLeftLabel_textAligment:(NSTextAlignment)leftLabel_textAligment {
    objc_setAssociatedObject(self, &leftLabelTextAligmentKey, @(leftLabel_textAligment), OBJC_ASSOCIATION_RETAIN);
    UILabel *label;
    if (self.leftView.subviews.count > 0) {
        if ([self.leftView.subviews[0] isKindOfClass:[UILabel class]]) {
            label = self.leftView.subviews[0];
            label.textAlignment = leftLabel_textAligment;
        }
    }
}
- (NSTextAlignment)leftLabel_textAligment {
    return [objc_getAssociatedObject(self, &leftLabelTextAligmentKey) integerValue];
}

#pragma mark -- 设置 LeftLabel 的 字体
- (void)setLeftLabelFont:(UIFont *)leftLabelFont {
    objc_setAssociatedObject(self, &leftLabelFontKey, leftLabelFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    UILabel *label;
    if (self.leftView.subviews.count > 0) {
        if ([self.leftView.subviews[0] isKindOfClass:[UILabel class]]) {
            label = self.leftView.subviews[0];
            label.font = leftLabelFont;
        }
    }
}
- (UIFont *)leftLabelFont {
    return objc_getAssociatedObject(self, &leftLabelFontKey);
}

#pragma mark -- 设置 LeftLabel 的 字体颜色
- (void)setLeftLabelColor:(UIColor *)leftLabelColor {
    objc_setAssociatedObject(self, &leftLabelColorKey, leftLabelColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    UILabel *label;
    if (self.leftView.subviews.count > 0) {
        if ([self.leftView.subviews[0] isKindOfClass:[UILabel class]]) {
            label = self.leftView.subviews[0];
            label.textColor = leftLabelColor;
        }
    }
}
- (UIColor *)leftLabelColor {
    return objc_getAssociatedObject(self, &leftLabelColorKey);
}
#pragma mark -- 设置 LeftView 的最大宽度
- (void)setLeftLimitWidth:(CGFloat)leftLimitWidth {
    objc_setAssociatedObject(self, &leftLimitWidthKey, @(leftLimitWidth), OBJC_ASSOCIATION_RETAIN);
    CGRect rect = self.leftView.frame;
    rect.size.width = leftLimitWidth;
    self.leftView.frame = rect;
}
- (void)setIB_leftLimitWidth:(CGFloat)IB_leftLimitWidth {
    self.leftLimitWidth = IB_leftLimitWidth;
}
- (CGFloat)leftLimitWidth {
    return [objc_getAssociatedObject(self, &leftLimitWidthKey)floatValue];
}

#pragma mark -- 设置 TextField 的最大限制字数
- (void)setMaxNumber:(NSInteger)maxNumber {
    objc_setAssociatedObject(self, &maxNumberKey, @(maxNumber), OBJC_ASSOCIATION_RETAIN);
    [self setupMaxNumber:maxNumber];
}
- (NSInteger)maxNumber {
    return [objc_getAssociatedObject(self, &maxNumberKey) integerValue];
}
- (void)setIB_maxNumber:(NSInteger)IB_maxNumber {
    self.maxNumber = IB_maxNumber;
}

#pragma mark -- 设置下划线
- (void)setIsAddBottomLine:(BOOL)isAddBottomLine {
    objc_setAssociatedObject(self, &bottomLineKey, @(isAddBottomLine), OBJC_ASSOCIATION_RETAIN);
    if (isAddBottomLine) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kCloudColor;
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
    }
}
- (BOOL)isAddBottomLine {
    return [objc_getAssociatedObject(self, &bottomLineKey) boolValue];
}
- (void)setIB_isAddBottomLine:(BOOL)IB_isAddBottomLine {
    self.isAddBottomLine = IB_isAddBottomLine;
}


#pragma mark -- 判断TextField是否为空
- (BOOL)textIsEmpty{
    NSString *str = self.text;
    if (!str) {
        return true;
    } else {
        
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}

#pragma mark -- TextField抖动动画
- (void)textEmpeyAnimation{
    if ([self textIsEmpty]) {
        self.text = nil;
        [self showWarningAnimation];
        [self resignFirstResponder];
    }
    
}

- (void)setupLeftImage:(NSString *)imageName {
    CGFloat width = self.leftLimitWidth ? self.leftLimitWidth : 44;
    self.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, self.bounds.size.height)];
    self.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.leftView.bounds];
    imageView.image = [UIImage imageNamed:imageName];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.leftView addSubview:imageView];
}

- (void)setupLeftString:(NSString *)string {
    CGFloat width = self.leftLimitWidth ? self.leftLimitWidth : 90;
    CGFloat height = self.bounds.size.height > 0 ? self.bounds.size.height : 44;
    self.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    self.leftViewMode = UITextFieldViewModeAlways;
    UILabel *label;
    if (self.leftView.subviews.count > 0) {
        if ([self.leftView.subviews[0] isKindOfClass:[UILabel class]]) {
            label = self.leftView.subviews[0];
            label.text = string;
            return;
        }
    }

    label = [[UILabel alloc]initWithFrame:self.leftView.bounds];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = UIFontMake(15);
    label.textColor = kDarkNightColor;
    label.text = string;
    [self.leftView addSubview:label];
    
}

- (void)setupMaxNumber:(NSInteger)maxNumber {
    [self addTarget:self action:@selector(textfieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
- (void)textfieldDidChange:(UITextField *)textfield{
    if (self == textfield) {
        if (textfield.text.length > self.maxNumber) {
            textfield.text = [textfield.text substringToIndex:self.maxNumber];
            if (self.limitCallBackBlock) {
                self.limitCallBackBlock();
            }
            //[self resignFirstResponder];
        }
    }
}


- (void)showWarningAnimation{
    //关键帧动画
    CAKeyframeAnimation *animatiionKey = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animatiionKey setDuration:0.5f];
    NSArray *array = @[[NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
            [NSValue valueWithCGPoint:CGPointMake(self.center.x - 5, self.center.y)],
            [NSValue valueWithCGPoint:CGPointMake(self.center.x + 5, self.center.y)],
            [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
            [NSValue valueWithCGPoint:CGPointMake(self.center.x - 5, self.center.y)],
            [NSValue valueWithCGPoint:CGPointMake(self.center.x + 5, self.center.y)],
            [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
            [NSValue valueWithCGPoint:CGPointMake(self.center.x - 5, self.center.y)],
            [NSValue valueWithCGPoint:CGPointMake(self.center.x + 5, self.center.y)],
            [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)]];
    
    [animatiionKey setValues:array];
    
    NSArray *times = [[NSArray alloc] initWithObjects:
            @0.1f,
            @0.2f,
            @0.3f,
            @0.4f,
            @0.5f,
            @0.6f,
            @0.7f,
            @0.8f,
            @0.9f,
            @1.0f, nil];
    
    [animatiionKey setKeyTimes:times];
    
    [self.layer addAnimation:animatiionKey forKey:@"ViewShake"];
}

-(void)setLocalizeKey:(NSString *)localizeKey{
    if (localizeKey.length > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.placeholder = NSLocalizedString(localizeKey, nil);
        });
    }
}
@end

