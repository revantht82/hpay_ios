//
//  ProfileHelperModel.m
//  FiiiPay
//
//  Created by Singer on 2018/4/4.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "ProfileHelperModel.h"
#import "GTMBase64.h"
#import "ApiError.h"

@implementation ProfileHelperModel

/**
 修改PIN的时候验证旧的pin
 */
+ (void)verifyPinOnUpdatePin:(NSString *)pin completeBlock:(void (^)(BOOL result, NSInteger errorCode, NSString *errorMessage))completBlock {
    [self     POST:SecurityVerifyUpdatePinPinURL parameters:@{@"Pin": pin} successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        BOOL result = [((NSNumber *) data) boolValue];
        completBlock(result, kFPNetRequestSuccessCode, message);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        if (code == kFPNetWorkErrorCode){
            completBlock(NO, code, NSLocalizedString(@"home.no_internet_alert.message", @""));
        }else{
            completBlock(NO, code, [ApiError errorWithCode:code message:message].prettyMessage);
        }
    }];
}

/**
 修改PIN
 
 @param newPin <#newPin description#>
 @param oldPin <#oldPin description#>
 @param completBlock <#completBlock description#>
 */
+ (void)updatePinWithNewPin:(NSString *)newPin oldPin:(NSString *)oldPin completeBlock:(void (^)(BOOL result, NSInteger errorCode, NSString *errorMessage))completBlock {
    [self     POST:SecurityUpdatePinURL parameters:@{@"OldPin": oldPin, @"NewPin": newPin} successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        BOOL result = [((NSNumber *) data) boolValue];
        completBlock(result, kFPNetRequestSuccessCode, nil);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        if (code == kFPNetWorkErrorCode){
            completBlock(NO, code, NSLocalizedString(@"home.no_internet_alert.message", @""));
        }else{
            completBlock(NO, code, [ApiError errorWithCode:code message:message].prettyMessage);
        }
    }];
}

/**
 verifyPin
 设置二级密码，客户端首先根据登录返回的SimpleUserInfo的HasSetPin字段判断是否已经设置过Pin
 */
+ (void)securitySetPin:(NSString *)pin completeBlock:(void (^)(BOOL result, NSInteger errorCode, NSString *errorMessage))completBlock; {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"Pin"] = pin;

    [self     POST:SecuritySetPinURL parameters:dict successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        BOOL result = [((NSNumber *) data) boolValue];
        completBlock(result, kFPNetRequestSuccessCode, NSLocalizedString(@"set_pin_error", @""));
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        if (code == kFPNetWorkErrorCode){
            completBlock(NO, code, NSLocalizedString(@"home.no_internet_alert.message", @""));
        }else{
            completBlock(NO, code, [ApiError errorWithCode:code message:message].prettyMessage);
        }
    }];
}

/**
 找回PIN
 
 @param code <#code description#>
 @param newPin <#newPin description#>
 @param identityNo <#identityNo description#>
 @param completBlock <#completBlock description#>
 */

+ (void)resetPinWithNewPin:(NSString *)nPin lv1Number:(NSString *)lvNumber smsCode:(NSString *)smsCode emailCode:(NSString *)emailCode googleCode:(NSString *)googleCode completeBlock:(void (^)(BOOL result, NSInteger errorCode, NSString *errorMessage))completBlock {
    
    NSMutableDictionary *param = @{@"newPin": nPin}.mutableCopy;
    
    if (lvNumber.length > 0) {
        param[@"idNumber"] = lvNumber;
    }
    
    if (googleCode.length > 0) {
        param[@"GoogleCode"] = googleCode;
    }
    if (smsCode.length > 0) {
        param[@"SMSCode"] = smsCode;
    }
    if (emailCode.length > 0) {
        param[@"EmailCode"] = emailCode;
    }
    [self     POST:SecurityResetPINURL parameters:param successBlock:^(NSObject *_Nullable data, NSObject *_Nullable extension, NSString *_Nullable message) {
        BOOL result = [((NSNumber *) data) boolValue];
        completBlock(result, kFPNetRequestSuccessCode, message);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        if (code == kFPNetWorkErrorCode){
            completBlock(NO, code, NSLocalizedString(@"home.no_internet_alert.message", @""));
        }else{
            completBlock(NO, code, [ApiError errorWithCode:code message:message].prettyMessage);
        }
    }];
}


+ (void)verifyPin:(NSString *)pin urlString:(NSString *)urlString completeBlock:(void (^)(BOOL result, NSInteger errorCode, NSString *errorMessage))completBlock {
    if (urlString == nil) {
        urlString = AccountVerifyPinURL;
    }
    [self     POST:urlString parameters:@{@"Pin": pin} successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        BOOL result = [((NSNumber *) data) boolValue];
        completBlock(result, kFPNetRequestSuccessCode, NSLocalizedString(@"verify_pin_error", @""));
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        if (code == kFPNetWorkErrorCode){
            completBlock(NO, code, NSLocalizedString(@"home.no_internet_alert.message", @""));
        }else{
            completBlock(NO, code, [ApiError errorWithCode:code message:message].prettyMessage);
        }
    }];
}

@end
