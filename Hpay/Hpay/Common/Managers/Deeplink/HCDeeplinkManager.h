typedef enum {
    Pay = 0
} DeeplinkType;

@interface HPDeeplinkManager: NSObject
@property (nonatomic, assign) DeeplinkType *deeplinkType;

+(HPDeeplinkManager*)sharedManager;

-(void)checkDeeplink;
-(BOOL)handleDeeplinkWithURL:(NSURL*)URL;
-(void)handleRemoteNotification:(NSDictionary*)notification;
@end
