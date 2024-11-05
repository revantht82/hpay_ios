//
//  WebViewRouter.h
//  Hpay
//
//  Created by Olgu Sirman on 19/01/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "HPProfileBaseRouter.h"

typedef void (^VoidCompletionHandler)(void);

@protocol WebViewRouterInterface <HPProfileBaseRouterInterface>

- (void)presentAlertWith:(NSString *)message completionHandler:(VoidCompletionHandler)completionHandler;
- (void)presentConfirmedAlertWith:(NSString *)message completionHandler:(void (^)(BOOL))completionHandler;

@end

NS_ASSUME_NONNULL_BEGIN

@interface WebViewRouter : HPProfileBaseRouter <WebViewRouterInterface>

@end

NS_ASSUME_NONNULL_END
