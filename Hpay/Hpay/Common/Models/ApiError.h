//
//  ApiError.h
//  Hpay
//
//  Created by Ugur Bozkurt on 29/07/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ApiError : NSObject

@property(nonatomic) NSString *prettyTitle;
@property(nonatomic) NSString *prettyMessage;

@property(nonatomic) NSString *prettyMerchantCreateErrorTitle;
@property(nonatomic) NSString *prettyMerchantCreateErrorMessage;

@property(nonatomic) NSString *prettyMerchantCancelErrorTitle;
@property(nonatomic) NSString *prettyMerchantCancelErrorMessage;

- (instancetype)initWithCode:(NSInteger)code message: (NSString * _Nullable)message;
+ (instancetype)errorWithCode:(NSInteger)code message: (NSString * _Nullable)message;

@end

NS_ASSUME_NONNULL_END
