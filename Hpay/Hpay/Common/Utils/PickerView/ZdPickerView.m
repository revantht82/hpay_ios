//
//  ZdPickerView.m
//  FiiiPay
//
//  Created by apple on 2020/6/8.
//  Copyright © 2020 Himalaya. All rights reserved.
//

#import "ZdPickerView.h"

@interface ZdPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottom;
@property(weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property(nonatomic, assign) NSInteger index;//默认选中

@property(nonatomic, copy) NSString *CryptoId;
@property(nonatomic, copy) NSString *CryptoCode;

@property(nonatomic, copy) NSString *FiatId;
@property(nonatomic, copy) NSString *FiatCode;
@property(nonatomic, copy) NSString *FiatSymbol;
@end

@implementation ZdPickerView

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.viewBottom.constant = -300;
    self.index = 0;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    [self.pickerView reloadAllComponents];
    self.CryptoId = self.dataArr[0][@"CryptoId"];
    self.CryptoCode = self.dataArr[0][@"CryptoCode"];
    self.FiatId = self.dataArr[0][@"FiatCurrencyList"][0][@"FiatId"];
    self.FiatCode = self.dataArr[0][@"FiatCurrencyList"][0][@"FiatCode"];
}

- (void)setListArr:(NSArray *)listArr {
    _listArr = listArr;
    [self.pickerView reloadAllComponents];
}

#pragma mark - action

- (IBAction)groundClick:(id)sender {
    [self hide];
}

- (IBAction)cancelClick:(id)sender {
    [self hide];
}

- (IBAction)sureClick:(id)sender {
    if (self.listArr) {
        self.sureChooseListCoinClick(self.listArr[self.index]);
    } else {
        self.sureClick(self.CryptoCode, self.CryptoId, self.FiatCode, self.FiatId, self.FiatSymbol);
    }
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

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.listArr ? 1 : 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.listArr) {
        return self.listArr.count;
    } else {
        if (component == 0) {
            return self.dataArr.count;
        } else {
            NSArray *arr = self.dataArr[self.index][@"FiatCurrencyList"];
            return arr.count;
        }
    }

}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.listArr) {
        NSDictionary *dic = self.listArr[row];
        return dic[@"CryptoCode"];
    } else {
        if (component == 0) {
            return self.dataArr[self.index][@"CryptoCode"];
        } else {
            NSArray *arr = self.dataArr[self.index][@"FiatCurrencyList"];
            return arr[row][@"FiatCode"];
        }
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.listArr) {
        self.index = row;
    } else {
        if (component == 0) {
            self.index = row;
            [self.pickerView reloadComponent:1];
            [self.pickerView selectRow:0 inComponent:1 animated:YES];
            self.CryptoId = self.dataArr[self.index][@"CryptoId"];
            self.CryptoCode = self.dataArr[self.index][@"CryptoCode"];
            self.FiatId = self.dataArr[self.index][@"FiatCurrencyList"][0][@"FiatId"];
            self.FiatCode = self.dataArr[self.index][@"FiatCurrencyList"][0][@"FiatCode"];
        } else {
            self.CryptoId = self.dataArr[self.index][@"CryptoId"];
            self.CryptoCode = self.dataArr[self.index][@"CryptoCode"];
            self.FiatId = self.dataArr[self.index][@"FiatCurrencyList"][row][@"FiatId"];
            self.FiatCode = self.dataArr[self.index][@"FiatCurrencyList"][row][@"FiatCode"];
            self.FiatSymbol = self.dataArr[self.index][@"FiatCurrencyList"][row][@"FiatSymbol"];
        }
    }
}


@end
