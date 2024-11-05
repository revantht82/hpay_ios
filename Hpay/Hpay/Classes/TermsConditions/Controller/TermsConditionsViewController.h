#import "FPViewController.h"

@protocol TermsConditionsViewControllerDelegate <NSObject>
- (void)conditionsAccepted;
@end

@interface TermsConditionsViewController : FPViewController

@property(nonatomic, weak) id <TermsConditionsViewControllerDelegate> delegate;

@end
