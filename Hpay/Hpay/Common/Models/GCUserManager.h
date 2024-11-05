#import <Foundation/Foundation.h>

@class HCIdentityUser;
@class UserConfigResponse;

@interface GCUserManager : NSObject

@property(nonatomic, strong) HCIdentityUser *user;
@property(nonatomic, strong) UserConfigResponse *userConfig;
@property(assign, nonatomic) BOOL tscsAccepted;

+ (instancetype)manager;

- (void)saveUser:(HCIdentityUser *)user;
- (BOOL)isLogin;
- (NSString *)visibleName;
- (void)logOut;

@end
