//
//  AlertActionItem.h
//  Hpay
//
//  Created by Ugur Bozkurt on 05/08/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    AlertActionStyleDefault = 0,
    AlertActionStyleCancel,
    AlertActionStyleDestructive
} AlertActionStyle;

typedef void(^AlertActionItemHandler)(void);

@interface AlertActionItem : NSObject
@property(nonatomic, assign) NSString * title;
@property(nonatomic, assign) AlertActionStyle style;
@property(nonatomic, readonly) AlertActionItemHandler _Nullable handler;

+ (instancetype)actionWithTitle:(NSString *)title style:(AlertActionStyle)style handler:(nullable AlertActionItemHandler)handler;
+ (instancetype)defaultDismissItem;
+ (instancetype)defaultDismissItemWithHandler:(AlertActionItemHandler)handler;
+ (instancetype)defaultCancelItem;
+ (instancetype)defaultCancelItemWithHandler:(AlertActionItemHandler)handler;
+ (instancetype)defaultOKItem;
+ (instancetype)defaultGotItItemWithHandler:(AlertActionItemHandler)handler;
+ (instancetype)defaultRetryItemWithHandler:(AlertActionItemHandler)handler;
+ (instancetype)defaultContinueItemWithHandler:(AlertActionItemHandler)handler;
@end

NS_ASSUME_NONNULL_END
