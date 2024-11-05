//
//  UIViewController+UserConsent.m
//  Hpay
//
//  Created by Ugur Bozkurt on 25/08/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "UIViewController+UserConsent.h"
#import "TermsConditionsViewController.h"

@implementation UIViewController (UserConsent)

- (void)showUserConsentViewWithDelegate:(id<TermsConditionsViewControllerDelegate>)delegate{
    TermsConditionsViewController *tcVC = (TermsConditionsViewController *) [SB_TsCs instantiateViewControllerWithIdentifier:[TermsConditionsViewController className]];
    tcVC.delegate = delegate;
    tcVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    tcVC.definesPresentationContext = YES;
    tcVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:tcVC animated:NO completion:nil];
}
@end
