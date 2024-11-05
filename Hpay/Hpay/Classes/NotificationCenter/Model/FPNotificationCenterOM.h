#import "FPBaseModel.h"

@interface FPNotificationCenterOM : FPBaseModel

@property(nonatomic, copy) NSString *NotificationId;
@property(nonatomic, copy) NSString *Title;
@property(nonatomic, copy) NSString *Message;
@property(nonatomic, copy) NSString *Timestamp;
@property(nonatomic, copy) NSString *IsRead;

+ (NSDictionary *)mDataReplaceDictionary;

+ (NSArray *)mModelArrayWithData:(NSArray *)data;

+ (instancetype)mModelWithData:(NSDictionary *)data;

- (NSString *)dateGroupTitle;
- (NSString *)utc2Local;
@end
