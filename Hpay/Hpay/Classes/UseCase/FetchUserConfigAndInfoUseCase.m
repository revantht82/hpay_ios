//
//  FetchUserConfigAndInfoUseCase.m
//  Hpay
//
//  Created by Ugur Bozkurt on 25/08/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "FetchUserConfigAndInfoUseCase.h"
#import "HCSSOHelper.h"
#import "HimalayaAuthKeychainManager.h"

@interface FetchUserConfigAndInfoUseCase()
@property(nonatomic) dispatch_group_t group;
@end

@implementation FetchUserConfigAndInfoUseCase

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
    
    [HCSSOHelper getUserConfigWithCompletionBlock:^(UserConfigResponse * response, NSInteger errorCode, NSString * _Nonnull errorMessage) {
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
    
    dispatch_group_enter(self.group);
    [HCSSOHelper getUserInfoWithCompletionBlock:^(id  _Nullable response, NSInteger errorCode, NSString * _Nonnull errorMessage) {
        if (errorCode != kFPNetRequestSuccessCode){
            if (errorHandledOnce){
                return;
            }
            errorHandledOnce = YES;
            completionHandler(NULL, errorCode, errorMessage);
        }else{
            NSDictionary *userObjectDict = (NSDictionary *)response;
            HCIdentityUser *user = [HCIdentityUser fromJSONDictionary:userObjectDict];
            [HimalayaAuthKeychainManager saveUserDataToKeychain:user];
            dispatch_group_leave(self.group);
        }
    }];
    
    dispatch_group_notify(self.group, dispatch_get_main_queue(), ^{
        completionHandler(NULL, kFPNetRequestSuccessCode, NULL);
    });
}

@end
