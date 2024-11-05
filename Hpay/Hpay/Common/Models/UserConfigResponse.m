//
//  UserConfigResponse.m
//  Hpay
//
//  Created by Ugur Bozkurt on 25/08/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "UserConfigResponse.h"

@implementation UserConfigResponse

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        _isUserAllowed = (NSNumber *)dictionary[@"IsUserAllowed"];
        _isKYCVerified = (NSNumber *)dictionary[@"IsKYCVerified"];
        _userState = (NSString *)dictionary[@"UserState"];
        _termsRequireAccepting = (NSNumber *)[dictionary valueForKeyPath:@"UserAgreements.Terms.DoesRequireAccepting"];
        _privacyRequireAccepting = (NSNumber *)[dictionary valueForKeyPath:@"UserAgreements.Privacy.DoesRequireAccepting"];
        _termsUrl = (NSURL *)[dictionary valueForKeyPath:@"UserAgreements.Terms.Url"];
        _privacyUrl = (NSURL *)[dictionary valueForKeyPath:@"UserAgreements.Privacy.Url"];
        _termsVersion = (NSNumber *) [dictionary valueForKeyPath:@"UserAgreements.Terms.Version"];
        _privacyVersion = (NSNumber *) [dictionary valueForKeyPath:@"UserAgreements.Privacy.Version"];
        _userType = (NSString *)dictionary[@"UserType"];
        _isForceUpdateAvailable = (NSNumber *)dictionary[@"ForceAppUpdate"];
        _isRecommendedUpdateAvailable = (NSNumber *)dictionary[@"SuggestAppUpdate"];
        _isGlobalMessageAvailable = (NSNumber *)dictionary[@"ShowNotification"];
        _isGlobalMessageBlockinUse = (NSNumber *)dictionary[@"BlockAppWithNotification"];
        _globalMessage = (NSString *)dictionary[@"NotificationMessage"];
        _updateUrl = (NSString *)dictionary[@"ApplicationUrl"];
        _userHasNewNotifications = (NSNumber *)dictionary[@"NewAnnouncements"];
        _nickname = (NSString *)dictionary[@"NickName"];
        _MyQR = (NSString *)dictionary[@"MyQR"];
        _HID = (NSString *)dictionary[@"HID"];
        _SendToGroupThreshold = (NSNumber *) [dictionary valueForKeyPath:@"SendToGroupThreshold"];
        _SendToGroupMaxAmountLimit = (NSNumber *) [dictionary valueForKeyPath:@"SendToGroupMaxAmountLimit"];
    }
    return self;
}

