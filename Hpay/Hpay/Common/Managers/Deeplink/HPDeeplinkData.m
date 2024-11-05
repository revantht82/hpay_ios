#import "HPDeeplinkData.h"

@implementation HPDeeplinkData

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.orderId = [aDecoder decodeObjectForKey:@"orderId"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.orderId forKey:@"orderId"];
}

+ (BOOL)supportsSecureCoding {
   return YES;
}

- (void)saveToLocal{
    //NSLog(@"%@", self);
    //NSError * error;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self requiringSecureCoding:YES error:nil];
    //NSLog(@"%@", error);
    //NSLog(@"%@", data);
    [NSUserDefaults.standardUserDefaults setObject:data forKey:@"HPDeeplinkData"];
}

- (void)clearLocal{
    [NSUserDefaults.standardUserDefaults removeObjectForKey:@"HPDeeplinkData"];
}

+ (HPDeeplinkData *)retrieveFromLocal{
    NSData *data = [NSUserDefaults.standardUserDefaults objectForKey:@"HPDeeplinkData"];
    return [NSKeyedUnarchiver unarchivedObjectOfClass:[HPDeeplinkData class] fromData:data error:nil];
    
}

@end
