//
//  HCToolBar.h
//  Hpay
//
//  Created by Olgu Sirman on 06/07/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCToolBar : UIToolbar

@property(copy, nonatomic, nullable) void (^didToolBarDoneSelected)(void);

@end

NS_ASSUME_NONNULL_END
