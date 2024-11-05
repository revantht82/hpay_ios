#import <UIKit/UIKit.h>

@interface ChooseCoinTableViewCell : UITableViewCell
@property(weak, nonatomic) IBOutlet UIView *topV;
@property(weak, nonatomic) IBOutlet UIView *bottomV;
@property(weak, nonatomic) IBOutlet UIImageView *leftLineImageView;
@property(weak, nonatomic) IBOutlet UILabel *nameLabel;
@property(weak, nonatomic) IBOutlet UILabel *codeLabel;
@property(weak, nonatomic) IBOutlet UILabel *useableLabel;

@end
