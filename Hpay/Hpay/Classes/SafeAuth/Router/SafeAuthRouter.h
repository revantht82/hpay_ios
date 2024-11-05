//
//  SafeAuthRouter.h
//  Hpay
//
//  Created by Olgu Sirman on 23/01/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "HPNavigationRouter.h"

@protocol SafeAuthRouterInterface <HPNavigationRouterDelegate>

- (void)pushToHelpFeedbackWithURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_BEGIN

@interface SafeAuthRouter : HPNavigationRouter <SafeAuthRouterInterface>

@end

NS_ASSUME_NONNULL_END
