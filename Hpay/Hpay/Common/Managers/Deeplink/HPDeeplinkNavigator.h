#import "HPDeeplinkData.h"

@interface HPDeeplinkNavigator: NSObject

+(HPDeeplinkNavigator*)sharedInstance;

-(void)proceedToDeeplinkWithData:(HPDeeplinkData*)data;

@end
