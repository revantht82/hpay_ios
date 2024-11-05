//
//  TransferInfoViewController.h
//  FiiiPay
//
//  Created by Mac on 2018/6/8.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "FPViewController.h"
#import "PreTransferModel.h"

@interface TransferInfoViewController : FPViewController
@property(nonatomic, copy) NSDictionary *infoDict;
@property(nonatomic, copy) NSArray *infoArray;
@property(nonatomic, strong) PreTransferModel *transferModel;
@end
