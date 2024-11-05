//
//  NSString+URL.m
//  Hpay
//
//  Created by Olgu Sirman on 31/12/2020.
//  Copyright © 2020 Himalaya. All rights reserved.
//

#import "NSString+URL.h"

@implementation NSString (URL)

- (void)openUrl {
    NSURL *url = [NSURL URLWithString:self];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

+ (void)openSettings {
    [UIApplicationOpenSettingsURLString openUrl];
}

@end
