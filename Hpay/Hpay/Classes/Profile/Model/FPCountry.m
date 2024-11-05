//
//  FPCountry.m
//  FiiiPay
//
//  Created by Singer on 2018/4/4.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "FPCountry.h"

@implementation FPCountry

#pragma mark NSSecureCoding
+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.Name = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"Name"];
        self.PhoneCode = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"PhoneCode"];
        self.PinYin = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"PinYin"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.Name forKey:@"Name"];
    [aCoder encodeObject:self.PhoneCode forKey:@"PhoneCode"];
    [aCoder encodeObject:self.PinYin forKey:@"PinYin"];
}

@end
