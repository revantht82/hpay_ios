//
//  LoginHelperModel.h
//  FiiiPay
//
//  Created by Singer on 2018/4/8.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "GLCNetworkRequest.h"
#import "FPCountryList.h"
#import "HimalayaPayAPIManager.h"

@interface LoginHelperModel : HimalayaPayAPIManager

/**
 获取国家列表，已经根据客户端语言排序
 */
+ (void)fetchCountryListCompleteBlock:(void (^)(FPCountryList *countryList, NSInteger errorCode, NSString *errorMessage))completBlock;

/**
 退出登录接口，此接口将解除设备的推送服务绑定
 */
+ (void)logoutCompleteBlock:(void (^)(BOOL isSuccess, NSString *message))CompletBlock;


@end
