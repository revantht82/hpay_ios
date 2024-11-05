#import <UIKit/UIKit.h>
#import "HCAmountTextField.h"

@interface ResultGroupSendReceiverListViewCell : UITableViewCell
-(void)setValueToAmount:(NSString*)value;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UILabel *coin;
@property (weak, nonatomic) IBOutlet HCAmountTextField *amount;
@property (weak, nonatomic) IBOutlet UIImageView *resultIcon;
@property (weak, nonatomic) IBOutlet UIImageView *errorIcon;

@end
