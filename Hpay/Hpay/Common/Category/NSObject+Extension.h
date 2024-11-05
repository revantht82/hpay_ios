//
//  NSObject+Extension.h
//  Hpay
//
//  Created by Ugur Bozkurt on 23/07/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>

NS_ASSUME_NONNULL_BEGIN

#define kIsShowingVerifyPinKey @"is-showing-verify-pin-view-controller"

@interface NSObject (Extension)

@property(nonatomic, assign) BOOL isShowingVerifyPinViewController;

- (BOOL)isNetworkConnected;

@end

NS_ASSUME_NONNULL_END
