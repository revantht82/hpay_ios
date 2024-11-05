#import "HCPaymentCancelResponseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HCPaymentCancelResponseModel (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

#pragma mark - JSON serialization

HCPaymentCancelResponseModel *_Nullable HCPaymentCancelResponseModelFromData(NSData *data, NSError **error)
{
    @try {
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:error];
        return *error ? nil : [HCPaymentCancelResponseModel fromJSONDictionary:json];
    } @catch (NSException *exception) {
        *error = [NSError errorWithDomain:@"JSONSerialization" code:-1 userInfo:@{ @"exception": exception }];
        return nil;
    }
}

HCPaymentCancelResponseModel *_Nullable HCPaymentCancelResponseModelFromJSON(NSString *json, NSStringEncoding encoding, NSError **error)
{
    return HCPaymentCancelResponseModelFromData([json dataUsingEncoding:encoding], error);
}

NSData *_Nullable HCPaymentCancelResponseModelToData(HCPaymentCancelResponseModel *paymentCancelResponseModel, NSError **error)
{
    @try {
        id json = [paymentCancelResponseModel JSONDictionary];
        NSData *data = [NSJSONSerialization dataWithJSONObject:json options:kNilOptions error:error];
        return *error ? nil : data;
    } @catch (NSException *exception) {
        *error = [NSError errorWithDomain:@"JSONSerialization" code:-1 userInfo:@{ @"exception": exception }];
        return nil;
    }
}

NSString *_Nullable HCPaymentCancelResponseModelToJSON(HCPaymentCancelResponseModel *paymentCancelResponseModel, NSStringEncoding encoding, NSError **error)
{
    NSData *data = HCPaymentCancelResponseModelToData(paymentCancelResponseModel, error);
    return data ? [[NSString alloc] initWithData:data encoding:encoding] : nil;
}

@implementation HCPaymentCancelResponseModel
+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"status": @"status"
    };
}

+ (_Nullable instancetype)fromData:(NSData *)data error:(NSError *_Nullable *)error
{
    return HCPaymentCancelResponseModelFromData(data, error);
}

+ (_Nullable instancetype)fromJSON:(NSString *)json encoding:(NSStringEncoding)encoding error:(NSError *_Nullable *)error
{
    return HCPaymentCancelResponseModelFromJSON(json, encoding, error);
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[HCPaymentCancelResponseModel alloc] initWithJSONDictionary:dict] : nil;
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
    id resolved = HCPaymentCancelResponseModel.properties[key];
    if (resolved) [super setValue:value forKey:resolved];
}

- (void)setNilValueForKey:(NSString *)key
{
    id resolved = HCPaymentCancelResponseModel.properties[key];
    if (resolved) [super setValue:@(0) forKey:resolved];
}

- (NSDictionary *)JSONDictionary
{
    id dict = [[self dictionaryWithValuesForKeys:HCPaymentCancelResponseModel.properties.allValues] mutableCopy];

    for (id jsonName in HCPaymentCancelResponseModel.properties) {
        id propertyName = HCPaymentCancelResponseModel.properties[jsonName];
        if (![jsonName isEqualToString:propertyName]) {
            dict[jsonName] = dict[propertyName];
            [dict removeObjectForKey:propertyName];
        }
    }

    return dict;
}

- (NSData *_Nullable)toData:(NSError *_Nullable *)error
{
    return HCPaymentCancelResponseModelToData(self, error);
}

- (NSString *_Nullable)toJSON:(NSStringEncoding)encoding error:(NSError *_Nullable *)error
{
    return HCPaymentCancelResponseModelToJSON(self, encoding, error);
}
@end

NS_ASSUME_NONNULL_END
