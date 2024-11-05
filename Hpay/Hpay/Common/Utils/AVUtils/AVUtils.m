//
//  AVUtils.m
//  Hpay
//
//  Created by Olgu Sirman on 31/12/2020.
//  Copyright © 2020 Himalaya. All rights reserved.
//

#import "AVUtils.h"
#import <AVFoundation/AVFoundation.h>

@implementation AVUtils

+ (BOOL)isAuthorisedForVideoAccess {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    return !(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied);
}

@end
