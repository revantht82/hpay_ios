//
//  StatefulViewController.h
//  Hpay
//
//  Created by Ugur Bozkurt on 22/07/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StateViewModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ActionBlock)(id sender);

@interface StatefulViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *errorViewContainer;
@property (weak, nonatomic) IBOutlet UIImageView *errorImageView;
@property (weak, nonatomic) IBOutlet UILabel *errorTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorMessageLabel;
@property (weak, nonatomic) IBOutlet UIButton *primaryButton;
@property (weak, nonatomic) IBOutlet UIButton *secondaryButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIView *rootView;
@property (weak, nonatomic) IBOutlet UIView *networkView;

- (void) showLoading;

- (void) showErrorWithViewModel:(StateViewModel*)viewModel;

- (void) showPrimaryButtonWithTitle: (NSString* __nullable)title show: (BOOL)show didTap:(nullable ActionBlock)block;

- (void) showSecondaryButtonWithTitle: (NSString* __nullable) title show: (BOOL)show didTap:(nullable ActionBlock)block;

@end

NS_ASSUME_NONNULL_END
