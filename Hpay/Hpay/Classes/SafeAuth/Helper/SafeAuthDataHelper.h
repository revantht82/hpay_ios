//
//  SafeAuthDataHelper.h
//  FiiiPay
//
//  Created by apple on 2018/5/18.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLCNetworkRequest.h"
#import "HimalayaPayAPIManager.h"

@interface SafeAuthDataHelper : HimalayaPayAPIManager
/**
 * desc : 获取用户开启的密保方式
 */

+ (void)fetchAuthenticatorOpenedSecuritiesCompleteBlock:(void (^)(NSString *CellPhone, NSString *Email, BOOL IsOpenedAuthencator, NSInteger errorCode, NSString *errorMessage))completBlock;

/**
 * desc : 获取手机验证码
 type = 0 为综合验证其他情况发送验证码
 type = 1 为综合验证（单纯重置PIN码的时候发送验证码）
 */
+ (void)sendSafePhoneSMSCodeWithDivisionCode:(NSString *)DivisionCode CompleteBlock:(void (^)(BOOL success, NSInteger errorCode, NSString *errorMessage))completBlock;

+ (void)sendSafePhoneEmailCodeWithDivisionCode:(NSString *)DivisionCode CompleteBlock:(void (^)(BOOL success, NSInteger errorCode, NSString *errorMessage))completBlock;

/**
 * desc : 综合验证
 */
+ (void)vaildateAllByArr:(NSArray *)Authencates completeBlock:(void (^)(NSString *token, NSInteger errorCode, NSString *errorMessage))completBlock;
@end
