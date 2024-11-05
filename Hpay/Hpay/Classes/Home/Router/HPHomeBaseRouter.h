//
//  HPHomeBaseRouter.h
//  Hpay
//
//  Created by Olgu Sirman on 12/01/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "HPNavigationRouter.h"

struct PresentPaySuccessNavigationRequest {
    NSDictionary * _Nullable orderDictionary;
    NSDictionary * _Nullable selCoinDic;
    NSString * _Nonnull amount;
};

@protocol HPHomeBaseRouterInterface <HPNavigationRouterDelegate>

- (void)presentExchangePaySuccessWithRequest:(struct PresentPaySuccessNavigationRequest)request;
- (void)presentGPayExchangSuccessWithRequest:(struct PresentPaySuccessNavigationRequest)request;
- (void)presentTransferPaySuccessPageWith:(NSDictionary *_Nonnull)dictionary;
- (void)presentGroupTransferPaySuccessPageWith:(NSDictionary *_Nonnull)dictionary;

- (void)pushToHelpFeedback;
- (void)presentHelpFeedback;

-(void)returnToHomeFromCancellationOfDuplicate;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HPHomeBaseRouter : HPNavigationRouter <HPHomeBaseRouterInterface>

@end

NS_ASSUME_NONNULL_END
