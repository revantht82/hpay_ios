//
//  LightTheme.m
//  Hpay
//
//  Created by Ugur Bozkurt on 12/11/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "LightTheme.h"

@implementation LightTheme

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
        background = [UIColor colorNamed:@"cloud"];
        surface = [UIColor colorNamed:@"white"];
        primaryOnSurface = [UIColor colorNamed:@"dark_night"];
        primaryOnBackground = [UIColor colorNamed:@"dark_night"];
        secondaryOnSurface = [UIColor colorNamed:@"dusty"];
        secondaryOnBackground = [UIColor colorNamed:@"dusty"];
        toolbar = [UIColor colorNamed:@"dark_night"];
        onToolbar = [UIColor colorNamed:@"white"];
        warning = [UIColor colorNamed:@"cranberry"];
        primaryButton = [UIColor colorNamed:@"dark_night"];
        primaryButtonOnSurface = [UIColor colorNamed:@"dark_night"];
        secondaryButton = [UIColor colorNamed:@"white"];
        toolbarLine = [UIColor colorNamed:@"light_gray"];
        verticalDivider = [UIColor colorNamed:@"light_gray"];
        controlBorder = [UIColor colorNamed:@"dark_night"];
        authBars = [UIColor colorNamed:@"dark_night"];
        passwordDot = [UIColor colorNamed:@"gray"];
        passwordDotFilled = [UIColor colorNamed:@"dark_night"];
        dashboardItem = [UIColor colorNamed:@"dark_night"];
        onDashboardItem = [UIColor colorNamed:@"white"];
        pendingStatus = [UIColor colorNamed:@"pendingYellow"];
    }
    return self;
}

-(NSString*)getImageNameForTicket {
    NSString *imageName = @"TicketLight";
    return imageName;
}

-(NSString*)getImageNameForShare {
    NSString *imageName = @"ShareLinkLight";
    return imageName;
}

-(NSString*)getImageNameForcLink {
    NSString *imageName = @"CopyLinkLight";
    return imageName;
}

@end
