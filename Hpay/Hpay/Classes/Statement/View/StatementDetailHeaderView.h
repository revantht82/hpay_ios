//
//  StatementDetailHeaderView.h
//  FiiiPay
//
//  Created by apple on 2018/3/27.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatementDetailHeaderView : UIView
@property(weak, nonatomic) IBOutlet UIImageView *cardImageView;
@property(weak, nonatomic) IBOutlet UIImageView *typeIcon;
@property(weak, nonatomic) IBOutlet UILabel *typeName;
@property(weak, nonatomic) IBOutlet UILabel *amountLabel;
@property(weak, nonatomic) IBOutlet UIView *expirationView;
@property(weak, nonatomic) IBOutlet UILabel *expirationTimeLabel;
@property(strong, nonatomic) NSString *expirationTime;

-(void)updateExpirationLabel;

@end
