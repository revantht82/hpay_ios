//
//  FetchPhoneCodeAdapter.h
//  Hpay
//
//  Created by Olgu Sirman on 10/12/2020.
//  Copyright © 2020 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FetchPhoneCodeViewController.h"

@class FPCountry;

@protocol FetchPhoneCodeAdapterDelegate <NSObject>

@optional
- (void)tableViewDidSelectRow:(FPCountry *_Nonnull)country;

@end

NS_ASSUME_NONNULL_BEGIN

@interface FetchPhoneCodeAdapter : NSObject

@property(nonatomic, weak, nullable) id <FetchPhoneCodeAdapterDelegate> delegate;

- (instancetype)initWithTableView:(__kindof UITableView *)tableView;

- (void)setData:(NSArray<NSDictionary<NSString *, NSArray<FPCountry *> *> *> *)dataArray indexArray:(NSArray<NSString *> *)indexArray;

- (void)configureWithSelectPhoneCode:(NSString *)selectPhoneCode style:(FPBackColorStyle)style;

@end

NS_ASSUME_NONNULL_END
