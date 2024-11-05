//
//  ProfileListItem.m
//  Hpay
//
//  Created by Ugur Bozkurt on 24/11/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "ProfileListItem.h"

@implementation ProfileListItem

+ (instancetype)itemWithTitle:(NSString *)title leftIcon:(UIImage *)leftIcon rightText:(NSString *)rightText clickHandler:(ProfileListItemClickHandler)clickHandler{
    return [[self alloc] initWithTitle:title leftIcon:leftIcon rightText:rightText clickHandler:clickHandler];
}

+ (instancetype)itemWithTitle:(NSString *)title leftIcon:(UIImage *)leftIcon clickHandler:(ProfileListItemClickHandler)clickHandler{
    return [[self alloc] initWithTitle:title leftIcon:leftIcon rightText:NULL clickHandler:clickHandler];
}

- (instancetype)initWithTitle:(NSString *)title leftIcon:(UIImage *)leftIcon rightText:(NSString *)rightText clickHandler:(ProfileListItemClickHandler)clickHandler{
    self = [super init];
    if (self) {
        self.title = title;
        self.leftIcon = leftIcon;
        self.rightText = rightText;
        self.clickHandler = clickHandler;
    }
    return self;
}

- (ProfileTableViewCell *)configureCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    ProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileTableViewCell" forIndexPath:indexPath];
    cell.iconImageView.image = self.leftIcon;
    //cell.iconImageView = self.leftIcon;
    cell.titleLabel.text = self.title;
    cell.rightLabel.text = self.rightText;
    return cell;
}

@end
