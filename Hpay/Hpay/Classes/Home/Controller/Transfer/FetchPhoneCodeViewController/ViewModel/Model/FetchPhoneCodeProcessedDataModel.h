//
//  FetchPhoneCodeProcessedDataModel.h
//  Hpay
//
//  Created by Olgu Sirman on 18/01/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FPCountry;

NS_ASSUME_NONNULL_BEGIN

@interface FetchPhoneCodeProcessedDataModel : NSObject

@property(copy, nonatomic) NSArray <NSDictionary <NSString *, NSArray<FPCountry *> *> *> *dataArray;
@property(copy, nonatomic) NSArray<NSString *> *indexArray;

@end

NS_ASSUME_NONNULL_END
