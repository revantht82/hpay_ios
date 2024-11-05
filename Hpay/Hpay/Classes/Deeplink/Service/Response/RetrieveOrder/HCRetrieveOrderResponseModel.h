#import <Foundation/Foundation.h>
#import "AppEnum.h"

@class HCRetrieveOrderResponseModel;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Object interfaces

@interface HCRetrieveOrderResponseModel : NSObject

@property (nonatomic, copy) NSString *logoUrl;
@property (nonatomic, copy) NSString *merchantName;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, assign) NSInteger coinID;
@property (nonatomic, copy) NSString *coinName;
@property (nonatomic, copy) NSString *availableBalance;
@property (nonatomic, assign) NSInteger decimalPlace;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *reference;
@property (nonatomic, copy) NSString *dateCreated;
@property (nonatomic, assign) TransactionStatusType status;
@property (nonatomic, copy) NSString *paymentExpiryTime;

- (NSString* _Nullable)hdoBalance;

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
