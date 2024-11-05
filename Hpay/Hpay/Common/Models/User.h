//
//  User.h
//  GrandeurCollect
//
//  Created by apple on 2017/6/23.
//  Copyright © 2017年 fiiipay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSCoding>

@property(nonatomic, copy) NSString *UserId;
@property(nonatomic, copy) NSString *FullName;
@property(nonatomic, copy) NSString *Cellphone;
@property(nonatomic, copy) NSString *Email;
@property(nonatomic, copy) NSString *Username;
@property(nonatomic, copy) NSString *Avatar;
@property(nonatomic, copy) NSString *AccessToken;
@property(nonatomic, copy) NSString *ExpiresTime;


@property(nonatomic, assign) BOOL IsLV1Verified;
@property(nonatomic, assign) BOOL IsBaseProfileComplated;
///**
// 之前二维码OTP的生成的的Key 现在没用了
// */
@property(nonatomic, copy) NSString *SecretKey;
@property(nonatomic, assign) BOOL HasSetPin;
@property(nonatomic, copy) NSString *InvitationCode;


/**
 当前用户设置的法币ID
 */
@property(nonatomic, assign) NSInteger FiatId;


/**
  当前用户设置的法币Code
 */
@property(nonatomic, copy) NSString *FiatCode;
//@property (nonatomic , assign) BOOL HasBindAuthenticator;
@property(nonatomic, copy) NSString *Nickname;

@property(nonatomic, copy) NSString *countryId;
@property(nonatomic, copy) NSString *CountryName;
@property(nonatomic, copy) NSString *CountryNameCN;
@property(nonatomic, copy) NSString *CountryNameTC;


/// 国际化显示当前国家名称
@property(nonatomic, copy) NSString *localCountryName;
@end
