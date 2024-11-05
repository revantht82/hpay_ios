#import "ReceiverListViewCell.h"

@interface ReceiverListViewCell ()

@end

@implementation ReceiverListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self applyTheme];
}

- (void)applyTheme {
    self.backgroundColor = [self getCurrentTheme].surface;
    self.name.textColor = [self getCurrentTheme].primaryOnSurface;
    self.removeBtn.tintColor = [self getCurrentTheme].primaryOnBackground;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [self applyTheme];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setHighlighted:selected animated:false];
}

@end
