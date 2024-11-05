//
//  ProfileHelperModel.h
//  FiiiPay
//
//  Created by Singer on 2018/4/4.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "GLCNetworkRequest.h"
#import "FPCountry.h"
#import "ProfileInfo.h"
#import "IdentityAuthLV1Model.h"
#import "IdentityAuthLV2Model.h"
#import "FPProfileCoin.h"
#import "FPProfileHomeCoin.h"
#import "WithdrawAddress.h"
#import "FPArticle.h"
#import "FPNotice.h"
#import "FPDevice.h"
#import "HimalayaPayAPIManager.h"

typedef enum : NSUInteger {
    ProfileLVStatusNotUpload,//未上传
    ProfileLVStatusApproved,//审核通过
    ProfileLVStatusUnApproved, //审核失败
    ProfileLVStatusApproving    //审核中
} ProfileLVStatus;

typedef enum : NSUInteger {
    MyEarningsShopsTypeInvitation = 1,
    MyEarningsShopsTypeCityNode = 2,
} MyEarningsShopsType;

@interface ProfileHelperModel : HimalayaPayAPIManager

#pragma mark - Security

/**
 设置二级密码，客户端首先根据登录返回的SimpleUserInfo的HasSetPin字段判断是否已经设置过Pin
 */
+ (void)securitySetPin:(NSString *)pin completeBlock:(void (^)(BOOL result, NSInteger errorCode, NSString *errorMessage))completBlock;

/**
 修改PIN的时候验证旧的pin
 */
+ (void)verifyPinOnUpdatePin:(NSString *)pin completeBlock:(void (^)(BOOL result, NSInteger errorCode, NSString *errorMessage))completBlock;

/**
 修改PIN

 @param newPin <#newPin description#>
 @param oldPin <#oldPin description#>
 @param completBlock <#completBlock description#>
 */
+ (void)updatePinWithNewPin:(NSString *)newPin oldPin:(NSString *)oldPin completeBlock:(void (^)(BOOL result, NSInteger errorCode, NSString *errorMessage))completBlock;

/**
 找回PIN

 @param code <#code description#>
 @param newPin <#newPin description#>
 @param identityNo <#identityNo description#>
 @param completBlock <#completBlock description#>
 */
//+(void)findBackPinWithCode:(NSString *)code newPin:(NSString *)newPin identityNo:(NSString *)identityNo completeBlock:(void(^)(BOOL result,NSInteger errorCode,NSString *errorMessage))completBlock;
+ (void)resetPinWithNewPin:(NSString *)nPin lv1Number:(NSString *)lvNumber smsCode:(NSString *)smsCode emailCode:(NSString *)emailCode googleCode:(NSString *)googleCode completeBlock:(void (^)(BOOL result, NSInteger errorCode, NSString *errorMessage))completBlock;

/**
 验证Pin码，超过五次错误会锁定30分钟

 @param pin 加密过后的pin
 @param completBlock <#completBlock description#>
 */
+ (void)verifyPin:(NSString *)pin urlString:(NSString *)urlString completeBlock:(void (^)(BOOL result, NSInteger errorCode, NSString *errorMessage))completBlock;

@end
