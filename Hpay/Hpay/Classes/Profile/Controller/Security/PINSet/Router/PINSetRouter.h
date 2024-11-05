//
//  PINSetRouter.h
//  Hpay
//
//  Created by Olgu Sirman on 21/01/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "HPProfileBaseRouter.h"

@class SafeAuthViewController;

@protocol PINSetRouterInterface <HPProfileBaseRouterInterface>

- (void)pushToPinSetVerifyNewPinWithOldPin:(nonnull NSString *)oldPassword;
- (void)pushToHelpFeedback;
- (void)pushToPinSetVerifyCheckReSetNewPINWith:(nonnull NSString *)password forVerificationtype:(BOOL)isMustVerifyReset;
- (void)pushToPinSetWithVerifyFirstCheckSetNewPIN:(nonnull NSString *)password;
- (void)pushToVerifyReSetNewPIN;

- (void)pushToPinSetWith:(NSString *_Nullable)pinCode
             withPinText:(NSString *_Nullable)pinText
              withOldPin:(NSString *_Nullable)oldPin
                 smsCode:(NSString *_Nullable)smsCode;

- (void)clearThePinAndPop;

- (SafeAuthViewController *_Nonnull)presentToSafeAuthWithAllWithDismissEvent:(void (^_Nullable)(void))dismissEvent;

@end

NS_ASSUME_NONNULL_BEGIN

@interface PINSetRouter : HPProfileBaseRouter <PINSetRouterInterface>

@end

NS_ASSUME_NONNULL_END
