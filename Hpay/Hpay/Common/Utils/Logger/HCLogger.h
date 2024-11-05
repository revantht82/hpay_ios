//
//  HCLogger.h
//  Hpay
//
//  Created by Olgu Sirman on 08/07/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCLogger : NSObject

+ (void)recordErrorWithError:(NSError * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
