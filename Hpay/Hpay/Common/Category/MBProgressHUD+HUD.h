//
//  MBProgressHUD+JBHUD.h
//  jiebao
//
//  Created by cheungBoy on 16/8/2.
//  Copyright © 2016年 jiebao. All rights reserved.
//

#import "MBProgressHUD.h"

#define HUDTag 123321

typedef NS_ENUM(NSInteger, HUDType) {
    HUDTypeLoading,
    HUDTypeSuccess,
    HUDTypeError,
    HUDTypeWarning,
    HUDTypeFailWithoutImage
};


@interface MBProgressHUD (HUD)
+ (MBProgressHUD *)showLoadingInView:(UIView *)view;

+ (MBProgressHUD *)showInView:(UIView *)view withTitle:(NSString *)title detailTitle:(NSString *)detailTitle withType:(HUDType)type;

+ (MBProgressHUD *)showInView:(UIView *)view withTitle:(NSString *)title withType:(HUDType)type;

+ (MBProgressHUD *)showInView:(UIView *)view withDetailTitle:(NSString *)title withType:(HUDType)type;

+ (void)hideInView:(UIView *)view;

@end
