//
//  NSObject+Extension.m
//  Hpay
//
//  Created by Ugur Bozkurt on 23/07/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "NSObject+Extension.h"

@implementation NSObject (Extension)

- (BOOL)isNetworkConnected{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

- (BOOL)isShowingVerifyPinViewController{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kIsShowingVerifyPinKey];
}

- (void)setIsShowingVerifyPinViewController:(BOOL)isShowingVerifyPinViewController{
    [[NSUserDefaults standardUserDefaults] setBool:isShowingVerifyPinViewController forKey:kIsShowingVerifyPinKey];
}

@end
