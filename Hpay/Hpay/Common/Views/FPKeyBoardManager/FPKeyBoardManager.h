//
//  FPKeyBoardManager.h
//  GiiiWalletMerchant
//
//  Created by Mac on 2017/10/31.
//  Copyright © 2017年 fiipay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    FPKeyBoardStyleDefault,
    FPKeyBoardStyleDotImage,
} FPKeyBoardStyle;

@interface FPKeyBoardManager : UIView

- (instancetype)initWithStyle:(FPKeyBoardStyle)style;

@property(nonatomic, copy) void (^keyBoardCallBack)(NSString *pwd, FPKeyBoardManager *keyBoard);
@property(nonatomic, copy) void (^keyBoardCloseCallBack)(void);

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *subTitle;

- (void)showKeyBoard;
- (void)hideKeyBoard;
+ (void)hideKeyBoard;
- (void)clear;

@end
