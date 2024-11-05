//
//  UIViewController+UserConsent.h
//  Hpay
//
//  Created by Ugur Bozkurt on 25/08/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TermsConditionsViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (UserConsent)
- (void)showUserConsentViewWithDelegate:(id<TermsConditionsViewControllerDelegate>)delegate;
@end

NS_ASSUME_NONNULL_END
