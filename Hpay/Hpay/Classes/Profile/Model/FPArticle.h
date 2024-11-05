//
//  FPArticle.h
//  FiiiPay
//
//  Created by Singer on 2018/4/23.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    FPArticleTypeArticle,//普通新闻文章
    FPArticleTypeLvVerify,//LV1和LV2审核状态
} FPArticleType;

@interface FPArticle : NSObject
@property(nonatomic, assign) NSInteger Id;
@property(nonatomic, copy) NSString *Title;

/**
 简介
 */
@property(nonatomic, copy) NSString *Intro;
@property(nonatomic, copy) NSString *Timestamp;
@property(nonatomic, assign) BOOL Status;
@property(nonatomic, assign) FPArticleType Type;
@end
