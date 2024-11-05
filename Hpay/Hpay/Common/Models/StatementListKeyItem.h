//
//  StatementListKeyItem.h
//  Hpay
//
//  Created by Ugur Bozkurt on 29/11/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPStatementOM.h"

NS_ASSUME_NONNULL_BEGIN

@interface StatementListKeyItem : NSObject<NSCopying>

@property(nonatomic, strong) NSString *key;
@property(nonatomic, strong) NSDate *date;

+(instancetype)itemWithObject:(FPStatementOM *)object;

@end

NS_ASSUME_NONNULL_END
