//
//  StateViewModel.m
//  Hpay
//
//  Created by Ugur Bozkurt on 22/07/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "StateViewModel.h"
#import "NSString+Extension.h"

@implementation StateViewModel
- (instancetype)initWithErrorImage:(UIImage *)errorImage errorTitle:(NSAttributedString *)errorTitle errorMessage:(NSString *)errorMessage{
    self = [super init];
    if (self) {
        _errorImage = errorImage;
        _errorTitle = errorTitle;
        _errorMessage = errorMessage;
    }
    return self;
}

+ (NSString *)refreshButtonTitle{
    return NSLocalizedString(@"refresh", @"");
}

+ (NSString *)retryButtonTitle{
    return NSLocalizedString(@"retry", @"");
}

+ (NSString *)okayButtonTitle{
    return NSLocalizedString(@"okay", @"");
}

+ (NSString *)dismissButtonTitle{
    return NSLocalizedString(@"dismiss", @"");
}

+ (StateViewModel *)networkErrorModel{
    StateViewModel* model = [[StateViewModel alloc] initWithErrorImage:[[UIImage imageNamed:@"ic_no_network"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                                                            errorTitle:[NSLocalizedString(@"pay_merchant_refresh.network_error.title_label", @"") newLineAttributed]
                                                          errorMessage:NSLocalizedString(@"pay_merchant_refresh.network_error.description_label", @"")];
    return model;
}

+ (StateViewModel *)genericApiErrorModel{
    StateViewModel* model = [[StateViewModel alloc] initWithErrorImage:[[UIImage imageNamed:@"icon_error"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                                                            errorTitle:[NSLocalizedString(@"pay_merchant_refresh.backend_error.title_label", @"") attributed]
                                                          errorMessage:NSLocalizedString(@"unexpected_error", @"")];
    return model;
}

+ (StateViewModel *)invalidKYCErrorModel{
    StateViewModel* model = [[StateViewModel alloc] initWithErrorImage:[[UIImage imageNamed:@"icon_error"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                                                            errorTitle:[NSLocalizedString(@"pay_merchant_refresh.backend_error.title_label", @"") attributed]
                                                          errorMessage:NSLocalizedString(@"home.kycIsNotVerified.alertText", @"")];
    return model;
}

+ (StateViewModel *)orderNotFoundErrorModel{
    StateViewModel* model = [[StateViewModel alloc] initWithErrorImage:[[UIImage imageNamed:@"icon_error"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                                                            errorTitle:[NSLocalizedString(@"", @"") attributed]
                                                          errorMessage:NSLocalizedString(@"order_not_found_message", @"")];
    return model;
}

+ (StateViewModel *)kycErrorModel{
    StateViewModel* model = [[StateViewModel alloc] initWithErrorImage:[[UIImage imageNamed:@"ic_tumbleweed"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                                                            errorTitle:[NSLocalizedString(@"home.walletInfo.empty", @"") attributed]
                                                          errorMessage:NSLocalizedString(@"home.kycIsNotVerified.alertText", @"")];
    return model;
}
+ (StateViewModel *)userAccountSuspended{
    StateViewModel* model = [[StateViewModel alloc] initWithErrorImage:[[UIImage imageNamed:@"icon_error"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                                                            errorTitle:[NSLocalizedString(@"pay_merchant_refresh.backend_error.title_label", @"") attributed]
                                                          errorMessage:NSLocalizedString(@"user_account_suspended_message", @"")];
    return model;
}

+ (StateViewModel *)pinAttemptExceeded{
    StateViewModel* model = [[StateViewModel alloc] initWithErrorImage:[[UIImage imageNamed:@"icon_error"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                                                            errorTitle:[NSLocalizedString(@"pay_merchant_refresh.backend_error.title_label", @"") attributed]
                                                          errorMessage:NSLocalizedString(@"pin_attempt_exceeded", @"")];
    return model;
}

@end
