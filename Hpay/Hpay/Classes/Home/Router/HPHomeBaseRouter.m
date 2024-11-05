//
//  HPHomeBaseRouter.m
//  Hpay
//
//  Created by Olgu Sirman on 12/01/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "HPHomeBaseRouter.h"
#import "PaySuccessViewController.h"
#import "HelpFeedbackViewController.h"
#import "GroupSendResultViewController.h"

@implementation HPHomeBaseRouter

- (PaySuccessViewController *)paySuccessViewController {
    PaySuccessViewController *vc = [SB_HOME instantiateViewControllerWithIdentifier:[PaySuccessViewController className]];
    return vc;
}

- (GroupSendResultViewController *)groupSendResultViewController {
    GroupSendResultViewController *vc = [SB_HOME instantiateViewControllerWithIdentifier:[GroupSendResultViewController className]];
    return vc;
}

- (HelpFeedbackViewController *)helpFeedbackViewController {
    HelpFeedbackViewController * vc = [SB_PROFILE instantiateViewControllerWithIdentifier:[HelpFeedbackViewController className]];
    return vc;
}

- (void)presentExchangePaySuccessWithRequest:(struct PresentPaySuccessNavigationRequest)request {
    
    PaySuccessViewController *vc = self.paySuccessViewController;
    vc.pageType = PageSuccessWithExchange;
    NSTimeInterval time = [request.orderDictionary[@"Timestamp"] longLongValue] / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *timeStr = [formatter stringFromDate:date];
    vc.dataDict = @{
        @"OrderNo": request.orderDictionary[@"OrderNo"],
        @"Time": timeStr,
        @"OrderId": request.orderDictionary[@"OrderId"],
        @"CryptoCode": request.selCoinDic[@"CryptoCode"],
        @"Amount": request.amount,
        @"DecimalPlace": request.selCoinDic[@"DecimalPlace"]
    };
    FPNavigationController *nav = [[FPNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.currentControllerDelegate presentViewController:nav animated:YES completion:^{
        [self.navigationDelegate popToRootViewControllerAnimated:NO];
    }];
}

- (void)presentGPayExchangSuccessWithRequest:(struct PresentPaySuccessNavigationRequest)request {
    
    PaySuccessViewController *vc = self.paySuccessViewController;
    vc.pageType = PageSuccessWithGPayExchange;
    NSTimeInterval time = [request.orderDictionary[@"CreationTime"] longLongValue] / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *timeStr = [formatter stringFromDate:date];
    vc.dataDict = @{
        @"OrderNo": request.orderDictionary[@"OrderNo"],
        @"Time": timeStr,
        @"OrderId": request.orderDictionary[@"Id"]
    };
    FPNavigationController *nav = [[FPNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.currentControllerDelegate presentViewController:nav animated:YES completion:^{
        [self.navigationDelegate popToRootViewControllerAnimated:NO];
    }];
    
}

-(void)returnToHomeFromCancellationOfDuplicate{
    
    [self.navigationDelegate popToRootViewControllerAnimated:NO];
}

- (void)presentTransferPaySuccessPageWith:(NSDictionary *_Nonnull)dictionary {
    
    PaySuccessViewController *paySuccessVC = self.paySuccessViewController;
    paySuccessVC.pageType = PageSuccessWithTransfer;
    paySuccessVC.transferDict = dictionary;
    FPNavigationController *nav = [[FPNavigationController alloc] initWithRootViewController:paySuccessVC];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.currentControllerDelegate presentViewController:nav animated:YES completion:^{
        [self.navigationDelegate popToRootViewControllerAnimated:NO];
    }];
    
}

- (void)presentGroupTransferPaySuccessPageWith:(NSDictionary *_Nonnull)dictionary {
    
    GroupSendResultViewController *paySuccessVC = self.groupSendResultViewController;
    paySuccessVC.transferDict = dictionary;
    FPNavigationController *nav = [[FPNavigationController alloc] initWithRootViewController:paySuccessVC];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.currentControllerDelegate presentViewController:nav animated:YES completion:^{
        [self.navigationDelegate popToRootViewControllerAnimated:NO];
    }];
    
}

- (void)presentHelpFeedback {
    HelpFeedbackViewController *vc = self.helpFeedbackViewController;
    FPNavigationController *nav = [[FPNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.currentControllerDelegate presentViewController:nav animated:YES completion:^{
        [self.navigationDelegate popToRootViewControllerAnimated:YES];
    }];
}

- (void)pushToHelpFeedback {
    HelpFeedbackViewController *vc = self.helpFeedbackViewController;
    [self pushTo:vc];
}

@end
