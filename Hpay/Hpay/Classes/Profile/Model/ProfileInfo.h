//
//  ProfileInfo.h
//  FiiiPay
//
//  Created by Singer on 2018/4/11.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ProfileInfoGenderUnknow,//0未知
    ProfileInfoGenderMale,//1：男
    ProfileInfoGenderFamale,//2：女

} ProfileInfoGender;

@interface ProfileInfo : NSObject


/**
 已经加上*
 */
@property(nonatomic, copy) NSString *FullName;


/**
 字符串，客户端直接显示即可
 */
@property(nonatomic, copy) NSString *VerifiedStatus;


/**
 用户头像
 */
@property(nonatomic, copy) NSString *Avatar;
@property(nonatomic, copy) NSString *CountryName;


/**
 用户手机号，已经带上地区码和加上***，比如 86 *******1200
 */
@property(nonatomic, copy) NSString *Cellphone;
@property(nonatomic, copy) NSString *Email;
@property(nonatomic, copy) NSString *Gender;
@property(nonatomic, copy) NSString *Birthday;
@property(nonatomic, copy) NSString *Nickname;
@end
