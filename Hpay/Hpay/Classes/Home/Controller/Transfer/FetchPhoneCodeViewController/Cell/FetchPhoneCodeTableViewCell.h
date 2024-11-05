//
//  FetchPhoneCodeTableViewCell.h
//  Hpay
//
//  Created by Olgu Sirman on 10/12/2020.
//  Copyright © 2020 Himalaya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FPCountry;

NS_ASSUME_NONNULL_BEGIN

@interface FetchPhoneCodeTableViewCell : UITableViewCell

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
-(void)configureWith:(FPCountry *)country selectPhoneCode:(NSString *)selectPhoneCode;

@end

NS_ASSUME_NONNULL_END
