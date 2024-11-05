//
//  UIViewController+Alert.h
//  Hpay
//
//  Created by Ugur Bozkurt on 03/08/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertActionItem.h"

NS_ASSUME_NONNULL_BEGIN


@interface UIViewController (Alert)
- (void)showUserNotAllowedAlertWithHandler:(AlertActionItemHandler)handler alertMessage:(NSString *)alertMessage;
- (void)showKycAlert;
- (void)showAlertWithTitle:(nullable NSString *)title message:(NSString *)message actions:(nullable NSArray*)actions;
- (void)showAlertForUnknownError;
- (void)showAlertForNetworkError;
- (void)showAlertForConnectionFailure;
- (void)showAlertForMarketPriceNotAvailable;
- (void)showAlertForMerchantRestricted ;
- (void)showAlertForAccountRestrictedCoutry;
- (void)showAlertForRestrictedToRecieve;
- (void)showAlertForRecieverInRestrictedCoutry;
- (void)showAlertForAccountSuspended;
- (void)showAlertForPinAttemptExceededWithHandler:(AlertActionItemHandler)handler;
@end

NS_ASSUME_NONNULL_END
