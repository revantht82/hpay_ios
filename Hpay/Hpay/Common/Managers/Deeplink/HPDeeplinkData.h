@interface HPDeeplinkData: NSObject <NSCoding, NSSecureCoding>

typedef enum : NSInteger {
    Pay = 1,
    RequestPayment = 2,
    UserQR = 3
} DeeplinkType;

@property(nonatomic, assign) NSNumber *type;
@property(nonatomic, copy) NSString *orderId;

- (void)saveToLocal;
- (void)clearLocal;
+ (HPDeeplinkData *)retrieveFromLocal;

@end
