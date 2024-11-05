//
//  NotificationCenterModelHelper.h
//  FiiiPay
//
//  Created by apple on 2018/4/16.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "GLCNetworkRequest.h"
#import "FPNotificationCenterDetailOM.h"
#import "HimalayaPayAPIManager.h"

@interface NotificationCenterModelHelper : HimalayaPayAPIManager

+ (void)UpdateAnnouncementReadFlag:(NSString*)Id completeBlock:(void (^)(NSInteger errorCode, NSString *errorMessage))completBlock;

+ (void)fetchNotificationCenterListWithPageSize:(NSInteger)PageSize
                      andPageIndex:(NSInteger)PageIndex
                         completeBlock:(void (^)(NSArray *NotificationCenterList, NSInteger errorCode, NSString *errorMessage, NSInteger curPage))completBlock;
@end
