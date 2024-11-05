//
//  ScanQRRouter.h
//  Hpay
//
//  Created by Younes Soltan on 24/05/2022.
//  Copyright © 2022 Himalaya. All rights reserved.
//

#import "HPNavigationRouter.h"

NS_ASSUME_NONNULL_BEGIN

@class FPStatementOM;

@protocol ScanQRRouterInterface <HPNavigationRouterDelegate>

- (void)pushToStatementDetailWith:(FPStatementOM *)statementOM;

@end

@interface ScanQRRouter : HPNavigationRouter<ScanQRRouterInterface>

@end

NS_ASSUME_NONNULL_END
