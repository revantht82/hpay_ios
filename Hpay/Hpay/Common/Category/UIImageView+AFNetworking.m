//
//  UIImageView+AFNetworking.m
//  Hpay
//
//  Created by Venkatesh Mandapthi on 23/11/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "UIImageView+AFNetworking.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation UIImageView (AFNetworking)

- (UIImage *)extractTintImage:(UIImage * _Nonnull)image forTintColor:(UIColor * _Nonnull)tintColor {
    UIImage *newImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIGraphicsBeginImageContextWithOptions(image.size, NO, newImage.scale);
    [tintColor set];
    [newImage drawInRect:CGRectMake(0, 0, image.size.width, newImage.size.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)setImageWithURLRequestImage:(NSString *)url withTintColor:(UIColor *)tintColor{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];

    WS(weakSelf)
    [self setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {

        UIImage * tintImage = [weakSelf extractTintImage:image forTintColor:tintColor];
        weakSelf.image = tintImage;
    } failure:nil];
}
@end

