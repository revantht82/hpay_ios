//
//  SafeAuthCodeTextField.h
//  FiiiPay
//
//  Created by apple on 2018/5/15.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SafeAuthCodeTextField;

@protocol SafeAuthCodeTextFieldBarDelegate <NSObject>
- (void)barFinishEvent:(SafeAuthCodeTextField *)sender;
@end

@interface SafeAuthCodeTextField : UITextField
@property(weak, nonatomic) id <SafeAuthCodeTextFieldBarDelegate> barDelegate;
@end
