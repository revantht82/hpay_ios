#import "NotificationCenterTableViewCell.h"
#import "DecimalUtils.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface NotificationCenterTableViewCell ()

@end

@implementation NotificationCenterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self applyTheme];
}

- (void)applyTheme {
    self.viewContainer.backgroundColor = [self getCurrentTheme].surface;
    self.titleLabel.textColor = [self getCurrentTheme].primaryOnSurface;
    self.messageLabel.textColor = [self getCurrentTheme].primaryOnSurface;
    self.timeLabel.textColor = [self getCurrentTheme].secondaryOnSurface;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [self applyTheme];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setHighlighted:selected animated:false];
}

- (void)setCellInfo:(FPNotificationCenterOM *)model {
    self.titleLabel.text = model.Title;
    self.messageLabel.text = model.Message;
    self.timeLabel.text = [model utc2Local];
    if ([model.IsRead isEqualToString:@"0"]) {
        self.redDotLable.hidden = NO;
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    }
    else {
        self.redDotLable.hidden = YES;
        [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
    }
}

@end
