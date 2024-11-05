#import "FPViewController.h"
#import "HCRetrieveOrderResponseModel.h"

@protocol PayMerchantViewControllerDelegate <NSObject>
-(void)recoveredWithRetrieveOrderResponseModel:(HCRetrieveOrderResponseModel* _Nonnull)model;
-(void)dismissFlow;
@end

@interface PayMerchantViewController : FPViewController<PayMerchantViewControllerDelegate>

@property(nonatomic, copy) NSString* _Nonnull orderId;

@end