#pragma mark NSSecureCoding
+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.isUserAllowed = [coder decodeObjectOfClass:[NSNumber class] forKey:@"IsUserAllowed"];
        self.isKYCVerified = [coder decodeObjectOfClass:[NSNumber class] forKey:@"IsKYCVerified"];
        self.userState =[coder decodeObjectOfClass:[NSString class] forKey:@"UserState"];
        self.termsRequireAccepting = [coder decodeObjectOfClass:[NSString class] forKey:@"UserAgreements.Terms.DoesRequireAccepting"];
        self.privacyRequireAccepting = [coder decodeObjectOfClass:[NSString class] forKey:@"UserAgreements.Privacy.DoesRequireAccepting"];
        self.termsUrl = [coder decodeObjectOfClass:[NSURL class] forKey:@"UserAgreements.Terms.Url"];
        self.privacyUrl = [coder decodeObjectOfClass:[NSURL class] forKey:@"UserAgreements.Privacy.Url"];
        self.termsVersion = [coder decodeObjectOfClass:[NSNumber class] forKey:@"UserAgreements.Terms.Version"];
        self.privacyVersion = [coder decodeObjectOfClass:[NSNumber class] forKey:@"UserAgreements.Privacy.Version"];
        self.userType = [coder decodeObjectOfClass:[NSString class] forKey:@"UserType"];
        self.isForceUpdateAvailable = [coder decodeObjectOfClass:[NSString class] forKey:@"ForceAppUpdate"];
        self.isRecommendedUpdateAvailable = [coder decodeObjectOfClass:[NSString class] forKey:@"SuggestAppUpdate"];
        self.isGlobalMessageAvailable = [coder decodeObjectOfClass:[NSString class] forKey:@"ShowNotification"];
        self.isGlobalMessageBlockinUse = [coder decodeObjectOfClass:[NSString class] forKey:@"BlockAppWithNotification"];
        self.globalMessage = [coder decodeObjectOfClass:[NSString class] forKey:@"NotificationMessage"];
        self.updateUrl = [coder decodeObjectOfClass:[NSString class] forKey:@"ApplicationUrl"];
        self.userHasNewNotifications = [coder decodeObjectOfClass:[NSNumber class] forKey:@"UserHasNewNotifications"];
        self.nickname = [coder decodeObjectOfClass:[NSString class] forKey:@"NickName"];
        self.MyQR = [coder decodeObjectOfClass:[NSString class] forKey:@"MyQR"];
        self.HID = [coder decodeObjectOfClass:[NSString class] forKey:@"HID"];
        self.SendToGroupThreshold = [coder decodeObjectOfClass:[NSString class] forKey:@"SendToGroupThreshold"];
        self.SendToGroupMaxAmountLimit = [coder decodeObjectOfClass:[NSString class] forKey:@"SendToGroupMaxAmountLimit"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.isUserAllowed forKey:@"IsUserAllowed"];
    [coder encodeObject:self.isKYCVerified forKey:@"IsKYCVerified"];
    [coder encodeObject:self.userState forKey:@"UserState"];
    [coder encodeObject:self.termsRequireAccepting forKey:@"UserAgreements.Terms.DoesRequireAccepting"];
    [coder encodeObject:self.privacyRequireAccepting forKey:@"UserAgreements.Privacy.DoesRequireAccepting"];
    [coder encodeObject:self.termsUrl forKey:@"UserAgreements.Terms.Url"];
    [coder encodeObject:self.privacyUrl forKey:@"UserAgreements.Privacy.Url"];
    [coder encodeObject:self.termsVersion forKey:@"UserAgreements.Terms.Version"];
    [coder encodeObject:self.privacyVersion forKey:@"UserAgreements.Privacy.Version"];
    [coder encodeObject:self.userType forKey:@"UserType"];
    [coder encodeObject:self.isForceUpdateAvailable forKey:@"ForceAppUpdate"];
    [coder encodeObject:self.isRecommendedUpdateAvailable forKey:@"SuggestAppUpdate"];
    [coder encodeObject:self.isGlobalMessageAvailable forKey:@"ShowNotification"];
    [coder encodeObject:self.isGlobalMessageBlockinUse forKey:@"BlockAppWithNotification"];
    [coder encodeObject:self.globalMessage forKey:@"NotificationMessage"];
    [coder encodeObject:self.updateUrl forKey:@"ApplicationUrl"];
    [coder encodeObject:self.userHasNewNotifications forKey:@"UserHasNewNotifications"];
    [coder encodeObject:self.nickname forKey:@"NickName"];
    [coder encodeObject:self.MyQR forKey:@"MyQR"];
    [coder encodeObject:self.HID forKey:@"HID"];
    [coder encodeObject:self.SendToGroupThreshold forKey:@"SendToGroupThreshold"];
    [coder encodeObject:self.SendToGroupMaxAmountLimit forKey:@"SendToGroupMaxAmountLimit"];
}

- (id)copyWithZone:(NSZone *)zone {
    UserConfigResponse *copy = [[[self class] allocWithZone:zone] init];
    copy.isUserAllowed = self.isUserAllowed;
    copy.isKYCVerified = self.isKYCVerified;
    copy.userState = self.userState;
    copy.termsRequireAccepting = self.termsRequireAccepting;
    copy.privacyRequireAccepting = self.privacyRequireAccepting;
    copy.termsUrl = self.termsUrl;
    copy.privacyUrl = self.privacyUrl;
    copy.termsVersion = self.termsVersion;
    copy.privacyVersion = self.privacyVersion;
    copy.userType = self.userType;
    copy.isForceUpdateAvailable = self.isForceUpdateAvailable;
    copy.isRecommendedUpdateAvailable = self.isRecommendedUpdateAvailable;
    copy.isGlobalMessageAvailable = self.isGlobalMessageAvailable;
    copy.isGlobalMessageBlockinUse = self.isGlobalMessageBlockinUse;
    copy.globalMessage = self.globalMessage;
    copy.updateUrl = self.updateUrl;
    copy.nickname = self.nickname;
    copy.MyQR = self.MyQR;
    copy.HID = self.HID;
    copy.SendToGroupThreshold = self.SendToGroupThreshold;
    copy.SendToGroupMaxAmountLimit = self.SendToGroupMaxAmountLimit;
    return copy;
}


@end
