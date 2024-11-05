//
//  UseCase.h
//  Hpay
//
//  Created by Ugur Bozkurt on 25/08/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UseCase <NSObject>
- (void)executeWithRequest:(id _Nullable)request completionHandler:(void(^)(id _Nullable response, NSInteger errorCode, NSString * _Nullable errorMessage))completionHandler;
@end

NS_ASSUME_NONNULL_END
