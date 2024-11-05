//
//  UIViewController+ViewStateHandling.h
//  Hpay
//
//  Created by Ugur Bozkurt on 28/07/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StateViewModel.h"
#import "StatefulViewController.h"
#import "UIViewController+Extension.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ViewStateHandling)
@property(nonatomic, readonly) StatefulViewController * statefulViewController;
@property(nonatomic, readonly) NSNumber * _Nullable customHeight;
@property(nonatomic, readonly) NSNumber* alignment;

- (void)configureViewStateHandlingWithAlignment:(Alignment)alignment
                                         height:(NSNumber * _Nullable)height;

- (void)showLoadingState;

- (void)hideStatefulViewController;

- (void)showCustomErrorWithViewModel:(StateViewModel*)viewModel
                  primaryButtonTitle: (NSString * _Nullable)primaryButtonTitle
                secondaryButtonTitle: (NSString * _Nullable)secondaryButtonTitle
                 didTapPrimaryButton:(nullable ActionBlock)primaryAction
               didTapSecondaryButton:(nullable ActionBlock)secondaryAction;

- (void)showNetworkErrorWithPrimaryButtonTitle: (NSString * _Nullable)primaryButtonTitle
                          secondaryButtonTitle: (NSString * _Nullable)secondaryButtonTitle
                           didTapPrimaryButton:(nullable ActionBlock)primaryAction
                         didTapSecondaryButton:(nullable ActionBlock)secondaryAction;

- (void)showOrderNotFoundErrorWithPrimaryButtonTitle: (NSString * _Nullable)primaryButtonTitle
                          secondaryButtonTitle: (NSString * _Nullable)secondaryButtonTitle
                           didTapPrimaryButton:(nullable ActionBlock)primaryAction
                         didTapSecondaryButton:(nullable ActionBlock)secondaryAction;

- (void)showGenericApiErrorWithPrimaryButtonTitle: (NSString * _Nullable)primaryButtonTitle
                             secondaryButtonTitle: (NSString * _Nullable)secondaryButtonTitle
                              didTapPrimaryButton:(nullable ActionBlock)primaryAction
                            didTapSecondaryButton:(nullable ActionBlock)secondaryAction;
@end

NS_ASSUME_NONNULL_END
