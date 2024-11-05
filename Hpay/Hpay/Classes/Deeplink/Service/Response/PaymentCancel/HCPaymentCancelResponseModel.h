#import <Foundation/Foundation.h>
#import "AppEnum.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Object interfaces

@interface HCPaymentCancelResponseModel : NSObject
@property (nonatomic, assign) TransactionStatusType status;

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
