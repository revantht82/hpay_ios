//
//  RequestConfirmationView.h
//  Hpay
//
//  Created by ONUR YILMAZ on 31/03/2022.
//  Copyright © 2022 Himalaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPOrderDetailModel.h"

@protocol RequestConfirmationViewDelegate <NSObject>

-(void)confirmationViewDismissed;

@end

typedef void(^FinishBlock)(NSDictionary *resultDict);

typedef void(^LinkCustomerBlock)(void);

@interface RequestConfirmationView : UIView
@property(nonatomic, assign) BOOL isNeedRemoveView;
@property(nonatomic, copy) NSString *queryId;
@property(nonatomic, assign) id delegate;

// 支付成功，model才有值
//@property(nonatomic, copy) void (^clickBlock)(CBPayViewClickType clickType, FPOrderDetailModel *model);
//是否主动付款,默认NO

+ (instancetype)getPayView:(NSDecimalNumber *)amount amountString:(NSString *)amountStr productCategory:(NSString *)prodCat requestNotes:(NSString *)reqNotes selectedCategoryId:(NSString *)catId;

- (void)showWithType;

- (void)show;

- (void)hide;

// 界面切换成余额不足
//- (void)showInsufficientView;

// POS扫描FiiiPay二维码，根据订单号查询信息
//- (void)loadDataWithOrderId:(NSString *)OrderId;

// FiiiPay扫描POS二维码，获取订单信息显示数据
//- (void)writeData:(FPOrderDetailModel *)detailModel;
@end
