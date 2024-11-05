//
//  HimalayaAuthKeychainManager.m
//  Hpay
//
//  Created by Olgu Sirman on 19/05/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "HimalayaAuthKeychainManager.h"

@implementation HimalayaAuthKeychainManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)configure {
    [SAMKeychain setAccessibilityType:kSecAttrAccessibleWhenUnlockedThisDeviceOnly];
}

- (void)deleteCache {
    [SAMKeychain deletePasswordForService:IdentityServerAuthStateAttributesData account:IdentityServerAuthStateAttributesAccount];
    [SAMKeychain deletePasswordForService:IdentityUserAttributesData account:IdentityAuthUserAttributesAccount];
    [SAMKeychain deletePasswordForService:IdentityUserConfigAttributesData account:IdentityUserConfigAttributesAccount];
}

- (void)saveAuthDataToKeychain:(nonnull NSData *)authStateData {
    [SAMKeychain setPasswordData:authStateData forService:IdentityServerAuthStateAttributesData account:IdentityServerAuthStateAttributesAccount];
}

- (NSData *_Nullable)loadAuthStateDataWithError:(NSError *_Nullable*_Nullable)error {
    return [SAMKeychain passwordDataForService:IdentityServerAuthStateAttributesData account:IdentityServerAuthStateAttributesAccount error:error];
}

+ (void)saveUserDataToKeychain:(nonnull HCIdentityUser *)user {
    NSError *error;
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:user requiringSecureCoding:YES error:&error];
    [SAMKeychain setPasswordData:userData forService:IdentityUserAttributesData account:IdentityAuthUserAttributesAccount];
}

+ (HCIdentityUser *_Nullable)loadUserDataWithError:(NSError *_Nullable*_Nullable)error {
    NSError *responseError;
    NSData *userKeychainData = [SAMKeychain passwordDataForService:IdentityUserAttributesData account:IdentityAuthUserAttributesAccount error:error];
    //HCIdentityUser *response = [NSKeyedUnarchiver unarchivedObjectOfClasses:[[NSSet alloc] initWithArray:@[[HCIdentityUser class],[NSString class],[NSNumber class]]] fromData:userKeychainData error:&responseError];
    HCIdentityUser *response = [NSKeyedUnarchiver unarchivedObjectOfClass:[HCIdentityUser class] fromData:userKeychainData error:&responseError];
    return response;
}

+ (void)saveUserConfigToKeychain:(UserConfigResponse *)userConfig{
    NSError* err;
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:userConfig requiringSecureCoding:YES error:&err];
    [SAMKeychain setPasswordData:userData forService:IdentityUserConfigAttributesData account:IdentityUserConfigAttributesAccount];
}

+ (UserConfigResponse *)loadUserConfigToKeychain:(NSError * _Nullable __autoreleasing *)error{
    NSError *responseError;
    NSData *userKeychainData = [SAMKeychain passwordDataForService:IdentityUserConfigAttributesData account:IdentityUserConfigAttributesAccount error:error];
    UserConfigResponse *response = [NSKeyedUnarchiver unarchivedObjectOfClass:[UserConfigResponse class] fromData:userKeychainData error:&responseError];
    return response;
}

@end
