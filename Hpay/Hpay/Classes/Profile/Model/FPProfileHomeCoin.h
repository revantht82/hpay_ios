//
//  FPProfileHomeCoin.h
//  FiiiPay
//
//  Created by Singer on 2018/4/16.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "FPProfileCoin.h"

@interface FPProfileHomeCoin : FPProfileCoin


/**
 是否显示在首页，客户端根据“不显示在首页”放在“更多币种”
 */
@property(nonatomic, assign) BOOL ShowInHomePage;

@end
