//
//  requestViewController.h
//  Hpay
//
//  Created by ONUR YILMAZ on 21/03/2022.
//  Copyright © 2022 Himalaya. All rights reserved.
//


#import "FPViewController.h"

@class FBCoin;

@interface RequestViewController : FPViewController
@property(nonatomic, assign) BOOL isFromHome;
@property(nonatomic, strong) FBCoin *coinModel;
@end
