//
//  HCSSOHelper.h
//  Hpay
//
//  Created by Olgu Sirman on 06/07/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "HimalayaPayAPIManager.h"
#import "UserConfigResponse.h"
#import "ProductCategoryResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface HCSSOHelper : HimalayaPayAPIManager

+ (void)getUserConfigWithCompletionBlock:(void (^)(UserConfigResponse* _Nullable response, NSInteger errorCode, NSString * _Nullable errorMessage))completionBlock;

+ (void)getUserInfoWithCompletionBlock:(void (^)(id _Nullable response, NSInteger errorCode, NSString * _Nullable errorMessage))completionBlock;

+ (void)getProductCategoryWithCompletionBlock:(void (^)(ProductCategoryResponse* _Nullable response, NSInteger errorCode, NSString * _Nullable errorMessage))completionBlock;

@end

NS_ASSUME_NONNULL_END
