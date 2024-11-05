#import "FPViewController.h"
#import "PINSetType.h"

@interface PINSetViewController : FPViewController
@property(nonatomic, assign) PINSetType PINSetType;
@property(nonatomic, copy) NSString *oldPin;
@property(nonatomic, copy) NSString *pinCode;
@property(nonatomic, copy) NSString *pinText;
@property(nonatomic, copy) NSString *smsCode;

- (void)clearPIN;
@end
