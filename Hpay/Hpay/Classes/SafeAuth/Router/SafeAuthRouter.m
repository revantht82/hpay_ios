//
//  SafeAuthRouter.m
//  Hpay
//
//  Created by Olgu Sirman on 23/01/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "SafeAuthRouter.h"
#import "HelpFeedbackViewController.h"

static NSString *const linkCSURL = @"linkCS";

@implementation SafeAuthRouter

- (nonnull HelpFeedbackViewController *)helpFeedbackViewController {
    HelpFeedbackViewController *vc = [SB_PROFILE instantiateViewControllerWithIdentifier:[HelpFeedbackViewController className]];
    return vc;
}

- (void)pushToHelpFeedbackWithURL:(NSURL *)url {
    if ([url.absoluteString isEqualToString:linkCSURL]) {
        [self pushTo:self.helpFeedbackViewController];
    }
}

@end
