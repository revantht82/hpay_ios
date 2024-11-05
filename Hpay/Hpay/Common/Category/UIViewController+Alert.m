//
//  UIViewController+Alert.m
//  Hpay
//
//  Created by Ugur Bozkurt on 03/08/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "UIViewController+Alert.h"
#import "NSString+Extension.h"

@implementation UIViewController (Alert)

- (void)showUserNotAllowedAlertWithHandler:(AlertActionItemHandler)handler alertMessage:(NSString *)alertMessage{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"got_it", @"")
                                                            style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        handler();
    }];
    [alertController addAction:dismissAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showKycAlert{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:NSLocalizedDefault(@"home.kycIsNotVerified.alertText")
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:NSLocalizedDefault(@"got_it")
                                                            style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:dismissAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray<AlertActionItem *> *)actions{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    for (AlertActionItem* item in actions) {
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:item.title
                                                              style:item.style
                                                            handler:^(UIAlertAction * _Nonnull action) {
            if (item.handler){
                item.handler();
            }
        }];
        [alertController addAction:alertAction];
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showAlertForUnknownError{
    [self showAlertWithTitle:@""
                     message:NSLocalizedString(@"Unexpected error has occurred.", @"")
                     actions:[NSArray arrayWithObjects:[AlertActionItem defaultDismissItem], nil]];
}

- (void)showAlertForNetworkError{
    [self showAlertWithTitle:[NSLocalizedString(@"pay_merchant_refresh.network_error.title_label", @"") singleLine]
                     message:NSLocalizedString(@"pay_merchant_refresh.network_error.description_label", @"")
                     actions:[NSArray arrayWithObjects:[AlertActionItem defaultDismissItem], nil]];
}

- (void)showAlertForConnectionFailure{
    [self showAlertWithTitle:@""
                     message:NSLocalizedString(@"home.no_internet_alert.message", @"")
                     actions:[NSArray arrayWithObjects:[AlertActionItem defaultOKItem], nil]];
}

- (void)showAlertForMarketPriceNotAvailable{
    [MBHUD showInView:self.view withDetailTitle:NSLocalizedString(@"hcn_market_price_is_not_available", @"") withType:HUDTypeFailWithoutImage];
}

- (void)showAlertForMerchantRestricted {
    [self showAlertWithTitle:@""
                     message:NSLocalizedString(@"merchant_is_restricted", @"")
                     actions:[NSArray arrayWithObjects:[AlertActionItem defaultOKItem], nil]];
}

- (void)showAlertForAccountRestrictedCoutry {
    [self showAlertWithTitle:@""
                     message:NSLocalizedString(@"your_account_is_not_located", @"")
                     actions:[NSArray arrayWithObjects:[AlertActionItem defaultOKItem], nil]];
}

- (void)showAlertForRestrictedToRecieve {
    [self showAlertWithTitle:@""
                     message:NSLocalizedString(@"the_account_you_are_trying", @"")
                     actions:[NSArray arrayWithObjects:[AlertActionItem defaultOKItem], nil]];
}

- (void)showAlertForRecieverInRestrictedCoutry {
    [self showAlertWithTitle:@""
                     message:NSLocalizedString(@"the_account_you_are_trying_restricted_country", @"")
                     actions:[NSArray arrayWithObjects:[AlertActionItem defaultOKItem], nil]];
}

- (void)showAlertForAccountSuspended {
    [self showAlertWithTitle:@""
                     message:NSLocalizedString(@"user_account_suspended_message", @"")
                     actions:[NSArray arrayWithObjects:[AlertActionItem defaultOKItem], nil]];
}

- (void)showAlertForPinAttemptExceededWithHandler:(AlertActionItemHandler)handler{
    [self showAlertWithTitle:@""
                     message:NSLocalizedString(@"pin_attempt_exceeded", @"")
                     actions:[NSArray arrayWithObjects:[AlertActionItem defaultContinueItemWithHandler:handler], nil]];
}


@end
