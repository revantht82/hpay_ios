//
//  FetchPhoneCodeViewController.h
//  FiiiPay
//
//  Created by Mac on 2018/6/8.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "FPViewController.h"
#import "FPCountryList.h"

typedef NS_ENUM(NSInteger, FPBackColorStyle) {
    FPDefaultBackColorStyle = 0, //白色背景
    FPBlackBackColorStyle        //黑色背景
};

@interface FetchPhoneCodeViewController : FPViewController

@property(assign, nonatomic) FPBackColorStyle style;
@property(copy, nonatomic) NSString *selectPhoneCode;
@property(copy, nonatomic) FPCountryList *countryList;
@property(copy, nonatomic) void (^clickBlock)(FPCountry *country);

@end
