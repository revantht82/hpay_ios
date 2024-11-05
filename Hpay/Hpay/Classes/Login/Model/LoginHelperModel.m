//
//  LoginHelperModel.m
//  FiiiPay
//
//  Created by Singer on 2018/4/8.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "LoginHelperModel.h"
#import "UIDevice+UUID.h"
#import "FPCountryList.h"

@implementation LoginHelperModel

+ (void)fetchCountryListCompleteBlock:(void (^)(FPCountryList *countryList, NSInteger errorCode, NSString *errorMessage))completBlock; {
    [self      GET:CountryGetListURL parameters:nil successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        FPCountryList *countryList = [FPCountryList objectFromJSONDictionary:(NSDictionary *)data];
        completBlock(countryList, kFPNetRequestSuccessCode, nil);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        completBlock(nil, code, message);
    }];
}

+ (void)logoutCompleteBlock:(void (^)(BOOL isSuccess, NSString *message))CompletBlock {
    [self     POST:AccountLogoutURL parameters:nil successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {

        CompletBlock(YES, nil);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        CompletBlock(NO, message);
    }];
}


@end
