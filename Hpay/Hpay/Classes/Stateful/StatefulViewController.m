//
//  StatefulViewController.m
//  Hpay
//
//  Created by Ugur Bozkurt on 22/07/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "StatefulViewController.h"

@interface StatefulViewController ()
@property(nonatomic) ActionBlock didTapPrimaryButton;
@property(nonatomic) ActionBlock didTapSecondaryButton;
@end

@implementation StatefulViewController

- (void)viewDidLoad {
    [self applyTheme];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self applyTheme];
}

- (void)applyTheme {
    id<ThemeProtocol> theme = self.getCurrentTheme;
    _rootView.backgroundColor = theme.background;
    _errorImageView.tintColor = theme.primaryOnBackground;
    _errorTitleLabel.textColor = theme.primaryOnBackground;
    _errorMessageLabel.textColor = theme.secondaryOnBackground;
    [_primaryButton setBackgroundColor:theme.primaryButton];
    [_secondaryButton setBackgroundColor:theme.secondaryButton];
}

- (void)showLoading{
    [self.activityIndicator setHidden:NO];
    [self.errorViewContainer setHidden:YES];
}

- (void)showErrorWithViewModel:(StateViewModel *)viewModel{
    [self configureWithViewModel:viewModel];
}

- (void)configureWithViewModel:(StateViewModel *)viewModel{
    [self.activityIndicator setHidden:YES];
    [self.errorViewContainer setHidden:NO];
    [self.errorImageView setImage:viewModel.errorImage];
    [self.errorTitleLabel setAttributedText:viewModel.errorTitle];
    [self.errorMessageLabel setText:viewModel.errorMessage];
}

- (void)showPrimaryButtonWithTitle:(NSString *)title show:(BOOL)show didTap:(nullable ActionBlock)block{
    [self.primaryButton setTitle:title.uppercaseString forState:UIControlStateNormal];
    [self.primaryButton setHidden:!show];
    [self setDidTapPrimaryButton:block];
}

- (void)showSecondaryButtonWithTitle:(NSString *)title show:(BOOL)show didTap:(nullable ActionBlock)block{
    [self.secondaryButton setTitle:title.uppercaseString forState:UIControlStateNormal];
    [self.secondaryButton setHidden:!show];
    [self setDidTapSecondaryButton:block];
}

- (IBAction)primaryButtonAction:(id)sender {
    if (self.didTapPrimaryButton) {
        self.didTapPrimaryButton(sender);
    }
}

- (IBAction)secondaryButtonAction:(id)sender {
    if (self.didTapSecondaryButton) {
        self.didTapSecondaryButton(sender);
    }
}

@end
