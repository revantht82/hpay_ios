//
//  PaySuccessRouter.m
//  Hpay
//
//  Created by Olgu Sirman on 13/01/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "PaySuccessRouter.h"
#import "StatementDetailViewController.h"
#import "FPOrderDetailModel.h"

@implementation PaySuccessRouter

- (StatementDetailViewController *)statementDetailViewController {
    StatementDetailViewController *vc = [SB_STATEMENT instantiateViewControllerWithIdentifier:[StatementDetailViewController className]];
    return vc;
}

- (void)pushToStatementDetailWith:(enum PageSuccess)pageType
                 withWithdrawDict:(NSDictionary *)withdrawDict
                 withTransferDict:(NSDictionary *)transferDict
                     withDataDict:(NSDictionary *)dataDict
                  withOrderDetail:(FPOrderDetailModel *)orderDetailModel {
    
    if (pageType == PageSuccessWithdrawalApply) {
        StatementDetailViewController *vc = self.statementDetailViewController;
        [vc configWithType:StatementListTypeWithdraw andId:withdrawDict[@"OrderId"] andUrl:WithdrawDetailURL];
        vc.title = NSLocalizedCommon(@"withdrawal_details");
        vc.actionResult = ActionResultVCFromWithdrawal;
        [self pushTo:vc];
    } else if (pageType == PageSuccessWithTransfer && transferDict) {
        StatementDetailViewController *detailVC = self.statementDetailViewController;
        detailVC.title = NSLocalizedCommon(@"transfer_details");
        [detailVC configWithType:StatementListTypeTransferOut
                           andId:[transferDict valueForKey:@"OrderId"] andUrl:TransferDetailURL];
        detailVC.actionResult = ActionResultVCFromTransfer;
        [self pushTo:detailVC];
    } else if (pageType == PageSuccessWithExchange && dataDict[@"OrderId"]) {
        StatementDetailViewController *detailVC = self.statementDetailViewController;
        detailVC.title = NSLocalizedCommon(@"transfer_details");
        [detailVC configWithType:StatementListTypeHuazhuanOut
                           andId:dataDict[@"OrderId"] andUrl:HuaZhuanDetailURL];
        detailVC.actionResult = ActionResultVCFromExchange;
        [self pushTo:detailVC];
    } else if (pageType == PageSuccessPay && orderDetailModel && orderDetailModel.OrderId) {
        StatementListType type = StatementListTypePay;
        NSString *url = OrderDetailURL;
        StatementDetailViewController *detailVC = self.statementDetailViewController;
        [detailVC configWithType:type andId:orderDetailModel.OrderId andUrl:url];
        detailVC.title = NSLocalizedCommon(@"transaction_details");
        detailVC.actionResult = ActionResultVCFromPay;
        [self pushTo:detailVC];
    } else if (pageType == PageSuccessWithGPayExchange) {
        
        StatementListType type = StatementListTypeGPayExchangeOut;
        NSString *url = FastExchangDetailURL;
        StatementDetailViewController *detailVC = self.statementDetailViewController;
        [detailVC configWithType:type andId:dataDict[@"OrderId"] andUrl:url];
        [self pushTo:detailVC];
    } else if (pageType == PageSuccessWithGatewayOrder) {
        StatementListType type = StatementListTypeGatewayOrderOutcome;
        NSString *url = GatewayOrderOutcomeDetailURL;
        StatementDetailViewController *detailVC = self.statementDetailViewController;
        [detailVC configWithType:type andId:orderDetailModel.OrderId andUrl:url];
        [self pushTo:detailVC];
    } else if (pageType == PageSuccessWithRequestFund) {
        StatementListType type = StatementListInvalid;
        NSString *url = RequestFundDetailURL;
        NSString *orderId = dataDict[@"OrderId"];
        StatementDetailViewController *detailVC = self.statementDetailViewController;
        [detailVC configWithType:type andId:orderId andUrl:url];
        [self pushTo:detailVC];
    }
}

@end
