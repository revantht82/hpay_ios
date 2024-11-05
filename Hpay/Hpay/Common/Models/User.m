//
//  User.m
//  GrandeurCollect
//
//  Created by apple on 2017/6/23.
//  Copyright © 2017年 fiiipay. All rights reserved.
//

@implementation User

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.UserId = [aDecoder decodeObjectForKey:@"UserId"];
        self.FullName = [aDecoder decodeObjectForKey:@"FullName"];
        self.Cellphone = [aDecoder decodeObjectForKey:@"Cellphone"];
        self.Username = [aDecoder decodeObjectForKey:@"Username"];
        self.Avatar = [aDecoder decodeObjectForKey:@"Avatar"];
        self.AccessToken = [aDecoder decodeObjectForKey:@"AccessToken"];
        self.ExpiresTime = [aDecoder decodeObjectForKey:@"ExpiresTime"];
        self.SecretKey = [aDecoder decodeObjectForKey:@"SecretKey"];
        self.HasSetPin = [aDecoder decodeBoolForKey:@"HasSetPin"];
        self.FiatId = [aDecoder decodeIntegerForKey:@"FiatId"];
        self.FiatCode = [aDecoder decodeObjectForKey:@"FiatCode"];
        self.IsBaseProfileComplated = [aDecoder decodeBoolForKey:@"IsBaseProfileComplated"];
        self.IsLV1Verified = [aDecoder decodeBoolForKey:@"IsLV1Verified"];
        self.Nickname = [aDecoder decodeObjectForKey:@"Nickname"];
        self.InvitationCode = [aDecoder decodeObjectForKey:@"InvitationCode"];
        self.Email = [aDecoder decodeObjectForKey:@"Email"];
        self.countryId = [aDecoder decodeObjectForKey:@"CountryId"];
        self.CountryName = [aDecoder decodeObjectForKey:@"CountryName"];
        self.CountryNameCN = [aDecoder decodeObjectForKey:@"CountryNameCN"];
        self.CountryNameTC = [aDecoder decodeObjectForKey:@"CountryNameTC"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.UserId forKey:@"UserId"];
    [aCoder encodeObject:self.FullName forKey:@"FullName"];
    [aCoder encodeObject:self.Cellphone forKey:@"Cellphone"];
    [aCoder encodeObject:self.Username forKey:@"Username"];
    [aCoder encodeObject:self.Avatar forKey:@"Avatar"];
    [aCoder encodeObject:self.AccessToken forKey:@"AccessToken"];
    [aCoder encodeObject:self.ExpiresTime forKey:@"ExpiresTime"];
    [aCoder encodeObject:self.SecretKey forKey:@"SecretKey"];
    [aCoder encodeBool:self.HasSetPin forKey:@"HasSetPin"];
    [aCoder encodeBool:self.IsLV1Verified forKey:@"IsLV1Verified"];
    [aCoder encodeBool:self.IsBaseProfileComplated forKey:@"IsBaseProfileComplated"];
    [aCoder encodeInteger:self.FiatId forKey:@"FiatId"];
    [aCoder encodeObject:self.FiatCode forKey:@"FiatCode"];
    [aCoder encodeObject:self.Nickname forKey:@"Nickname"];
    [aCoder encodeObject:self.InvitationCode forKey:@"InvitationCode"];
    [aCoder encodeObject:self.Email forKey:@"Email"];
    [aCoder encodeObject:self.CountryName forKey:@"CountryName"];
    [aCoder encodeObject:self.CountryNameCN forKey:@"CountryNameCN"];
    [aCoder encodeObject:self.CountryNameTC forKey:@"CountryNameTC"];
    [aCoder encodeObject:self.countryId forKey:@"CountryId"];
}

- (NSString *)localCountryName {
    NSString *language = [FPLanguageTool sharedInstance].language;
    NSString *countryName = self.CountryName;
    if ([language isEqualToString:@"zh-Hans"]) {
        countryName = self.CountryNameCN;
    } else if ([language isEqualToString:@"zh-Hant"]) {
        countryName = self.CountryNameTC;
    }
    return countryName;
}

- (void)setCountryId:(NSString *)countryId {
    if (![countryId isEqualToString:@"0"]) {
        _countryId = countryId;
    }
}

@end
