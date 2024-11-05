//
//  CBPayView.h
//  FiiiPay
//
//  Created by Mac on 2018/3/31.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPOrderDetailModel.h"


typedef NS_ENUM(NSInteger, CBPayViewType) {
    CBPayViewTypePay = 0, //付款默认
    CBPayViewTypeWithdrawal = 1, //提币
    CBPayViewTypeWithtransfer = 2, //转账
    CBPayViewTypeWithGPayExChange = 3, //GPay闪兑
    CBPayViewTypeWithGPayHuaZhuan = 4 //划转
};
typedef NS_ENUM(NSInteger, CBPayViewClickType) {
    CBPayViewClickTopupType = 0, //充值
    CBPayViewClickCloseType,     //关闭
    CBPayViewClickSuccessType,   //支付成功回调
    CBPayViewClickCancelType,    //余额不足，点击了取消
    CBPayViewClickLinkType,      //禁用，联系客服
//    CBInitiativetoPayType,       //主动付款，点击了完成回调
//    CBInitiativeLackofbalanceType, //主动付款，余额不足回调
};

typedef void(^FinishBlock)(NSDictionary *resultDict);

typedef void(^LinkCustomerBlock)(void);

@interface CBPayView : UIView
@property(nonatomic, assign) BOOL isNeedRemoveView;
@property(nonatomic, copy) NSString *queryId;
// 支付成功，model才有值
@property(nonatomic, copy) void (^clickBlock)(CBPayViewClickType clickType, FPOrderDetailModel *model);
//是否主动付款,默认NO

+ (instancetype)getPayView;

- (void)showWithType:(CBPayViewType)pType andInfoDict:(NSDictionary *)infoDict withFinishEvent:(FinishBlock)finishBlock andLinkBlock:(LinkCustomerBlock)linkBlock;

- (void)show;

- (void)hide;

// 界面切换成余额不足
- (void)showInsufficientView;

// POS扫描FiiiPay二维码，根据订单号查询信息
- (void)loadDataWithOrderId:(NSString *)OrderId;

// FiiiPay扫描POS二维码，获取订单信息显示数据
- (void)writeData:(FPOrderDetailModel *)detailModel;
@end
