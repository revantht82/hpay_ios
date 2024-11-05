#import <UIKit/UIKit.h>
#import "FPNotificationCenterOM.h"

@interface NotificationCenterTableViewCell : UITableViewCell
@property(weak, nonatomic) IBOutlet UIView *viewContainer;
@property(weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(weak, nonatomic) IBOutlet UILabel *messageLabel;
@property(weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *redDotLable;

- (void)setCellInfo:(FPNotificationCenterOM *)model;
@end
