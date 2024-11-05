//
//  ProfileRouter.m
//  Hpay
//
//  Created by Olgu Sirman on 19/01/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "ProfileRouter.h"

@implementation ProfileRouter

- (void)pushWithIdentifierWith:(UIStoryboard *)storyboard withIdentifier:(NSString *)identifier withTitle:(NSString *)title {
    
    UIViewController *vc;
    if (storyboard) {
        vc = [storyboard instantiateViewControllerWithIdentifier:identifier];
    } else {
        vc = [[NSClassFromString(identifier) alloc] init];
    }

    vc.navigationItem.title = title;
    vc.fd_prefersNavigationBarHidden = NO;
    vc.navigationController.navigationBar.translucent = NO;
    [self pushTo:vc];
}

@end
