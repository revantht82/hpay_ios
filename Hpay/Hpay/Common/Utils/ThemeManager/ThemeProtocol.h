//
//  ThemeProtocol.h
//  Hpay
//
//  Created by Ugur Bozkurt on 12/11/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ThemeProtocol <NSObject>
@property (strong, nonatomic) UIColor *background;
@property (strong, nonatomic) UIColor *surface;
@property (strong, nonatomic) UIColor *primaryOnSurface;
@property (strong, nonatomic) UIColor *primaryOnBackground;
@property (strong, nonatomic) UIColor *secondaryOnSurface;
@property (strong, nonatomic) UIColor *secondaryOnBackground;
@property (strong, nonatomic) UIColor *toolbar;
@property (strong, nonatomic) UIColor *onToolbar;
@property (strong, nonatomic) UIColor *warning;
@property (strong, nonatomic) UIColor *primaryButton;
@property (strong, nonatomic) UIColor *primaryButtonOnSurface;
@property (strong, nonatomic) UIColor *secondaryButton;
@property (strong, nonatomic) UIColor *toolbarLine;
@property (strong, nonatomic) UIColor *verticalDivider;
@property (strong, nonatomic) UIColor *controlBorder;
@property (strong, nonatomic) UIColor *authBars;
@property (strong, nonatomic) UIColor *passwordDot;
@property (strong, nonatomic) UIColor *passwordDotFilled;
@property (strong, nonatomic) UIColor *dashboardItem;
@property (strong, nonatomic) UIColor *onDashboardItem;
@property (strong, nonatomic) UIColor *pendingStatus;

-(NSString*)getImageNameForTicket;
-(NSString*)getImageNameForShare;
-(NSString*)getImageNameForcLink;

@end

NS_ASSUME_NONNULL_END
