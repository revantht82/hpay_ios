//
//  IdentityAuthLV1Model.m
//  FiiiPay
//
//  Created by Singer on 2018/4/11.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "IdentityAuthLV1Model.h"

@implementation IdentityAuthLV1Model

- (id)copyWithZone:(nullable NSZone *)zone {
    id copy = [[[self class] alloc] init];
    [IdentityAuthLV1Model mj_enumerateProperties:^(MJProperty *property, BOOL *stop) {
        [copy setValue:[self valueForKey:property.name] forKey:property.name];
    }];
    return copy;
}
@end
