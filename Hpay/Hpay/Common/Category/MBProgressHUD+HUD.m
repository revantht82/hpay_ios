//
//  MBProgressHUD+JBHUD.m
//  jiebao
//
//  Created by cheungBoy on 16/8/2.
//  Copyright © 2016年 jiebao. All rights reserved.
//

@implementation MBProgressHUD (HUD)

+ (MBProgressHUD *)showLoadingInView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showInView:view withTitle:nil detailTitle:nil withType:HUDTypeLoading];
    return hud;
}

+ (MBProgressHUD *)showInView:(UIView *)view withTitle:(NSString *)title withType:(HUDType)type; {
    if (title.length == 0 && type != HUDTypeLoading) {
        return nil;
    }
    MBProgressHUD *hud = [MBProgressHUD showInView:view withTitle:title detailTitle:nil withType:type];
    return hud;
}

+ (void)showInView:(UIView *)view withTitle:(NSString *)title {
    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hudView.label.text = title;
    hudView.backgroundView.style = MBProgressHUDBackgroundStyleBlur;
}

+ (MBProgressHUD *)showInView:(UIView *)view withDetailTitle:(NSString *)title withType:(HUDType)type {
    if (title.length == 0 && type != HUDTypeLoading) {
        return nil;
    }
    MBProgressHUD *hud = [MBProgressHUD showInView:view withTitle:nil detailTitle:title withType:type];
    return hud;
}

+ (MBProgressHUD *)showInView:(UIView *)view withTitle:(NSString *)title detailTitle:(NSString *)detailTitle withType:(HUDType)type {

    MBProgressHUD *hudView = [MBHUD HUDForView:view];
    hudView.bezelView.style = MBProgressHUDBackgroundStyleBlur;
    if (hudView && type == HUDTypeLoading) {
        [hudView showAnimated:YES];
        return hudView;
    }
    hudView = [[self alloc] initWithView:view];
    hudView.userInteractionEnabled = NO;
    hudView.removeFromSuperViewOnHide = YES;
    [view addSubview:hudView];
    if (type != HUDTypeLoading) {
        if (type != HUDTypeFailWithoutImage) {
            hudView.mode = MBProgressHUDModeCustomView;
            if (title) {
                hudView.label.text = title;
            }
            if (detailTitle) {
                hudView.detailsLabel.text = detailTitle;
            }
            NSString *imageName = @"";
            if (type == HUDTypeError) {
                imageName = @"xmark.circle";
            } else if (type == HUDTypeWarning) {
                imageName = @"info.circle";
            } else if (type == HUDTypeSuccess) {
                imageName = @"checkmark.circle";
            }
            UIImage *image = [UIImage systemImageNamed:imageName];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.frame = CGRectMake(0, 0, 44, 44);
            hudView.customView = imageView;
        } else {
            hudView.mode = MBProgressHUDModeText;
            if (title) {
                hudView.label.text = title;
            }
            if (detailTitle) {
                hudView.detailsLabel.text = detailTitle;
            }
        }

        [hudView showAnimated:YES];
        [hudView hideAnimated:YES afterDelay:3.0f];
    } else {
        hudView.label.text = title;
        [hudView showAnimated:YES];
    }
    hudView.tag = HUDTag;
    return hudView;
}

+ (void)hideInView:(UIView *)view {
    [MBProgressHUD hideHUDForView:view animated:YES];
}

@end
