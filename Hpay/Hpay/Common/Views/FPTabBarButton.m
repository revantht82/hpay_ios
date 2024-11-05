//
//  FPTabBarButton.m
//  GiiiPlus
//
//  Created by apple on 2017/8/24.
//
//

#import "FPTabBarButton.h"

#define kImageRatio 0.5

@implementation FPTabBarButton

#pragma mark 返回按钮内部titlelabel的边框

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
//    return CGRectMake(0, contentRect.size.height*kImageRatio-4, contentRect.size.width, contentRect.size.height-contentRect.size.height*kImageRatio - 12);
    return CGRectMake(0, contentRect.size.height * kImageRatio + 5 + 2, contentRect.size.width, contentRect.size.height - contentRect.size.height * kImageRatio - 12);
}

#pragma mark 返回按钮内部UIImage的边框

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
//    return CGRectMake(contentRect.size.width/4, 6, contentRect.size.width/2, contentRect.size.height*kImageRatio/2);
    return CGRectMake(0, 5, contentRect.size.width, contentRect.size.height * kImageRatio);
}

- (void)setHighlighted:(BOOL)highlighted {

}
@end
