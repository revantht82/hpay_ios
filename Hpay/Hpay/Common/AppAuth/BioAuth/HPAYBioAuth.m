#import "HPAYBioAuth.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "HCIdentityUser.h"

#define HPAYBioAuthSever @"https://hpayapi.himalaya.exchange/"
#define HPAYBioIsBioAuthOn @"HPAYBioIsBioAuthOnKey"
#define HPAYBioIsAlreadyAskedForBioAuth @"HPAYBioIsAlreadyAskedForBioAuthKey"
#define HPAYBioIsAlreadySytemShowedAlertForBio @"HPAYBioIsAlreadySytemShowedAlertForBioKey"

@interface HPAYBioAuth()

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, nullable, copy) NSNumber *isPinSet;

@end

@implementation HPAYBioAuth

static HPAYBioAuth* gSingleton = nil;
NSNumber *isBioAuthOn;
NSNumber *isAlreadyAskedForBioAuth;
NSNumber *needToSavePINValue;
BOOL bioAvailable;
NSDictionary* bioData;

+ (HPAYBioAuth*)sharedInstance
{
    if (nil == gSingleton)
    {
        gSingleton = [[HPAYBioAuth alloc] init];
    }
    
    return gSingleton;
}

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    if (self) {
        HCIdentityUser *user = [GCUserManager manager].user;
        self.userID = user.sub;
        self.isPinSet = user.isPinSet;
        needToSavePINValue = [NSNumber numberWithBool:NO];
        [self checkIsBioAvailable];
    }
    
    return self;
}

-(NSDictionary*)getBioAuthData {
    return bioData;
}

-(void)checkIsBioAvailable {
    bioData = [self whatBioIDAvailable];
    
    if (bioData[@"errorCode"] && [bioData[@"errorCode"] intValue] != 0) {
        bioAvailable = NO;
    } else if (bioData[@"biometryType"] && ([bioData[@"biometryType"] intValue] != LABiometryTypeTouchID && [bioData[@"biometryType"] intValue] != LABiometryTypeFaceID) ) {
        bioAvailable = NO;
    } else {
        bioAvailable = YES;
    }
}

-(BOOL) getIsBioAuthAvailable {
    return bioAvailable;
}

-(void) saveIsBioAuthAvailable:(NSString*)value {
    bioAvailable = value;
}

-(NSNumber*) getIsNeedToSavePIN {
    return needToSavePINValue;
}

-(void) saveIsNeedToSavePIN:(bool)value {
    needToSavePINValue = [NSNumber numberWithBool:value];
}

-(NSNumber*) getBioAuthOn {
    if (!bioAvailable) return [NSNumber numberWithBool:NO];
    if (isBioAuthOn) return isBioAuthOn;
    
    NSNumber *value = [[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"%@%@", HPAYBioIsBioAuthOn, self.userID]];
    if (!value) value = [NSNumber numberWithBool:NO];
    
    isBioAuthOn = value;
    return isBioAuthOn;
}

-(void) saveIsBioAuthOn:(NSNumber*)value {
    isBioAuthOn = value;
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:[NSString stringWithFormat:@"%@%@", HPAYBioIsBioAuthOn, self.userID]];
}

-(NSNumber*) getAlreadyAskedForBioAuth {
    
    if (isAlreadyAskedForBioAuth) return isAlreadyAskedForBioAuth;
    
    NSNumber *value = [[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"%@%@", HPAYBioIsAlreadyAskedForBioAuth, self.userID]];
    if (!value) value = [NSNumber numberWithBool:NO];
    
    isAlreadyAskedForBioAuth = value;
    
    return isAlreadyAskedForBioAuth;
}

-(void) saveIsAlreadyAskedForBioAuth:(NSNumber*)value {
    isAlreadyAskedForBioAuth = value;
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:[NSString stringWithFormat:@"%@%@", HPAYBioIsAlreadyAskedForBioAuth, self.userID]];
}

-(NSString*) getAccountForPIN {
    return [NSString stringWithFormat:@"%@-PIN", self.userID];
}

