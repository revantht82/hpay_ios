//
//  PaySuccessRouter.h
//  Hpay
//
//  Created by Olgu Sirman on 13/01/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "HPHomeBaseRouter.h"
#import "PaySuccessPageType.h"

@class FPOrderDetailModel;

@protocol PaySuccessRouterInterface <HPHomeBaseRouterInterface>

- (void)pushToStatementDetailWith:(enum PageSuccess)pageType
                 withWithdrawDict:(NSDictionary *)withdrawDict
                 withTransferDict:(NSDictionary *)transferDict
                     withDataDict:(NSDictionary *)dataDict
                  withOrderDetail:(FPOrderDetailModel *)orderDetailModel;

@end

NS_ASSUME_NONNULL_BEGIN

@interface PaySuccessRouter : HPHomeBaseRouter <PaySuccessRouterInterface>

@end

NS_ASSUME_NONNULL_END
