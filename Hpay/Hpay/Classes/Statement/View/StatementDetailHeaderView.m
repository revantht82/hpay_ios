//
//  StatementDetailHeaderView.m
//  FiiiPay
//
//  Created by apple on 2018/3/27.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "StatementDetailHeaderView.h"

@implementation StatementDetailHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self applyTheme];
    [NSTimer scheduledTimerWithTimeInterval:10.0
        target:self
        selector:@selector(updateExpirationLabel)
        userInfo:nil
        repeats: true];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [self applyTheme];
}

- (void)applyTheme{
    self.backgroundColor = [self getCurrentTheme].background;
    self.cardImageView.tintColor = [self getCurrentTheme].surface;
}

-(void)updateExpirationLabel {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *expirationDate = [dateFormatter dateFromString:_expirationTime];
    NSDate *currentDate = [NSDate date];
    int totalSeconds = [expirationDate timeIntervalSinceDate:currentDate];
    int hours = totalSeconds/3600;
    int minutes = (totalSeconds / 60) % 60;
    _expirationTimeLabel.text = [NSString stringWithFormat:@"%d:%d", hours, minutes];
}

@end
