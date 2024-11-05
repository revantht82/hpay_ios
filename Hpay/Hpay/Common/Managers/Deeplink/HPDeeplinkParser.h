#import "HPDeeplinkData.h"

struct DeeplinkValidationResult {
    NSArray<NSURLQueryItem *> *queryItems;
    BOOL isValid;
    NSString *route;
};

@interface HPDeeplinkParser: NSObject
+(HPDeeplinkParser*)sharedInstance;

-(HPDeeplinkData*)parseDeepLink:(NSURL*)url;

+(NSString *)parseOrderIdFromQueryItems:(NSArray<NSURLQueryItem *> *)queryItems fullURL:(NSString*)url;

+(struct DeeplinkValidationResult)validateDeeplinkWithURLString:(NSString*)urlString;

+(struct DeeplinkValidationResult)validateDeeplinkWithURL:(NSURL*)url;

@end
