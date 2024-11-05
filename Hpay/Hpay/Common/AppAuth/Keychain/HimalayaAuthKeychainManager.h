//
//  HimalayaAuthKeychainManager.h
//  Hpay
//
//  Created by Olgu Sirman on 19/05/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserConfigResponse.h"

@class HCIdentityUser;

@protocol HimalayaAuthKeychainState <NSObject>

- (void)deleteCache;
- (void)saveAuthDataToKeychain:(nonnull NSData *)authStateData;
+ (void)saveUserDataToKeychain:(nonnull HCIdentityUser *)user;
- (NSData *_Nullable)loadAuthStateDataWithError:(NSError *_Nullable*_Nullable)error;
+ (HCIdentityUser *_Nullable)loadUserDataWithError:(NSError *_Nullable*_Nullable)error;
@end

NS_ASSUME_NONNULL_BEGIN

@interface HimalayaAuthKeychainManager : NSObject <HimalayaAuthKeychainState>

#pragma mark HimalayaAuthKeychainState
- (void)deleteCache;
- (void)saveAuthDataToKeychain:(nonnull NSData *)authStateData;
+ (void)saveUserDataToKeychain:(nonnull HCIdentityUser *)user;
+ (void)saveUserConfigToKeychain:(nonnull UserConfigResponse *)userConfig;
- (NSData *_Nullable)loadAuthStateDataWithError:(NSError *_Nullable *_Nullable)error;
+ (HCIdentityUser *_Nullable)loadUserDataWithError:(NSError *_Nullable *_Nullable)error;
+ (UserConfigResponse *_Nullable)loadUserConfigToKeychain:(NSError *_Nullable *_Nullable)error;
@end

NS_ASSUME_NONNULL_END
