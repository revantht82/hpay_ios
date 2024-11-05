
#import "NSString+Regular.h"
#import "HimalayaAuthManager.h"
#import "HimalayaAuthKeychainManager.h"

@implementation GCUserManager

static GCUserManager *manager = nil;

+ (instancetype)manager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)saveUser:(HCIdentityUser *)user{
    self.user = [user copy];
}

- (void)saveUserConfig:(UserConfigResponse *)userConfig{
    self.userConfig = [userConfig copy];
}

//是否登录
- (BOOL)isLogin {
    return [[HimalayaAuthManager sharedManager] isAuthorized];
}

- (HCIdentityUser *)user {
    
    if (_user == nil) {
        NSError *loadCachedUserError = nil;
        HCIdentityUser *user = [HimalayaAuthKeychainManager loadUserDataWithError:&loadCachedUserError];
        if (loadCachedUserError || !user) {
            return nil;
        }
        [self saveUser:user];
    }
    
    return _user;
}

- (UserConfigResponse *)userConfig {
    
    if (_userConfig == nil) {
        NSError *loadCachedUserError = nil;
        UserConfigResponse *user = [HimalayaAuthKeychainManager loadUserConfigToKeychain:&loadCachedUserError];
        if (loadCachedUserError || !user) {
            return nil;
        }
        [self saveUserConfig:user];
    }
    
    return _userConfig;
}

-(NSString *)visibleName {
    
    if (_user) {
        return ([_user.preferredUsername containsString:@"_"]) ? [self getFirstName] : _user.preferredUsername;
    }
    
    return [self getVisitorName];
}

-(NSString *)getFirstName {
    
    if (_user) {
        NSString *splittedFirstName = [[_user.name componentsSeparatedByString:@" "] firstObject];
        return [NSString textIsEmpty:_user.name] ? [self getVisitorName] : splittedFirstName;
    }
    
    return [self getVisitorName];
}

-(NSString *)getVisitorName {
    return NSLocalizedString(@"visitor", @"Visitor");
}

- (void)logOut {
    _user = nil;
    _userConfig = nil;
    _tscsAccepted = NO;
}

@end
