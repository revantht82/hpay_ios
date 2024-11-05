//
//  FPYearMonthPickView.h
//  FiiiPay
//
//  Created by Singer on 2019/11/16.
//  Copyright © 2019 Himalaya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NTMonthYearPicker;

NS_ASSUME_NONNULL_BEGIN

typedef void(^FPYearMonthPickViewDoneBlock)(NSString *year, NSString *month, NSString *day);

@interface FPYearMonthPickView : UIView

@property(nonatomic, copy) FPYearMonthPickViewDoneBlock doneBlock;
@property(nonatomic, strong) NSDate *currentDate;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NTMonthYearPicker *pickerView;

- (void)show;
- (void)hide;

@end

NS_ASSUME_NONNULL_END
