//
//  SafeAuthViewController.h
//  FiiiPay
//
//  Created by apple on 2018/5/15.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "FPViewController.h"

@class SafeAuthViewController;

@protocol SafeAuthDelegate <NSObject>
@optional
// It is used for account password login and SMS verification code login, GA (Google authentication) is turned on, and the input Google code content is passed
- (void)finishWithGoogleCode:(NSString *)googleCode;
- (void)finishWithSMSCode:(NSString *)smsCode andEmailCode:(NSString *)emailCode andGoogleCode:(NSString *)googleCode;
- (void)finishSafeAuthVC:(SafeAuthViewController *)vc andLv1:(NSString *)lv1 andSmsCode:(NSString *)smsCode andEmailCode:(NSString *)emailCode andGoogleCode:(NSString *)googleCode;
- (void)finishSafeAuthVC:(SafeAuthViewController *)vc andLv1:(NSString *)lv1 andPin:(NSString *)pin andGoogleCode:(NSString *)googleCode;
- (void)finishSafeAuthVC:(SafeAuthViewController *)vc andEmailCode:(NSString *)emailCode;
- (void)finishWithLoginPassword:(NSString *)loginPassword;
@end

typedef void(^DissMissEvent)(void);

@interface SafeAuthViewController : FPViewController

- (void)startAnimationEvent;
- (void)updateBtnStatu:(BOOL)beEnable;
- (void)configWithAuthType:(SafeAuthType)authType;
- (void)configWithAuthType:(SafeAuthType)authType andDivisionCode:(NSString *)divisionCode;
- (void)configWithAuthType:(SafeAuthType)authType andLV1Auth:(BOOL)lv1Enable andGoogleAuth:(BOOL)googleEnable;

@property(copy, nonatomic) DissMissEvent dissMissEvent;
@property(weak, nonatomic) id <SafeAuthDelegate> safeDelegate;
- (void)hideSafeVC:(BOOL)outSideDissmiss;

@end
