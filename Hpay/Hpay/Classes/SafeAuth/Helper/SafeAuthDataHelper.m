//
//  SafeAuthDataHelper.m
//  FiiiPay
//
//  Created by apple on 2018/5/18.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "SafeAuthDataHelper.h"

@implementation SafeAuthDataHelper

#pragma mark - 获取用户开启的密保方式

+ (void)fetchAuthenticatorOpenedSecuritiesCompleteBlock:(void (^)(NSString *CellPhone, NSString *Email, BOOL IsOpenedAuthencator, NSInteger errorCode, NSString *errorMessage))completBlock {
    [self      GET:AuthenticatorGetOpenedSecuritiesURL parameters:nil successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        NSDictionary *dict = (NSDictionary *) data;
        NSString *phone = dict[@"CellPhone"];
        NSString *email = dict[@"Email"];
        BOOL IsOpenedAuthencator = [dict[@"IsOpenedAuthencator"] boolValue];
        completBlock(phone, email, IsOpenedAuthencator, kFPNetRequestSuccessCode, nil);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        completBlock(nil, nil, NO, code, message);
    }];
}

#pragma mark - 获取手机验证码

+ (void)sendSafePhoneSMSCodeWithDivisionCode:(NSString *)DivisionCode CompleteBlock:(void (^)(BOOL success, NSInteger errorCode, NSString *errorMessage))completBlock {
    NSString *url = SecurityGetSecurityCellphoneCodeURL;
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    if (DivisionCode && DivisionCode.length > 0) {
        mDict[@"DivisionCode"] = DivisionCode;
    }
    [self     POST:url parameters:mDict successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        BOOL rs = (BOOL) data;
        completBlock(rs, kFPNetRequestSuccessCode, nil);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        completBlock(NO, code, message);
    }];
}

#pragma mark - 获取手机验证码

+ (void)sendSafePhoneEmailCodeWithDivisionCode:(NSString *)DivisionCode CompleteBlock:(void (^)(BOOL success, NSInteger errorCode, NSString *errorMessage))completBlock {
    NSString *url = SecurityGetSecurityEmailCodeURL;
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    if (DivisionCode && DivisionCode.length > 0) {
        mDict[@"DivisionCode"] = DivisionCode;
    }
    [self     POST:url parameters:mDict successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        BOOL rs = (BOOL) data;
        completBlock(rs, kFPNetRequestSuccessCode, nil);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        completBlock(NO, code, message);
    }];
}

#pragma mark - 综合验证

+ (void)vaildateAllByArr:(NSArray *)Authencates completeBlock:(void (^)(NSString *token, NSInteger errorCode, NSString *errorMessage))completBlock {
    [self     POST:AuthenticatorSecurityValidateURL parameters:@{@"Authencates": Authencates} successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        NSString *token = (NSString *) data;
        completBlock(token, kFPNetRequestSuccessCode, nil);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        completBlock(nil, code, message);
    }];

}
@end
