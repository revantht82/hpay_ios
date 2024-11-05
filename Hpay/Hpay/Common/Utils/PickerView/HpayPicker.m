//
//  HpayPicker.m
//  Hpay
//
//  Created by ONUR YILMAZ on 30/03/2022.
//  Copyright © 2022 Himalaya. All rights reserved.
//

#import "HpayPicker.h"

@interface HpayPicker () <UIPickerViewDelegate, UIPickerViewDataSource>

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottom;


@property(nonatomic, assign) NSInteger index;


@end



@implementation HpayPicker



- (void)awakeFromNib {
    [super awakeFromNib];
//    self.viewBottom.constant = -300;
    self.index = 0;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
}

#pragma mark - action

-(void)addDataArr:(NSMutableArray*)dataArr{
    _dataArr = dataArr;
    [self.pickerView reloadAllComponents];
}


- (IBAction)groundClick:(id)sender {
    [self hide];
}

- (IBAction)cancelClick:(id)sender {
    [self hide];
}

- (IBAction)sureClick:(id)sender {
    
    self.sureProductCategoryClick(self.selectedIndex, self.dataArr[_selectedIndex]);
    self.selectedIndex = self.index;
    [self hide];
}

- (void)show {
    [UIView animateWithDuration:0.2 animations:^{
        self.viewBottom.constant = 0;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [self layoutIfNeeded];
    }                completion:^(BOOL finished) {
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.15 animations:^{
        self.viewBottom.constant = -300;
        [self layoutIfNeeded];
    }                completion:^(BOOL finished) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        [self removeFromSuperview];
    }];
}

#pragma mark - delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataArr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.dataArr[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedIndex = row;
}

@end
