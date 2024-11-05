//
//  UIViewController+Extension.m
//  Hpay
//
//  Created by Ugur Bozkurt on 22/07/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "UIViewController+Extension.h"
#import "VerifyPinViewController.h"
#import "FPNavigationController.h"
#import "NSObject+Extension.h"

@implementation UIViewController (Extension)

- (void)m_addChild:(UIViewController *)child alignment:(Alignment)alignment height:(NSNumber*)height{
    if ([self.view.subviews containsObject:child.view]){
        return;
    }
    
    [self addChildViewController:child];

    [self.view addSubview:child.view];
    
    switch (alignment) {
        case kAlignmentTop:
        {
            [child.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view.mas_top);
                make.leading.equalTo(self.view.mas_leading);
                make.trailing.equalTo(self.view.mas_trailing);
                if (height){
                    make.height.mas_equalTo(height.floatValue);
                }
            }];
            break;
        }
        case kAlignmentBottom:
        {
            [child.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view.mas_bottom);
                make.leading.equalTo(self.view.mas_leading);
                make.trailing.equalTo(self.view.mas_trailing);
                if (height){
                    make.height.mas_equalTo(height.floatValue);
                }
            }];
            break;
            
        }
            
        case kAlignmentFull:
        {
            [child.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            break;
        }
    }
    
    [child didMoveToParentViewController:self];
}

- (void)m_removeChild:(UIViewController *)child{
    [child willMoveToParentViewController:nil];
    [child.view removeFromSuperview];
    [child removeFromParentViewController];
}

- (void)showVerifyPinVC{
    if (![self isShowingVerifyPinViewController]){
        VerifyPinViewController *vc = [[VerifyPinViewController alloc] init];
        FPNavigationController *nav = [[FPNavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:nav animated:NO completion:nil];
    }
}


@end
