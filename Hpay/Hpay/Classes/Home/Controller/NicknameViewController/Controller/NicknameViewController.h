//
//  NicknameViewController.h
//  FiiiPay
//
//  Created by Mac on 2018/6/8.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "FPViewController.h"

@class FBCoin;

@interface NicknameViewController : FPViewController
@property(nonatomic, assign) BOOL isFromHome;
@property(nonatomic, strong) FBCoin *coinModel;
@end
