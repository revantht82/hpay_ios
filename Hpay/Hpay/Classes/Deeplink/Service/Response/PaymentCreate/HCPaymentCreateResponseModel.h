#import <Foundation/Foundation.h>
#import "AppEnum.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Object interfaces

@interface HCPaymentCreateResponseModel : NSObject
@property (nonatomic, copy)   NSString *orderID;
@property (nonatomic, copy)   NSString *orderNo;
@property (nonatomic, assign) NSInteger timestamp;
@property (nonatomic, assign) NSString *coinName;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy)   NSString *type;
@property (nonatomic, assign) TransactionStatusType status;

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
