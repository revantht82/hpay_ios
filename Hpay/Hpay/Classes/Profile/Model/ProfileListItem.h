//
//  ProfileListItem.h
//  Hpay
//
//  Created by Ugur Bozkurt on 24/11/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProfileTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ProfileListItemClickHandler)(NSIndexPath *indexPath);

@interface ProfileListItem : NSObject

@property(nonatomic, strong) NSString *title;

@property(nonatomic, strong) UIImage *leftIcon;

@property(nonatomic, strong) NSString * _Nullable rightText;

@property(nonatomic, strong) ProfileListItemClickHandler clickHandler;

+ (instancetype)itemWithTitle:(NSString *)title leftIcon:(UIImage *)leftIcon rightText:(NSString * _Nullable)rightText clickHandler:(ProfileListItemClickHandler)clickHandler;

+ (instancetype)itemWithTitle:(NSString *)title leftIcon:(UIImage *)leftIcon clickHandler:(ProfileListItemClickHandler)clickHandler;

- (instancetype)initWithTitle:(NSString *)title leftIcon:(UIImage *)leftIcon rightText:(NSString * _Nullable)rightText clickHandler:(ProfileListItemClickHandler)clickHandler;

- (ProfileTableViewCell *)configureCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
