//
//  ProfileRouter.h
//  Hpay
//
//  Created by Olgu Sirman on 19/01/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "HPProfileBaseRouter.h"

@protocol ProfileRouterInterface <HPProfileBaseRouterInterface>

- (void)pushWithIdentifierWith:(UIStoryboard *)storyboard withIdentifier:(NSString *)identifier withTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ProfileRouter : HPProfileBaseRouter <ProfileRouterInterface>

@end

NS_ASSUME_NONNULL_END
