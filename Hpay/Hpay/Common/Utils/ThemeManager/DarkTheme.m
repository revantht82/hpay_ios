//
//  DarkTheme.m
//  Hpay
//
//  Created by Ugur Bozkurt on 12/11/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "DarkTheme.h"

@implementation DarkTheme

@synthesize background;
@synthesize surface;
@synthesize primaryOnSurface;
@synthesize primaryOnBackground;
@synthesize secondaryOnSurface;
@synthesize secondaryOnBackground;
@synthesize toolbar;
@synthesize onToolbar;
@synthesize warning;
@synthesize primaryButton;
@synthesize primaryButtonOnSurface;
@synthesize toolbarLine;
@synthesize verticalDivider;
@synthesize controlBorder;
@synthesize authBars;
@synthesize passwordDot;
@synthesize dashboardItem;
@synthesize onDashboardItem;
@synthesize passwordDotFilled;
@synthesize secondaryButton;
@synthesize pendingStatus;

- (instancetype)init
{
    self = [super init];
    if (self) {
        background = [UIColor colorNamed:@"dark_night"];
        surface = [UIColor colorNamed:@"moon_light"];
        primaryOnSurface = [UIColor colorNamed:@"white"];
        primaryOnBackground = [UIColor colorNamed:@"white"];
        secondaryOnSurface = [UIColor colorNamed:@"dusty"];
        secondaryOnBackground = [UIColor colorNamed:@"dusty"];
        toolbar = [UIColor colorNamed:@"dark_night"];
        onToolbar = [UIColor colorNamed:@"white"];
        warning = [UIColor colorNamed:@"cranberry"];
        primaryButton = [UIColor colorNamed:@"moon_light"];
        primaryButtonOnSurface = [UIColor colorNamed:@"dark_night"];
        secondaryButton = [UIColor colorNamed:@"white"];
        toolbarLine = [UIColor colorNamed:@"mari_gold"];
        verticalDivider = [UIColor colorNamed:@"mari_gold"];
        controlBorder = [UIColor colorNamed:@"mari_gold"];
        authBars = [UIColor colorNamed:@"dark_night"];
        passwordDot = [UIColor colorNamed:@"gray"];
        passwordDotFilled = [UIColor colorNamed:@"gray"];
        dashboardItem = [UIColor colorNamed:@"moon_light"];
        onDashboardItem = [UIColor colorNamed:@"white"];
        pendingStatus = [UIColor colorNamed:@"pendingYellow"];
    }
    return self;
}

-(NSString*)getImageNameForTicket {
    NSString *imageName = @"TicketDark";
    return imageName;
}

-(NSString*)getImageNameForShare {
    NSString *imageName = @"ShareLinkDark";
    return imageName;
}

-(NSString*)getImageNameForcLink {
    NSString *imageName = @"CopyLinkDark";
    return imageName;
}

@end
