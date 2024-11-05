//
//  FPSecurityAuthManager.h
//  GLC
//
//  Created by Singer on 2018/1/16.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    FPSecurityAutTypeDefault,
    FPSecurityAutTypeWithdrawal,
    FPSecurityAutTypeFirstSetEmail,
    FPSecurityAutTypeUpdateEmail,
    FPSecurityAutTypeUpdateLoginPasword,
    FPSecurityAutTypeGoogleCodeBind,
    FPSecurityAutTypeGoogleCodeUnBind,
    FPSecurityAutTypeGoogleCodeClose
} FPSecurityAutType;

@interface FPSecurityAuthManager : NSObject
@property(nonatomic, copy) void (^securityAuthSuccessBlock)(NSString *securityPssaword);
@property(nonatomic, copy) void (^securityAuthCloseBlock)(void);

/**
 解锁认证成功
 */
@property(nonatomic, copy) void (^securityAuthUnlockSuccessBlock)(void);


/**
 用户取消解锁认证
 */
@property(nonatomic, copy) void (^securityAuthUnlockCancelBlock)(void);


/**
 解锁时用户点了密码登录
 */
@property(nonatomic, copy) void (^securityAuthUnlockUserFallbackBlock)(void);
/**
 只是验证PIN
 */
@property(nonatomic, assign) BOOL isOnlyVerifyPin;

@property(nonatomic, assign) BOOL isUnlockScreen;

- (void)securityAuth;

- (instancetype)initWithAuthType:(FPSecurityAutType)type;
@end
