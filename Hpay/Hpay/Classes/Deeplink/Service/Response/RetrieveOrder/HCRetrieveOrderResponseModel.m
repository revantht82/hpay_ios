#import "HCRetrieveOrderResponseModel.h"

#define λ(decl, expr) (^(decl) { return (expr); })

NS_ASSUME_NONNULL_BEGIN

@interface HCRetrieveOrderResponseModel (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

#pragma mark - JSON serialization

HCRetrieveOrderResponseModel *_Nullable HCRetrieveOrderResponseModelFromData(NSData *data, NSError **error)
{
    @try {
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:error];
        return *error ? nil : [HCRetrieveOrderResponseModel fromJSONDictionary:json];
    } @catch (NSException *exception) {
        *error = [NSError errorWithDomain:@"JSONSerialization" code:-1 userInfo:@{ @"exception": exception }];
        return nil;
    }
}

HCRetrieveOrderResponseModel *_Nullable HCRetrieveOrderResponseModelFromJSON(NSString *json, NSStringEncoding encoding, NSError **error)
{
    return HCRetrieveOrderResponseModelFromData([json dataUsingEncoding:encoding], error);
}

NSData *_Nullable HCRetrieveOrderResponseModelToData(HCRetrieveOrderResponseModel *retrieveOrderResponseModel, NSError **error)
{
    @try {
        id json = [retrieveOrderResponseModel JSONDictionary];
        NSData *data = [NSJSONSerialization dataWithJSONObject:json options:kNilOptions error:error];
        return *error ? nil : data;
    } @catch (NSException *exception) {
        *error = [NSError errorWithDomain:@"JSONSerialization" code:-1 userInfo:@{ @"exception": exception }];
        return nil;
    }
}

NSString *_Nullable HCRetrieveOrderResponseModelToJSON(HCRetrieveOrderResponseModel *retrieveOrderResponseModel, NSStringEncoding encoding, NSError **error)
{
    NSData *data = HCRetrieveOrderResponseModelToData(retrieveOrderResponseModel, error);
    return data ? [[NSString alloc] initWithData:data encoding:encoding] : nil;
}

@implementation HCRetrieveOrderResponseModel
+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"LogoUrl": @"logoUrl",
        @"MerchantName": @"merchantName",
        @"ProductName": @"productName",
        @"coinId": @"coinID",
        @"coinName": @"coinName",
        @"AvailableBalance": @"availableBalance",
        @"DecimalPlace": @"decimalPlace",
        @"Price": @"price",
        @"Reference": @"reference",
        @"DateCreated": @"dateCreated",
        @"Status": @"status",
        @"PaymentExpiryTime": @"paymentExpiryTime"
    };
}

+ (_Nullable instancetype)fromData:(NSData *)data error:(NSError *_Nullable *)error
{
    return HCRetrieveOrderResponseModelFromData(data, error);
}

+ (_Nullable instancetype)fromJSON:(NSString *)json encoding:(NSStringEncoding)encoding error:(NSError *_Nullable *)error
{
    return HCRetrieveOrderResponseModelFromJSON(json, encoding, error);
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[HCRetrieveOrderResponseModel alloc] initWithJSONDictionary:dict] : nil;
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
    id resolved = HCRetrieveOrderResponseModel.properties[key];
    if (resolved) [super setValue:value forKey:resolved];
}

- (void)setNilValueForKey:(NSString *)key
{
    id resolved = HCRetrieveOrderResponseModel.properties[key];
    if (resolved) [super setValue:@(0) forKey:resolved];
}

- (NSDictionary *)JSONDictionary
{
    id dict = [[self dictionaryWithValuesForKeys:HCRetrieveOrderResponseModel.properties.allValues] mutableCopy];

    for (id jsonName in HCRetrieveOrderResponseModel.properties) {
        id propertyName = HCRetrieveOrderResponseModel.properties[jsonName];
        if (![jsonName isEqualToString:propertyName]) {
            dict[jsonName] = dict[propertyName];
            [dict removeObjectForKey:propertyName];
        }
    }

    return dict;
}

- (NSData *_Nullable)toData:(NSError *_Nullable *)error
{
    return HCRetrieveOrderResponseModelToData(self, error);
}

- (NSString *_Nullable)toJSON:(NSStringEncoding)encoding error:(NSError *_Nullable *)error
{
    return HCRetrieveOrderResponseModelToJSON(self, encoding, error);
}

@end

NS_ASSUME_NONNULL_END
