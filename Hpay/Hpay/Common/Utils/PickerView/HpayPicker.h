//
//  HpayPicker.h
//  Hpay
//
//  Created by ONUR YILMAZ on 30/03/2022.
//  Copyright © 2022 Himalaya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HpayPicker : UIView

@property(nonatomic, assign) NSInteger selectedIndex;
@property(nonatomic, strong) NSMutableArray *dataArr;


@property(weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property(nonatomic, copy) void (^sureProductCategoryClick)(NSInteger selectedIndex, NSString* selectedText);

- (void)show;
-(void)addItemToPicker:(NSString*)line;

@end

NS_ASSUME_NONNULL_END
