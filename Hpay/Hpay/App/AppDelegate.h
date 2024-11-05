//
//  AppDelegate.h
//  FiiiPay
//
//  Created by Singer on 2018/3/23.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OIDExternalUserAgentSession;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(strong, nonatomic) UIWindow * _Nullable window;
@property(nonatomic, strong, nullable) id<OIDExternalUserAgentSession> currentAuthorizationFlow;
+ (UIWindow *)keyWindow;
@property(strong, nonatomic) NSString * _Nullable appLive;
@end

