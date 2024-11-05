//
//  GroupSendResultViewController.h
//  FiiiPay
//
//  Created by Mac on 2018/3/29.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "FPViewController.h"
#import "FPOrderDetailModel.h"
#import "PaySuccessPageType.h"

@interface GroupSendResultViewController : FPViewController
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UIImageView *resultIcon;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UITableView *receiversTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeightConst;
@property(nonatomic, copy) NSDictionary *transferDict;
@end
