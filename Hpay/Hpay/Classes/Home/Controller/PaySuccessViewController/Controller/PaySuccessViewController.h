//
//  PaySuccessViewController.h
//  FiiiPay
//
//  Created by Mac on 2018/3/29.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "FPViewController.h"
#import "FPOrderDetailModel.h"
#import "PaySuccessPageType.h"

@interface PaySuccessViewController : FPViewController
@property(nonatomic, strong) FPOrderDetailModel *orderDetailModel;
@property(nonatomic, copy) NSDictionary *withdrawDict;
@property(nonatomic, copy) NSDictionary *transferDict;
@property(nonatomic, copy) NSDictionary *dataDict;
@property(nonatomic, assign) PageSuccess pageType;

@end
