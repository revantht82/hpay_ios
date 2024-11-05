#import "ReceiverListHeaderView.h"

@interface ReceiverListHeaderView ()

@end

@implementation ReceiverListHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self applyTheme];
}

- (void)applyTheme {
    self.backgroundColor = [self getCurrentTheme].background;
    self.placeTips.textColor = [self getCurrentTheme].secondaryOnBackground;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [self applyTheme];
}

@end
