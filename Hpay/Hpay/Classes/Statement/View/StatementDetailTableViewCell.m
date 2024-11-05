#import "StatementDetailTableViewCell.h"

@implementation StatementDetailTableViewCell

- (void)awakeFromNib{
    [super awakeFromNib];
    [self applyTheme];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self applyTheme];
}

- (void)applyTheme{
    self.backgroundColor = [self getCurrentTheme].background;
    self.nameLabel.textColor = [self getCurrentTheme].primaryOnBackground;
    self.valLabel.textColor = [self getCurrentTheme].secondaryOnBackground;
}

@end
