//
//  ScanQRRouter.m
//  Hpay
//
//  Created by Younes Soltan on 24/05/2022.
//  Copyright © 2022 Himalaya. All rights reserved.
//

#import "ScanQRRouter.h"
#import "StatementDetailViewController.h"
#import "FPStatementOM.h"
#import "FPUtils.h"

@implementation ScanQRRouter

- (nonnull StatementDetailViewController *)statementDetailViewController {
    StatementDetailViewController *vc = [SB_STATEMENT instantiateViewControllerWithIdentifier:[StatementDetailViewController className]];
    return vc;
}

- (void)pushToStatementDetailWith:(FPStatementOM *)statementOM {
    StatementDetailViewController *vc = self.statementDetailViewController;
    StatementListType cType = StatementListInvalid;
    NSString *url = RequestFundRetriveURL;
    [vc configWithType:cType andId:statementOM.OrderId andUrl:url];
    [self pushTo:vc];
}

@end
