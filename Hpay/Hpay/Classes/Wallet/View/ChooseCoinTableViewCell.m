#import "ChooseCoinTableViewCell.h"

@interface ChooseCoinTableViewCell ()

@end

@implementation ChooseCoinTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.topV.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, self.topV.bounds.origin.y, SCREEN_WIDTH, self.topV.bounds.size.height)].CGPath;
    self.topV.layer.shadowColor = UIColorFromRGBA(0x0045D4, 0.5).CGColor;
    self.topV.layer.shadowOffset = CGSizeMake(0, -1);
    self.topV.layer.shadowOpacity = 0.12;
    self.topV.layer.shadowRadius = 8;
    self.topV.clipsToBounds = NO;

    self.bottomV.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, self.bottomV.bounds.origin.y, SCREEN_WIDTH, self.bottomV.bounds.size.height)].CGPath;
    self.bottomV.layer.shadowColor = UIColorFromRGBA(0x0045D4, 0.5).CGColor;
    self.bottomV.layer.shadowOffset = CGSizeMake(0, 1);
    self.bottomV.layer.shadowOpacity = 0.12;
    self.topV.layer.shadowRadius = 8;
    self.bottomV.clipsToBounds = NO;

    self.clipsToBounds = NO;
    [self applyTheme];
}

- (void)applyTheme{
    self.bottomV.backgroundColor = [self getCurrentTheme].surface;
    self.nameLabel.textColor = [self getCurrentTheme].primaryOnSurface;
    self.useableLabel.textColor = [self getCurrentTheme].primaryOnSurface;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self applyTheme];
}

@end
