#import "HCPaymentCreateResponseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HCPaymentCreateResponseModel (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

#pragma mark - JSON serialization

HCPaymentCreateResponseModel *_Nullable HCPaymentCreateResponseModelFromData(NSData *data, NSError **error)
{
    @try {
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:error];
        return *error ? nil : [HCPaymentCreateResponseModel fromJSONDictionary:json];
    } @catch (NSException *exception) {
        *error = [NSError errorWithDomain:@"JSONSerialization" code:-1 userInfo:@{ @"exception": exception }];
        return nil;
    }
}

HCPaymentCreateResponseModel *_Nullable HCPaymentCreateResponseModelFromJSON(NSString *json, NSStringEncoding encoding, NSError **error)
{
    return HCPaymentCreateResponseModelFromData([json dataUsingEncoding:encoding], error);
}

NSData *_Nullable HCPaymentCreateResponseModelToData(HCPaymentCreateResponseModel *paymentCreateResponseModel, NSError **error)
{
    @try {
        id json = [paymentCreateResponseModel JSONDictionary];
        NSData *data = [NSJSONSerialization dataWithJSONObject:json options:kNilOptions error:error];
        return *error ? nil : data;
    } @catch (NSException *exception) {
        *error = [NSError errorWithDomain:@"JSONSerialization" code:-1 userInfo:@{ @"exception": exception }];
        return nil;
    }
}

NSString *_Nullable HCPaymentCreateResponseModelToJSON(HCPaymentCreateResponseModel *paymentCreateResponseModel, NSStringEncoding encoding, NSError **error)
{
    NSData *data = HCPaymentCreateResponseModelToData(paymentCreateResponseModel, error);
    return data ? [[NSString alloc] initWithData:data encoding:encoding] : nil;
}

@implementation HCPaymentCreateResponseModel
+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"OrderId": @"orderID",
        @"coinName" : @"coinName",
        @"OrderNo": @"orderNo",
        @"Timestamp": @"timestamp",
        @"amount": @"amount",
        @"type": @"type",
        @"status": @"status"
    };
}

+ (_Nullable instancetype)fromData:(NSData *)data error:(NSError *_Nullable *)error
{
    return HCPaymentCreateResponseModelFromData(data, error);
}

+ (_Nullable instancetype)fromJSON:(NSString *)json encoding:(NSStringEncoding)encoding error:(NSError *_Nullable *)error
{
    return HCPaymentCreateResponseModelFromJSON(json, encoding, error);
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[HCPaymentCreateResponseModel alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    id resolved = HCPaymentCreateResponseModel.properties[key];
    if (resolved) [super setValue:value forKey:resolved];
}

- (void)setNilValueForKey:(NSString *)key
{
    id resolved = HCPaymentCreateResponseModel.properties[key];
    if (resolved) [super setValue:@(0) forKey:resolved];
}

- (NSDictionary *)JSONDictionary
{
    id dict = [[self dictionaryWithValuesForKeys:HCPaymentCreateResponseModel.properties.allValues] mutableCopy];

    for (id jsonName in HCPaymentCreateResponseModel.properties) {
        id propertyName = HCPaymentCreateResponseModel.properties[jsonName];
        if (![jsonName isEqualToString:propertyName]) {
            dict[jsonName] = dict[propertyName];
            [dict removeObjectForKey:propertyName];
        }
    }

    return dict;
}

- (NSData *_Nullable)toData:(NSError *_Nullable *)error
{
    return HCPaymentCreateResponseModelToData(self, error);
}

- (NSString *_Nullable)toJSON:(NSStringEncoding)encoding error:(NSError *_Nullable *)error
{
    return HCPaymentCreateResponseModelToJSON(self, encoding, error);
}
@end

NS_ASSUME_NONNULL_END
