//
//  HimalayaAuthManager.h
//  Bit58
//
//  Created by Olgu Sirman on 23/02/2021.
//  Copyright © 2021 YG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class OIDAuthState;
@class OIDServiceConfiguration;
@class HCIdentityUser;
@class RACSignal;
@class OIDEndSessionResponse;

typedef void (^EndSessionCallBack)(OIDEndSessionResponse * _Nullable endSessionResponse,
                                   NSError *_Nullable endSessionError);

@protocol HimalayaAuthManagerStateDelegate <NSObject>
- (void)didLoginSucceed;
- (void)didLoginFailedWithErrorCode:(NSInteger) errorCode;
@end

NS_ASSUME_NONNULL_BEGIN

@interface HimalayaAuthManager : NSObject

#pragma mark Properties
@property (nonatomic, readonly, nullable) OIDAuthState *authState;
@property (weak, nonatomic, nullable) id <HimalayaAuthManagerStateDelegate> stateDelegate;
@property (strong, nonatomic, nullable) HCIdentityUser *user;

#pragma mark Singleton
+ (instancetype)sharedManager;
- (void)loadState;

#pragma mark Auth
- (void)authorizeWithPresenter:(UIViewController *)presenter;
- (void)endSessionWithPresenter:(UIViewController *)presenter handler:(EndSessionCallBack)endSessionHandler;

#pragma mark Helpers
- (void)clearAuthState;
- (BOOL)isAuthorized;
- (void)refreshAccessTokenIfNeededWithSuccessHandler:(void(^)(NSString* _Nullable data))successBlock
                                        errorHandler:(void(^)( NSError* _Nullable error))errorBlock;

@end

NS_ASSUME_NONNULL_END
