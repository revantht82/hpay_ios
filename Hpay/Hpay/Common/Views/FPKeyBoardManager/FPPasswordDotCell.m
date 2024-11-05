//
//  FPPasswordDotCell.m
//  AliyunUploadDemo
//
//  Created by Singer on 2018/3/22.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "FPPasswordDotCell.h"

@implementation FPPasswordDotCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [UIImageView new];
        [self.contentView addSubview:_imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.contentView.bounds;
}

@end
