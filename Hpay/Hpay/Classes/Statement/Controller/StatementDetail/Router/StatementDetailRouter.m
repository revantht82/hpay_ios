#import "StatementDetailRouter.h"
#import "PaySuccessViewController.h"

@implementation StatementDetailRouter

-(void)pushToPaymentSuccessfulWith:(NSDictionary*)orderDictionary {

    PaySuccessViewController *paySuccessViewController = [SB_HOME instantiateViewControllerWithIdentifier:[PaySuccessViewController className]];
    
    paySuccessViewController.pageType = PageSuccessWithRequestFund;
    paySuccessViewController.dataDict = orderDictionary;
    FPNavigationController *nav = [[FPNavigationController alloc] initWithRootViewController:paySuccessViewController];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.currentControllerDelegate presentViewController:nav animated:YES completion:^{
        [self.navigationDelegate popToRootViewControllerAnimated:NO];
    }];
}

@end
