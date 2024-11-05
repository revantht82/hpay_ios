//
//  ProductCategory.m
//  Hpay
//
//  Created by ONUR YILMAZ on 24/03/2022.
//  Copyright © 2022 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ProductCategoryResponse.h"

@implementation ProductCategoryResponse

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        
        _productsList = (NSDictionary *)dictionary[@"ProductCategoryList"];

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
        
        self.productsList = [coder decodeObjectOfClass:[NSString class] forKey:@"ProductCategoryList"];
     
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    
    [coder encodeObject:self.productsList forKey:@"ProductCategoryList"];

}


@end
