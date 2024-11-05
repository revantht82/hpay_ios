//
//  HuaZhuanRouter.h
//  Hpay
//
//  Created by Olgu Sirman on 12/01/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "HPHomeBaseRouter.h"

@protocol HuaZhuanRouterInterface <HPHomeBaseRouterInterface>

@end

NS_ASSUME_NONNULL_BEGIN

@interface HuaZhuanRouter : HPHomeBaseRouter <HuaZhuanRouterInterface>

@end

NS_ASSUME_NONNULL_END
