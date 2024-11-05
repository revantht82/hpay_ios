#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HPAYAnalytics : NSObject

+ (HPAYAnalytics*)sharedInstance;

- (void)track:(NSString *)event;
- (void)track:(NSString *)event properties:(NSDictionary *)properties;
- (void)pushDataToServer;

@end
