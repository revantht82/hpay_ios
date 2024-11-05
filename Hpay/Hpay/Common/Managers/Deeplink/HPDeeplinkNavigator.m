#import "HPDeeplinkNavigator.h"
#import "HCPayMerchantRouter.h"
#import "AppDelegate.h"
#import "HimalayaAuthManager.h"

@implementation HPDeeplinkNavigator

static HPDeeplinkNavigator *sharedInstance = nil;

// MARK: - Static
+(HPDeeplinkNavigator*)sharedInstance {
    static dispatch_once_t dispatchOnce;

    dispatch_once(&dispatchOnce,^{
        sharedInstance = [[HPDeeplinkNavigator alloc] init];
    });
    return sharedInstance;
}

// MARK: - Instance
-(void)proceedToDeeplinkWithData:(HPDeeplinkData*)data {
    // FIXME: Convert into switch-case.
    //NSLog(@"%@", data.type);
    if (!data.type) return;
        
    if ((DeeplinkType)(data.type.intValue) == Pay) {
        HCPayMerchantRouter *router = [[HCPayMerchantRouter alloc] init];
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        router.currentControllerDelegate = appDelegate.window.rootViewController;
        router.navigationDelegate = appDelegate.window.rootViewController.navigationController;
        router.tabBarControllerDelegate = appDelegate.window.rootViewController.tabBarController;
        [router presentPayMerchantWithOrderId:data.orderId];
    } else if ((DeeplinkType)(data.type.intValue) == RequestPayment) {
        HCPayMerchantRouter *router = [[HCPayMerchantRouter alloc] init];
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        router.currentControllerDelegate = appDelegate.window.rootViewController;
        router.navigationDelegate = appDelegate.window.rootViewController.navigationController;
        router.tabBarControllerDelegate = appDelegate.window.rootViewController.tabBarController;
        [router presentPaymentRequestWithOrderId:data.orderId];
    } else if (data.type.intValue == UserQR) {
        HCPayMerchantRouter *router = [[HCPayMerchantRouter alloc] init];
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        router.currentControllerDelegate = appDelegate.window.rootViewController;
        router.navigationDelegate = appDelegate.window.rootViewController.navigationController;
        router.tabBarControllerDelegate = appDelegate.window.rootViewController.tabBarController;
        [router presentPaymentRequestWithUserHash:data.orderId];
    }
}

@end


