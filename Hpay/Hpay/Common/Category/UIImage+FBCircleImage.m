//
//  UIImage+FBCircleImage.m
//  FiBi
//
//  Created by apple on 2018/1/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "UIImage+FBCircleImage.h"
//#import <objc/message.h>

@implementation UIImage (FBCircleImage)

- (UIImage *)fbCreateCircleImageWithColor:(UIColor *)color andSize:(CGSize)size
{
    return  [self createCircleImageWithColor:color andSize:size];
}

//- (void)setCircleImage:(UIImage *)circleImage
//{
//    objc_setAssociatedObject(self, @"circleImage", circleImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (UIImage *)circleImage
//{
//    return objc_getAssociatedObject(self, @"circleImage");
//}

- (UIImage *)createCircleImageWithColor:(UIColor *)color andSize:(CGSize)size
{
    //default color is white default size : width = 1, height = 1
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    //1. 开始图形上下文
    UIGraphicsBeginImageContext(size);
    //2. 设置颜色
    [color setFill];
    //3. 颜色填充
    UIRectFill(rect);
    //圆形裁切
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    [path addClip];
    [self drawInRect:rect];
    //4. 从图形上下文获取图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    //5. 关闭图形上下文
    UIGraphicsEndImageContext();
    return img;
}
@end
