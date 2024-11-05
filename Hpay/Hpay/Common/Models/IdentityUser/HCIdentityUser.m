//
//  HCIdentityUser.m
//  Hpay
//
//  Created by Olgu Sirman on 08/05/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

// Shorthand for simple blocks
#define λ(decl, expr) (^(decl) { return (expr); })

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Private model interfaces

@interface HCIdentityUser (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

NS_ASSUME_NONNULL_END

@interface HCIdentityUser ()

@property (nonatomic, strong) User *user;

@end

#pragma mark - HCIdentityUser Implementation

@implementation HCIdentityUser

#pragma mark NSSecureCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.familyName = [coder decodeObjectForKey:@"family_name"];
        self.givenName = [coder decodeObjectForKey:@"given_name"];
        self.name = [coder decodeObjectForKey:@"name"];
        self.email = [coder decodeObjectForKey:@"email"];
        self.preferredUsername = [coder decodeObjectForKey:@"preferred_username"];
        self.sub = [coder decodeObjectForKey:@"sub"];
        self.website = [coder decodeObjectForKey:@"website"];
        self.isPinSet = [coder decodeObjectForKey:@"is_pin_set"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.familyName forKey:@"family_name"];
    [coder encodeObject:self.givenName forKey:@"given_name"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.email forKey:@"email"];
    [coder encodeObject:self.preferredUsername forKey:@"preferred_username"];
    [coder encodeObject:self.sub forKey:@"sub"];
    [coder encodeObject:self.website forKey:@"website"];
    [coder encodeObject:self.isPinSet forKey:@"is_pin_set"];
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[HCIdentityUser alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        _familyName = dict[@"family_name"];
        _givenName = dict[@"given_name"];
        _name = dict[@"name"];
        _email = dict[@"email"];
        _preferredUsername = dict[@"preferred_username"];
        _sub = dict[@"sub"];
        _website = dict[@"website"];
        _isPinSet = dict[@"is_pin_set"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    HCIdentityUser *copy = [[HCIdentityUser allocWithZone: zone] init];
    
    [copy setFamilyName:self.familyName];
    [copy setGivenName:self.givenName];
    [copy setName:self.name];
    [copy setEmail:self.email];
    [copy setPreferredUsername:self.preferredUsername];
    [copy setSub:self.sub];
    [copy setWebsite:self.website];
    [copy setIsPinSet:self.isPinSet];
    return copy;
}

@end
