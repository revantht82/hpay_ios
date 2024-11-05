//
//  HomeAccountListBaseView.h
//  FiiiPay
//
//  Created by Singer on 2019/7/3.
//  Copyright © 2019 Himalaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPagerView.h"
#import "HomeTableViewCell.h"

#define kHomeAccountListViewSearchSectionHeaderHeight 50
NS_ASSUME_NONNULL_BEGIN

@interface HomeAccountListBaseView : UIView <JXPagerViewListViewDelegate>

@property(weak, nonatomic) UINavigationController *naviController;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataSource;
@property(nonatomic, assign) BOOL isNeedFooter;
@property(nonatomic, assign) BOOL isNeedHeader;
@property(nonatomic, assign) BOOL isHeaderRefreshed;   //默认为YES
@property(nonatomic, assign) BOOL visibleAmount;//是否显示币种数量以及法币金额
@property(nonatomic, copy) NSString *fiatCurrency;
@property(nonatomic, assign) BOOL hideZero;
@property(nonatomic, copy) NSString *searchText;

@property(nonatomic, copy) void (^homeAccountListViewClickSearchTextFieldMaskBtn)(void);
@property(nonatomic, copy) void (^homeAccountListViewClickHideZeroBtn)(BOOL hideZero);

- (void)beginFirstRefresh;

@end

NS_ASSUME_NONNULL_END
