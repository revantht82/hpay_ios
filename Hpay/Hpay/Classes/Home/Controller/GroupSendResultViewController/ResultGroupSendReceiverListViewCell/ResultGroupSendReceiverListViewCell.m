#import "ResultGroupSendReceiverListViewCell.h"

@interface ResultGroupSendReceiverListViewCell ()

@end

@implementation ResultGroupSendReceiverListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self applyTheme];
}

- (void)applyTheme {
    self.backgroundColor = [self getCurrentTheme].surface;
    self.name.textColor = [self getCurrentTheme].primaryOnSurface;
    self.amount.textColor = [self getCurrentTheme].primaryOnSurface;
    self.coin.textColor = [self getCurrentTheme].primaryOnSurface;
    
    [self setValueToAmount:@""];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [self applyTheme];
}

-(void)setValueToAmount:(NSString*)value {
    self.amount.text = value;
    
    CGRect frame = self.amount.frame;
    frame.size.width = self.amount.intrinsicContentSize.width;
    if (frame.size.width < 30){
        frame.size.width = 30;
    }
    frame.origin.y = frame.origin.y + frame.size.height + 1;
    frame.origin.x = self.amount.frame.origin.x + self.amount.frame.size.width - frame.size.width;
    frame.size.height = 1;
    self.line.frame = frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setHighlighted:selected animated:false];
}

@end
