//
//  FPViewController.h
//  YunMedia
//
//  Created by apple on 2017/8/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UINavigationController+CFYNavigationBarTransition_Public.h>
#import <UIViewController+CFYNavigationBarTransition.h>
#import "FPNavigationController.h"
#import "HPNavigationRouter.h"
// FIXME: Get rid of that imports in .h file

@interface FPViewController : UIViewController

@property (class, nonatomic, copy, readonly, nonnull) NSString *className;

- (void)setUpRightBarButtonItem;
- (void)setUpRightBarButtonItemWithImageName:(nullable NSString *)imageName;
- (void)hideKeyboard;
- (BOOL)isAuthorized;
- (void)loginAction;
@end
