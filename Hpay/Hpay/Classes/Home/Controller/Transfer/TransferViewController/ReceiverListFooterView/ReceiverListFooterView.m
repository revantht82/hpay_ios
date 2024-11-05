#import "ReceiverListFooterView.h"
#import "DecimalUtils.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface ReceiverListFooterView ()

@end

@implementation ReceiverListFooterView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self applyTheme];
}

- (void)applyTheme {
    id<ThemeProtocol> theme = [self getCurrentTheme];
    
    self.backgroundColor = theme.background;
    [self.addMoreBtn setTitleColor:theme.primaryOnBackground forState:UIControlStateNormal];
    self.addMoreBtn.tintColor = theme.primaryOnBackground;
    self.addMoreBtn.borderColor = theme.controlBorder;
    self.addMoreBtn.backgroundColor = theme.background;
    self.addMoreBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [self applyTheme];
}

@end
