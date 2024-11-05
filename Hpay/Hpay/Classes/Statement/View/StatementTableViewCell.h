#import <UIKit/UIKit.h>
#import "FPStatementOM.h"

@interface StatementTableViewCell : UITableViewCell
@property(weak, nonatomic) IBOutlet UIView *viewContainer;
@property(weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property(weak, nonatomic) IBOutlet UILabel *typeLabel;
@property(weak, nonatomic) IBOutlet UILabel *statusLabel;
@property(weak, nonatomic) IBOutlet UILabel *timeLabel;
@property(weak, nonatomic) IBOutlet UILabel *amountLabel;

- (void)setCellInfo:(FPStatementOM *)model;
@end
