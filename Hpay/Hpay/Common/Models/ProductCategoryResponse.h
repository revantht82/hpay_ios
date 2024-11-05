//
//  ProductCategory.h
//  Hpay
//
//  Created by ONUR YILMAZ on 24/03/2022.
//  Copyright © 2022 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProductCategoryResponse : NSObject <NSSecureCoding>
@property(nonatomic) NSDictionary *productsList;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
