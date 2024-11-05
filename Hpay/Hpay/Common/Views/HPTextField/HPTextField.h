//
//  HPTextField.h
//  Hpay
//
//  Created by Olgu Sirman on 29/12/2020.
//  Copyright © 2020 Himalaya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPTextField : UITextField

@property(nonatomic, assign) BOOL disablePaste;
@property(nonatomic, assign) BOOL disableCopy;
@property(nonatomic, assign) BOOL disableMenuController;

- (instancetype)initWithDisablePaste:(BOOL)disablePaste;
- (void)configure;

@end

NS_ASSUME_NONNULL_END
