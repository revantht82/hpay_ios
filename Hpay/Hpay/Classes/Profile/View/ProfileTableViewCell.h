//
//  ProfileTableViewCell.h
//  FiiiPay
//
//  Created by Singer on 2018/3/27.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileTableViewCell : UITableViewCell

@property(weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property(weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(weak, nonatomic) IBOutlet UILabel *rightLabel;

@end
