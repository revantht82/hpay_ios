#import "TransferInfoReceiverListHeaderView.h"

@interface TransferInfoReceiverListHeaderView ()

@end

@implementation TransferInfoReceiverListHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self applyTheme];
}

- (void)applyTheme {
    id<ThemeProtocol> theme = [self getCurrentTheme];
    self.backgroundColor = theme.background;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [self applyTheme];
}

@end
