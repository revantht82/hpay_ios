//
//  FetchPhoneCodeTableViewCell.m
//  Hpay
//
//  Created by Olgu Sirman on 10/12/2020.
//  Copyright © 2020 Himalaya. All rights reserved.
//

#import "FetchPhoneCodeTableViewCell.h"
#import "FPCountry.h"

@implementation FetchPhoneCodeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        [self applyTheme];
    }
    return self;
}

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [self initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        [self applyTheme];
    }
    return self;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self applyTheme];
}

-(void)configureWith:(FPCountry *)country selectPhoneCode:(NSString *)selectPhoneCode {
    self.textLabel.text = country.Name;
    self.detailTextLabel.text = [NSString stringWithFormat:@"%@", country.PhoneCode];
}

- (void)applyTheme{
    self.backgroundColor = [self getCurrentTheme].surface;
    self.textLabel.font = UIFontMake(14);
    self.textLabel.textColor = [self getCurrentTheme].primaryOnSurface;
    self.detailTextLabel.font = UIFontMake(16);
    self.detailTextLabel.textColor = [self getCurrentTheme].primaryOnSurface;
}

@end
