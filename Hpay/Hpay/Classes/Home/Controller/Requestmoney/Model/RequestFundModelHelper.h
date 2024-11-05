//
//  RequestFundModelHelper.h
//  Hpay
//
//  Created by Younes Soltan on 12/05/2022.
//  Copyright © 2022 Himalaya. All rights reserved.
//

#import "HimalayaPayAPIManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface RequestFundModelHelper : HimalayaPayAPIManager

+ (void)createFundRequestWithCryptoId: (NSString *)CryptoId productCategoryId:(nullable NSString *)categoryId andAmount:(NSString*)amount withNotes:(NSString*)notes completeBlock:(void (^)(NSDictionary *responseModel, NSInteger errorCode, NSString *errorMessagel))completBlock;

@end

NS_ASSUME_NONNULL_END
