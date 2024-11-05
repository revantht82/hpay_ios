//
//  FetchProductCategoryUseCase.m
//  Hpay
//
//  Created by ONUR YILMAZ on 25/03/2022.
//  Copyright © 2022 Himalaya. All rights reserved.
//

#import "FetchProductCategoryUseCase.h"
#import "HCSSOHelper.h"
#import "HimalayaAuthKeychainManager.h"

@interface FetchProductCategoryUseCase()
@property(nonatomic) dispatch_group_t group;
@end

@implementation FetchProductCategoryUseCase

- (instancetype)init
{
    self = [super init];
    if (self) {
        _group = dispatch_group_create();
    }
    return self;
}

- (void)executeWithRequest:(id)request completionHandler:(void (^)(id _Nullable, NSInteger, NSString * _Nullable))completionHandler{
    dispatch_group_enter(self.group);
    
    __block BOOL errorHandledOnce = NO;
    
    [HCSSOHelper getProductCategoryWithCompletionBlock:^(ProductCategoryResponse * response, NSInteger errorCode, NSString * _Nonnull errorMessage) {
        if (errorCode != kFPNetRequestSuccessCode){
            if (errorHandledOnce){
                return;
            }
            errorHandledOnce = YES;
            completionHandler(NULL, errorCode, errorMessage);
        }else{
            [HimalayaAuthKeychainManager saveUserConfigToKeychain:response];
            dispatch_group_leave(self.group);
        }
    }];
    
    dispatch_group_notify(self.group, dispatch_get_main_queue(), ^{
        completionHandler(NULL, kFPNetRequestSuccessCode, NULL);
    });
}

@end
