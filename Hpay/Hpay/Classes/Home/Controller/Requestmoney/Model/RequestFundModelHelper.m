//
//  RequestFundModelHelper.m
//  Hpay
//
//  Created by Younes Soltan on 12/05/2022.
//  Copyright © 2022 Himalaya. All rights reserved.
//

#import "RequestFundModelHelper.h"

@implementation RequestFundModelHelper

+(void)createFundRequestWithCryptoId:(NSString *)CryptoId productCategoryId:(nullable NSString *)categoryId andAmount:(NSString *)amount withNotes:(NSString *)notes completeBlock:(void (^)(NSDictionary *responseModel, NSInteger errorCode, NSString *errorMessage))completBlock {
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    mDict[@"CryptoId"] = CryptoId;
    mDict[@"Amount"] = amount;
    mDict[@"notes"] = notes;
    mDict[@"Category"] = categoryId;

    [self POST:CreateRequestFund parameters:mDict successBlock:^(NSObject *_Nullable data, NSObject *_Nullable extension, NSString *_Nullable message) {
        NSDictionary *dict = (NSDictionary *) data;
        
        completBlock(dict, kFPNetRequestSuccessCode, nil);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        completBlock(nil, code, message);
    }];
}

@end
    
