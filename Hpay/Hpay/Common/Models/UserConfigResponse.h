//
//  UserConfigResponse.h
//  Hpay
//
//  Created by Ugur Bozkurt on 25/08/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserConfigResponse : NSObject <NSCoding, NSSecureCoding>
@property(nonatomic) NSNumber *isUserAllowed;
@property(nonatomic) NSNumber *isKYCVerified;
@property(nonatomic) NSString *userState;
@property(nonatomic) NSNumber *termsRequireAccepting;
@property(nonatomic) NSNumber *privacyRequireAccepting;
@property(nonatomic) NSString *termsUrl;
@property(nonatomic) NSString *privacyUrl;
@property(nonatomic) NSNumber *termsVersion;
@property(nonatomic) NSNumber *privacyVersion;
@property(nonatomic) NSString *userType;
@property(nonatomic) NSNumber *isForceUpdateAvailable;
@property(nonatomic) NSNumber *isRecommendedUpdateAvailable;
@property(nonatomic) NSNumber *isGlobalMessageAvailable;
@property(nonatomic) NSNumber *isGlobalMessageBlockinUse;
@property(nonatomic) NSString *globalMessage;
@property(nonatomic) NSString *updateUrl;
@property(nonatomic) NSNumber *userHasNewNotifications;
@property(nonatomic) NSString *nickname;
@property(nonatomic) NSString *MyQR;
@property(nonatomic) NSString *HID;
@property(nonatomic) NSNumber *SendToGroupThreshold;
@property(nonatomic) NSNumber *SendToGroupMaxAmountLimit;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
