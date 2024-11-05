//
//  UIImage+Extension.h
//  GrandeurCollect
//
//  Created by apple on 2017/7/5.
//  Copyright © 2017年 fiiipay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

- (UIImage *)tintedWithColor:(UIColor *)color;

/**
 修改图片的填充色

 @param color <#color description#>
 @return <#return value description#>
 */
- (UIImage *)gc_imageWithColor:(UIColor *)color;



//- (void)createCircleImageWithColor:(UIColor *)color andSize:(CGSize)size complete:(void(^)(UIImage *image))finishBlock;

+ (UIImage *)createImageWithColor:(UIColor *)color andSize:(CGSize)size;

/**
 * 将UIColor变换为UIImage
 *
 **/
+ (UIImage *)createImageWithColor:(UIColor *)color;


/**
 生成渐变颜色图片
 */
+ (UIImage *)createGradientImageWithFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor;

/**
 *  二维码生成
 *
 *  @param string   内容字符串
 *  @param size 二维码大小
 *  @param color 二维码颜色
 *  @param backGroundColor 背景颜色
 *
 *  @return 返回一张图片
 */
+ (UIImage *)qrImageWithString:(NSString *)string
                          size:(CGSize)size color:(UIColor *)color
               backGroundColor:(UIColor *)backGroundColor;

/**
 *  条形码生成(Third party)
 *
 *  @param code   内容字符串
 *  @param size  条形码大小
 *  @param color 条形码颜色
 *  @param backGroundColor 背景颜色
 *
 *  @return 返回一张图片
 */
+ (UIImage *)generateBarCode:(NSString *)code
                        size:(CGSize)size color:(UIColor *)color
             backGroundColor:(UIColor *)backGroundColor;

+ (UIImage *)imageWithinternationalization:(NSString *)imageName;

/**
 *  压缩图片到指定文件大小
 *
 *  @param image 目标图片
 *  @param size  目标大小（最大值）
 *
 *  @return 返回的图片文件
 */
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;
@end
