//
//  FPCountryList.h
//  Hpay
//
//  Created by Ugur Bozkurt on 19/08/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPCountry.h"

NS_ASSUME_NONNULL_BEGIN

@interface FPCountryList : NSObject<NSCopying>
@property(nonatomic, copy) NSString *Language;
@property(nonatomic, copy) NSArray<FPCountry *> *List;

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict;

+ (instancetype)objectFromJSONDictionary:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
