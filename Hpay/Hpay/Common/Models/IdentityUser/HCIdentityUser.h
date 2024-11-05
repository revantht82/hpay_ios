//
//  HCIdentityUser.h
//  Hpay
//
//  Created by Olgu Sirman on 08/05/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HCIdentityUser;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Object interfaces

@interface HCIdentityUser : NSObject <NSSecureCoding, NSCopying>
@property (nonatomic, copy) NSString *familyName;
@property (nonatomic, copy) NSString *givenName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *preferredUsername;
@property (nonatomic, copy) NSString *sub;
@property (nonatomic, copy) NSString *website;
@property (nonatomic, nullable, copy) NSNumber *isPinSet;

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;

-(id) copyWithZone: (NSZone *) zone;

@end

NS_ASSUME_NONNULL_END
