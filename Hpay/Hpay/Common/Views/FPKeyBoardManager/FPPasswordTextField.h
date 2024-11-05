//
//  FPPasswordTextField.h
//  AliyunUploadDemo
//
//  Created by Singer on 2018/3/22.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FPPasswordTextField;

@protocol FPPasswordTextFieldDelegate <NSObject>

@optional

- (void)fp_passwordTextField:(FPPasswordTextField *)pwdTextField didFilledPassword:(NSString *)password;

@end

@interface FPPasswordTextField : UITextField

@property(nonatomic, assign) id <FPPasswordTextFieldDelegate> fp_delegate;

- (void)fp_clear;
@end
