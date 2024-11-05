//
//  WebViewRouter.m
//  Hpay
//
//  Created by Olgu Sirman on 19/01/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "WebViewRouter.h"

@implementation WebViewRouter

- (void)presentAlertWith:(NSString *)message completionHandler:(VoidCompletionHandler)completionHandler {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedHome(@"notice") message:message ?: @"" preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:([UIAlertAction actionWithTitle:NSLocalizedProfile(@"confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        completionHandler();
    }])];
    [self present:controller];
}

- (void)presentConfirmedAlertWith:(NSString *)message completionHandler:(void (^)(BOOL))completionHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedHome(@"notice") message:message ?: @"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:NSLocalizedHome(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:NSLocalizedProfile(@"confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        completionHandler(YES);
    }])];
    
    [self present:alertController];
}

@end
