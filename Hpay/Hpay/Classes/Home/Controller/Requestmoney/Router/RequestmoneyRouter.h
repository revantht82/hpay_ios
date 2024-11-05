//
//  RequestmoneyRouter.h
//  Hpay
//
//  Created by ONUR YILMAZ on 21/03/2022.
//  Copyright © 2022 Himalaya. All rights reserved.
//

#import "HPHomeBaseRouter.h"

@protocol RequestmoneyRouterInterface <HPHomeBaseRouterInterface>

@end

NS_ASSUME_NONNULL_BEGIN

@interface RequestmoneyRouter : HPHomeBaseRouter <RequestmoneyRouterInterface>

@end

NS_ASSUME_NONNULL_END
