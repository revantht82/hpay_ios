//
//  NotificationCenterModelHelper.m
//  FiiiPay
//
//  Created by apple on 2018/4/16.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "NotificationCenterModelHelper.h"
#import "FPNotificationCenterOM.h"
#import "FPUtils.h"

@implementation NotificationCenterModelHelper

#define KMaxType NotificationCenterListTypeGPaySellCrpytoCode

#pragma mark - 获取NotificationCenter list

+ (void)UpdateAnnouncementReadFlag:(NSString*)Id completeBlock:(void (^)(NSInteger errorCode, NSString *errorMessage))completBlock {
    NSString *urlStr = NotificationCenterListSingleURL;
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    mDict[@"Id"] = Id;
    mDict[@"IsRead"] = @YES;
    
    [self POST:urlStr parameters:mDict successBlock:^(NSObject *_Nullable data, NSObject *_Nullable extension, NSString *_Nullable message) {
        completBlock(kFPNetRequestSuccessCode, message);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        completBlock(code, message);
    }];
    
    return;
}

+ (void)fetchNotificationCenterListWithPageSize:(NSInteger)PageSize
                          andPageIndex:(NSInteger)PageIndex
                         completeBlock:(void (^)(NSArray *NotificationCenterList, NSInteger errorCode, NSString *errorMessage, NSInteger curPage))completBlock {
    NSString *urlStr = NotificationCenterListSingleURL;
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    mDict[@"PageSize"] = @(PageSize);
    mDict[@"PageIndex"] = @(PageIndex);
    
    [self GET:urlStr parameters:mDict successBlock:^(NSObject *_Nullable data, NSObject *_Nullable extension, NSString *_Nullable message) {
        NSDictionary *dict = (NSDictionary *) data;
        NSInteger page = [dict[@"CurrentPageIndex"] integerValue];
        NSArray *list = [FPNotificationCenterOM mModelArrayWithData:dict[@"Announcements"]];
        completBlock(list, kFPNetRequestSuccessCode, message, page);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        completBlock(nil, code, message, 0);
    }];
    
    return;
}



@end
