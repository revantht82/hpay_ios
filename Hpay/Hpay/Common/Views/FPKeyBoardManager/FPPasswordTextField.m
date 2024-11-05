//
//  FPPasswordTextField.m
//  AliyunUploadDemo
//
//  Created by Singer on 2018/3/22.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "FPPasswordTextField.h"
#import "FPPasswordDotCell.h"

@interface FPPasswordTextField () <UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, strong) UICollectionView *collectionView;

@end

@implementation FPPasswordTextField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        self.textColor = [UIColor clearColor];
        self.tintColor = [UIColor clearColor];
        self.font = UIFontMake(0);
        self.borderStyle = UITextBorderStyleNone;
        self.keyboardType = UIKeyboardTypeNumberPad;
        self.secureTextEntry = YES;
        self.enablesReturnKeyAutomatically = YES;
        self.clearsOnBeginEditing = NO;
        UILongPressGestureRecognizer *longRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addGestureRecognizer:)];
        longRecognizer.allowableMovement = 100.0f;
        longRecognizer.minimumPressDuration = 1.0;
        [self addGestureRecognizer:longRecognizer];
        [self addTarget:self action:@selector(textDidChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

- (void)setupUI {
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self);
    }];
}

- (void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    //Prevent zooming but not panning
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        gestureRecognizer.enabled = NO;
    }
    [super addGestureRecognizer:gestureRecognizer];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat h = CGRectGetHeight(self.frame);
    return CGSizeMake(h, h);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FPPasswordDotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FPPasswordDotCell class]) forIndexPath:indexPath];
    UIImage *image;
    if (self.text.length > 0) {
        if (indexPath.item <= self.text.length - 1) {
            image = [UIImage imageNamed:@"pic_pin_input"];
            cell.imageView.tintColor = [self getCurrentTheme].passwordDotFilled;
        } else {
            image = [UIImage imageNamed:@"pic_pin_input_none"];
            cell.imageView.tintColor = [self getCurrentTheme].passwordDot;
        }
    } else {
        image = [UIImage imageNamed:@"pic_pin_input_none"];
        cell.imageView.tintColor = [self getCurrentTheme].passwordDot;
    }
    cell.imageView.image = image;
    return cell;
}

- (void)fp_clear {
    self.text = nil;
    [self.collectionView reloadData];
}

- (void)textDidChanged:(UITextField *)textField {
    [self.collectionView reloadData];
    if (textField.text.length == 6) {
        if (_fp_delegate && [_fp_delegate respondsToSelector:@selector(fp_passwordTextField:didFilledPassword:)]) {
            [_fp_delegate fp_passwordTextField:self didFilledPassword:self.text];
        }
    }
    if (textField.text.length > 6) {
        textField.text = [textField.text substringToIndex:6];
    }
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView registerClass:[FPPasswordDotCell class] forCellWithReuseIdentifier:@"FPPasswordDotCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        layout.minimumInteritemSpacing = 16;
    }
    return _collectionView;
}

@end
