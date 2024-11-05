//
//  ZdPickerView.h
//  FiiiPay
//
//  Created by apple on 2020/6/8.
//  Copyright © 2020 Himalaya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZdPickerView : UIView


/// 购买选中回调
@property(nonatomic, copy) void (^sureClick)(NSString *CryptoCode, NSString *CryptoId, NSString *FiatCode, NSString *FiatId, NSString *FiatSymbol);
//购买-选币
@property(nonatomic, strong) NSArray *dataArr;


/// 划转选币回调
@property(nonatomic, copy) void (^sureChooseListCoinClick)(id listCoin);
//划转-选币
@property(nonatomic, strong) NSArray *listArr;


/// 展示picker
- (void)show;

@end

NS_ASSUME_NONNULL_END
