#import "HimalayaPayAPIManager.h"
#import "HPAYAnalytics.h"
#import "NSDate+Extension.h"

#define eventLimitToSend 5
#define HPAYAnalyticsEventsDefaultsKey @"HPAYAnalyticsEvents"
//#define HPAYAnalyticsEventsDefaultsKeyTmp @"HPAYAnalyticsEventsTmp"

@interface HPAYAnalytics()

@property BOOL sendRunning;
//@property (nonatomic, strong) NSMutableDictionary *userProperties;
//@property (nonatomic, strong) NSTimer *timer;

@end

@implementation HPAYAnalytics

static HPAYAnalytics* gSingleton = nil;

+ (HPAYAnalytics*)sharedInstance
{
    if (nil == gSingleton)
    {
        gSingleton = [[HPAYAnalytics alloc] init];
    }
    
    return gSingleton;
}

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    if (self) {
        //self.userProperties = [NSMutableDictionary dictionary];
        self.sendRunning = NO;
    }
    
    return self;
}

- (void)track:(NSString *)event
{
    [self track:event properties:nil];
}

- (void)track:(NSString *)event properties:(NSDictionary *)properties
{
    //HPAYAnalytics IS DISABLED FOR NOW
    return;
    
    // check parameters
    if (event == nil || [event length] == 0)
    {
        NSLog(@"HPAYAnalytics: empty event given.");
        return;
    }
    
    if (!properties){
        properties = @{};
    }
    
    NSError *err;
    NSData *jsonData = [NSJSONSerialization  dataWithJSONObject:properties options:0 error:&err];
    NSString *propertiesString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
    
    if (err){
        NSLog(@"Failed to track event");
        return;
    }
    
    @try {
        NSDictionary *eventData = @{
            @"TimeStamp": [NSString stringWithFormat:@"%lld", [NSDate getDateTimeTOMilliSeconds:[NSDate date]]],
            @"EventName": event,
            @"EventType": @"user_event",
            @"EventParams": propertiesString
        };
        
        NSMutableArray *events = [[self getEvents] mutableCopy];
        [events addObject:eventData];
        
        if ([events count] >= eventLimitToSend) {
            [self storeEvents:nil];
            [self sendEvents:events];
        } else {
            [self storeEvents:events];
        }
    } @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
        //[self storeEvents:nil];
    }
}


-(void)sendEvents:(NSArray*)events {
    //HPAYAnalytics IS DISABLED FOR NOW
    return;
    
    NSLog(@"sendEvents");
    if (events && [events isKindOfClass:[NSArray class]] && [events count] > 0) {
        
        if (self.sendRunning){
            NSMutableArray *old_events = [[self getEvents] mutableCopy];
            [old_events addObjectsFromArray:events];
            [self storeEvents:old_events];
            return;
        }
        self.sendRunning = YES;
        
        //NSLog(@"stat request sent");
        [HimalayaPayAPIManager POST:InternalAnalyticsEndPoint parameters:@{@"Events": events} successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
            
            //NSLog(@"Stats sent: %@", data);
            self.sendRunning = NO;
            
        } failureBlock:^(NSInteger code, NSString *_Nullable message) {
            //NSLog(@"%ld", (long)code);
            //NSLog(@"%@", message);
            NSMutableArray *old_events = [[self getEvents] mutableCopy];
            [old_events addObjectsFromArray:events];
            [self storeEvents:old_events];
            self.sendRunning = NO;
        }];
    }
}

-(void)storeEvents:(NSArray*)events {
    [[NSUserDefaults standardUserDefaults] setValue:events forKey:HPAYAnalyticsEventsDefaultsKey];
}

-(NSArray*)getEvents {
    NSArray *events = [[NSUserDefaults standardUserDefaults] valueForKey:HPAYAnalyticsEventsDefaultsKey];
    if (![events isKindOfClass:[NSArray class]]) {
        events = [[NSArray alloc] init];
    }
    return events;
}

-(void)pushDataToServer{
    //HPAYAnalytics IS DISABLED FOR NOW
    return;
    
    //NSLog(@"pushDataToServer");
    NSArray *events = [self getEvents];
    
    if ([events count] > 0){
        [self storeEvents:nil];
        [self sendEvents:events];
    }
    
}

@end
