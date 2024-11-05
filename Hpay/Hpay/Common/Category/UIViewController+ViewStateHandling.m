//
//  UIViewController+ViewStateHandling.m
//  Hpay
//
//  Created by Ugur Bozkurt on 28/07/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "UIViewController+ViewStateHandling.h"
#import <objc/runtime.h>

@implementation UIViewController (ViewStateHandling)

/// Key for association. no need to set a value. only its address will be used.
static char statefulViewControllerKey, heightKey, alignmentKey;

- (NSNumber * _Nullable)customHeight{
    return objc_getAssociatedObject(self, &heightKey);
}

- (NSNumber *)alignment{
    return objc_getAssociatedObject(self, &alignmentKey);
}

- (StatefulViewController *)statefulViewController{
    return objc_getAssociatedObject(self, &statefulViewControllerKey);
}

- (void)configureViewStateHandlingWithAlignment:(Alignment)alignment
                                         height:(NSNumber * _Nullable)height{
    objc_setAssociatedObject(self,
                             &statefulViewControllerKey,
                             [[StatefulViewController alloc] init],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self,
                             &heightKey,
                             height,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self,
                             &alignmentKey,
                             @(alignment),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showLoadingState{
    [self addChildIfNeeded];
    [self.statefulViewController showLoading];;
}

- (void)hideStatefulViewController{
    if (self.statefulViewController){
        [self m_removeChild:self.statefulViewController];
    }
}

- (void)showNetworkErrorWithPrimaryButtonTitle:(NSString *)primaryButtonTitle
                          secondaryButtonTitle:(NSString *)secondaryButtonTitle
                           didTapPrimaryButton:(nullable ActionBlock)primaryAction
                         didTapSecondaryButton:(nullable ActionBlock)secondaryAction{
    [self showCustomErrorWithViewModel:StateViewModel.networkErrorModel
                    primaryButtonTitle:primaryButtonTitle
                  secondaryButtonTitle:secondaryButtonTitle
                   didTapPrimaryButton:primaryAction
                 didTapSecondaryButton:secondaryAction];
}

- (void)showOrderNotFoundErrorWithPrimaryButtonTitle:(NSString *)primaryButtonTitle
                          secondaryButtonTitle:(NSString *)secondaryButtonTitle
                           didTapPrimaryButton:(nullable ActionBlock)primaryAction
                         didTapSecondaryButton:(nullable ActionBlock)secondaryAction{
    [self showCustomErrorWithViewModel:StateViewModel.orderNotFoundErrorModel
                    primaryButtonTitle:primaryButtonTitle
                  secondaryButtonTitle:secondaryButtonTitle
                   didTapPrimaryButton:primaryAction
                 didTapSecondaryButton:secondaryAction];
}

- (void)showGenericApiErrorWithPrimaryButtonTitle:(NSString *)primaryButtonTitle
                             secondaryButtonTitle:(NSString *)secondaryButtonTitle
                              didTapPrimaryButton:(nullable ActionBlock)primaryAction
                            didTapSecondaryButton:(nullable ActionBlock)secondaryAction{
    [self showCustomErrorWithViewModel:StateViewModel.genericApiErrorModel
                    primaryButtonTitle:primaryButtonTitle
                  secondaryButtonTitle:secondaryButtonTitle
                   didTapPrimaryButton:primaryAction
                 didTapSecondaryButton:secondaryAction];
}

- (void)showCustomErrorWithViewModel:(StateViewModel *)viewModel
                  primaryButtonTitle:(NSString *)primaryButtonTitle
                secondaryButtonTitle:(NSString *)secondaryButtonTitle
                 didTapPrimaryButton:(nullable ActionBlock)primaryAction
               didTapSecondaryButton:(nullable ActionBlock)secondaryAction{
    [self addChildIfNeeded];
    [self.statefulViewController showPrimaryButtonWithTitle:primaryButtonTitle
                                                       show:primaryButtonTitle?YES:NO
                                                     didTap:primaryAction];
    [self.statefulViewController showSecondaryButtonWithTitle:secondaryButtonTitle
                                                         show:secondaryButtonTitle?YES:NO
                                                       didTap:secondaryAction];
    [self.statefulViewController showErrorWithViewModel:viewModel];
}

- (void)addChildIfNeeded{
    [self m_addChild:self.statefulViewController
           alignment:(Alignment)self.alignment.intValue
              height:self.customHeight];
}

@end
