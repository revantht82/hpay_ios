//
//  StateViewModel.h
//  Hpay
//
//  Created by Ugur Bozkurt on 22/07/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StateViewModel : NSObject
@property (nonatomic, copy, readonly) UIImage* errorImage;
@property (nonatomic, copy, readonly) NSAttributedString* errorTitle;
@property (nonatomic, copy, readonly) NSString* errorMessage;

- (instancetype)initWithErrorImage:(UIImage *)errorImage
                        errorTitle: (NSAttributedString*)errorTitle
                      errorMessage: (NSString*)errorMessage;

+(StateViewModel*)networkErrorModel;
+(StateViewModel*)orderNotFoundErrorModel;
+(StateViewModel*)genericApiErrorModel;
+(StateViewModel*)invalidKYCErrorModel;
+(StateViewModel*)kycErrorModel;
+(StateViewModel*)userAccountSuspended;
+(StateViewModel*)pinAttemptExceeded;
+(NSString*)refreshButtonTitle;
+ (NSString *)retryButtonTitle;
+ (NSString *)okayButtonTitle;
+(NSString*)dismissButtonTitle;
@end

NS_ASSUME_NONNULL_END
