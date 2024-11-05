//
//  FPHomeHeaderView.h
//  HomeDemo
//
//  Created by Singer on 2019/7/2.
//  Copyright © 2019 Himalaya. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HomeHeadViewClickType) {
    HomeHeadViewClickTypeScan = 0,     //扫描
    HomeHeadViewClickTypeDeposit,      //充值
    HomeHeadViewClickTypeWithdrawal,   //提现
    HomeHeadViewClickTypeHideCoin,     //隐藏资产为0的币种
    HomeHeadViewClickTypeVisibleMoney, //是否显示币种总额度
    HomeHeadViewClickTypeTransfer,     //转账
    HomeHeadViewClickTypeFiiiEX,        //划转
    HomeHeadViewClickTypePayBill,       //生活缴费
    HomeHeadViewClickTypeRedPacket,     //红包
    HomeHeadViewClickTypeExChange,     //不同钱包账户进行划转
    HomeHeadViewClickTypeRequest,
    HomeHeadViewClickTypeRequestIndividual,
    HomeHeadViewClickTypeBell,
};

NS_ASSUME_NONNULL_BEGIN

@protocol FPHomeHeaderViewClickDelegate <NSObject>

@optional
- (void)homeHeadViewClickWithType:(HomeHeadViewClickType)type;

@end

@interface FPHomeHeaderView : UIView
@property(weak, nonatomic) IBOutlet UIView *topBgView;

- (void)showAlert:(NSNumber *)show;
- (void)hideBellBtn:(BOOL)show;

@property(weak, nonatomic) id <FPHomeHeaderViewClickDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