- (void)savePIN:(NSString*)PIN {
    NSString *account = [self getAccountForPIN];
    NSData *passwordData = [PIN dataUsingEncoding:NSUTF8StringEncoding];

    SecAccessControlRef access = SecAccessControlCreateWithFlags(NULL, kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly, kSecAccessControlUserPresence, NULL);

    LAContext *context = [[LAContext alloc] init];
    context.touchIDAuthenticationAllowableReuseDuration = 10;

    NSDictionary *query = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassInternetPassword,
        (__bridge id)kSecAttrAccount: account,
        (__bridge id)kSecAttrServer: HPAYBioAuthSever,
        (__bridge id)kSecAttrAccessControl: (__bridge id)access,
        (__bridge id)kSecUseAuthenticationContext: context,
        (__bridge id)kSecValueData: passwordData
    };

    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
    if (status != errSecSuccess) {
        
    }
    needToSavePINValue = [NSNumber numberWithBool:NO];
}

- (NSString *)getPIN {
    LAContext *context = [[LAContext alloc] init];
    context.localizedReason = @"Access your PIN on the keychain";

    NSDictionary *query = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassInternetPassword,
        (__bridge id)kSecAttrServer: HPAYBioAuthSever,
        (__bridge id)kSecMatchLimit: (__bridge id)kSecMatchLimitOne,
        (__bridge id)kSecReturnAttributes: @YES,
        (__bridge id)kSecUseAuthenticationContext: context,
        (__bridge id)kSecReturnData: @YES
    };

    CFTypeRef item = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &item);
    if (status != errSecSuccess) {
        return @"";
    }

    NSDictionary *existingItem = (__bridge_transfer NSDictionary *)item;
    NSData *passwordData = existingItem[(__bridge id)kSecValueData];
    NSString *password = [[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding];
    //NSString *account = existingItem[(__bridge id)kSecAttrAccount];
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:HPAYBioIsAlreadySytemShowedAlertForBio];
    
    return password;
}

- (void)deletePIN {
    NSDictionary *query = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassInternetPassword,
        (__bridge id)kSecAttrServer: HPAYBioAuthSever
    };

    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
    if (status != errSecSuccess) {
        
    }
}

- (NSDictionary*) whatBioIDAvailable {
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithDictionary:@{@"biometryType": @"", @"error":NSLocalizedString(@"biometric.general.error", nil), @"errorCode": [NSNumber numberWithInt:100500]}];
    
    if (![LAContext class]) return result;

    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    if (![myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
//        NSLog(@"%@", [authError localizedDescription]);
//        NSLog(@"%ld", authError.code);
//        NSLog(@"%ld", myContext.biometryType);

        [result setObject:[NSNumber numberWithLongLong:authError.code] forKey:@"errorCode"];
        [result setObject:[authError localizedDescription] forKey:@"error"];
        
//        if (authError.code == LAErrorBiometryNotEnrolled){
//            [result setObject:NSLocalizedString(@"biometric.notenrolled.error", nil) forKey:@"error"];
//        }
    }
    else {
        [result setObject:[NSNumber numberWithInt:0] forKey:@"errorCode"];
    }

//    if (@available(iOS 11.0, *)) {
//        if (myContext.biometryType == LABiometryTypeTouchID){
//            [result setObject:@"touch" forKey:@"biometryType"];
//        } else if (myContext.biometryType == LABiometryTypeFaceID){
//            [result setObject:@"face" forKey:@"biometryType"];
//        } else {
//
//        }
//    }
    
    [result setObject:[NSNumber numberWithLongLong:myContext.biometryType] forKey:@"biometryType"];
    
    return result;
}

-(BOOL) checkForSystemAlert {
    NSNumber *value = [[NSUserDefaults standardUserDefaults] valueForKey:HPAYBioIsAlreadySytemShowedAlertForBio];
    if (!value) {
        value = [NSNumber numberWithBool:NO];
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO] forKey:HPAYBioIsAlreadySytemShowedAlertForBio];
    }
    return [value boolValue];
}

@end
