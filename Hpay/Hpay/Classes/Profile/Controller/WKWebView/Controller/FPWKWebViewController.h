//
//  FPWKWebViewController.h
//  FiiiPay
//
//  Created by Singer on 2018/4/24.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "FPViewController.h"

@interface FPWKWebViewController : FPViewController
@property(nonatomic, copy) NSString *urlStr;
@property(nonatomic, copy) NSDictionary *param;
@property(nonatomic, assign) BOOL isWebPage;
@end
