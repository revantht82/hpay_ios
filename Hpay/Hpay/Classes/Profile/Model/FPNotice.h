//
//  FPNotice.h
//  FiiiPay
//
//  Created by Singer on 2018/4/23.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPNoticeType.h"

@interface FPNotice : NSObject
@property(nonatomic, copy) NSString *NoticeId;
@property(nonatomic, copy) NSString *Timestamp;
@property(nonatomic, assign) FPNoticeType MsgType;
@property(nonatomic, copy) NSString *QueryId;
@property(nonatomic, copy) NSString *Title;
@property(nonatomic, copy) NSString *SubTitle;

/**
 0=未读 1=已读
 */
@property(nonatomic, assign) NSInteger Status;
@end
