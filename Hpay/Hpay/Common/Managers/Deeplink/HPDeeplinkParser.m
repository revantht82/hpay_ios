#import "HPDeeplinkParser.h"

@implementation HPDeeplinkParser

static HPDeeplinkParser *shared = nil;

// MARK: - Static
+(HPDeeplinkParser*)sharedInstance {
    static dispatch_once_t dispatchOnce;
    
    dispatch_once(&dispatchOnce,^{
        shared = [[HPDeeplinkParser alloc] init];
    });
    return shared;
}

// MARK: - Instance
-(HPDeeplinkData*)parseDeepLink:(NSURL*)url {
    struct DeeplinkValidationResult result = [HPDeeplinkParser validateDeeplinkWithURL:url];
    if (result.isValid) {
        NSString *orderId = [HPDeeplinkParser parseOrderIdFromQueryItems:result.queryItems fullURL:url.absoluteString];
        if (orderId) {
            HPDeeplinkData *data = [[HPDeeplinkData alloc] init];
            if ([result.route isEqualToString:@"GFashion"]) {
                data.type = [NSNumber numberWithInt:Pay];
            } else if ([result.route isEqualToString:@"RequestPayment"]) {
                data.type = [NSNumber numberWithInt:RequestPayment];
            } else if ([result.route isEqualToString:@"UserQR"]) {
                data.type = [NSNumber numberWithInt:UserQR];
            }
            
            data.orderId = orderId;
            return data;
        }
    }
    return nil;
}

+ (NSString *)parseOrderIdFromQueryItems:(NSArray<NSURLQueryItem *> *)queryItems fullURL:(NSString*)url{
    for (NSObject * item in queryItems) {
        NSURLQueryItem *queryItem = (NSURLQueryItem *)item;
        if ([queryItem.name caseInsensitiveCompare:@"pa"] == NSOrderedSame && queryItem.value.length > 0){
            
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"pa=([^&]*)" options:NSRegularExpressionCaseInsensitive error:nil];
            NSTextCheckingResult *match = [regex firstMatchInString:url options:0 range:NSMakeRange(0, [url length])];
            if (match) {
                NSRange matchRange = [match rangeAtIndex:1];
                NSString *pa = [url substringWithRange:matchRange];
                return pa;
            }
            else {
                return nil;
            }
            
        }
        
        if ([queryItem.name caseInsensitiveCompare:@"orderid"] == NSOrderedSame && queryItem.value.length > 0){
            return queryItem.value;
        }
    }
    return nil;
}

+ (struct DeeplinkValidationResult)validateDeeplinkWithURL:(NSURL *)url{
    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:true];
    return [HPDeeplinkParser validateDeeplinkWithURLComponents:components];
}

+ (struct DeeplinkValidationResult)validateDeeplinkWithURLString:(NSString *)urlString{
    NSURLComponents *components = [NSURLComponents componentsWithString:urlString];
    return [HPDeeplinkParser validateDeeplinkWithURLComponents:components];
}

+ (struct DeeplinkValidationResult)validateDeeplinkWithURLComponents:(NSURLComponents *)components{
    struct DeeplinkValidationResult result;
    result.queryItems = components.queryItems;
    
    if (components == nil) {
        result.isValid = NO;
        return result;
    }
    
    NSString *path = @"";
    BOOL isSameDomain = NO;
    
    if ([components.scheme isEqual:@"http"] || [components.scheme isEqual:@"https"]){
        path = components.path;
//        NSURLComponents *baseUrlComponents = [NSURLComponents componentsWithString:kMerchantBaseURL];
//        NSString *appBaseUrlString = baseUrlComponents.host;
//        NSNumber *port = baseUrlComponents.port;
//        isSameDomain = [appBaseUrlString isEqual:components.host] && (port.intValue == components.port.intValue);
        isSameDomain = YES;
    }else{
#if MOCK
        path = [NSString stringWithFormat:@"/%@", components.host];
        NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
        isSameDomain = [bundleId isEqual:components.scheme];
#else
        result.isValid = false;
        return result;
#endif
    }
    
    BOOL isValidPath = [path caseInsensitiveCompare: @"/pay"] == NSOrderedSame ||  [path caseInsensitiveCompare: @"/pay/fund"] == NSOrderedSame ||  [path caseInsensitiveCompare: @"/pay/me"] == NSOrderedSame;
    result.isValid = isSameDomain && isValidPath;
    
    NSString *route = @"";
    
    if ([path isEqualToString:@"/pay"]) {
        route = @"GFashion";
    }
    
    if ([path isEqualToString: @"/pay/fund"]) {
        route = @"RequestPayment";
    }
    
    if ([path isEqualToString: @"/pay/me"]) { //
        route = @"UserQR";
    }
    result.route = route;
    
    return result;
}

@end
