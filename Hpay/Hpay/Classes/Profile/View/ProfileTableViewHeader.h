#import <UIKit/UIKit.h>
#import "ProfileImageView.h"

@interface ProfileTableViewHeader : UIView

@property(weak, nonatomic) IBOutlet ProfileImageView *profileImageView;
@property(weak, nonatomic) IBOutlet UIButton *nameBtn;
@property(weak, nonatomic) IBOutlet UILabel *nameLabel;
@property(weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *QRCodeBtn;
@property (weak, nonatomic) IBOutlet UILabel *hid;

@end
