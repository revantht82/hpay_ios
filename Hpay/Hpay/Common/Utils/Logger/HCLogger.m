//
//  HCLogger.m
//  Hpay
//
//  Created by Olgu Sirman on 08/07/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "HCLogger.h"
#import "FIRCrashlytics.h"

@implementation HCLogger

+ (void)recordErrorWithError:(NSError * _Nullable)error {
    [[FIRCrashlytics crashlytics] recordError:error];
}

@end
