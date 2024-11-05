//
//  ProfileViewController.h
//  FiiiPay
//
//  Created by Singer on 2018/3/27.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "FPViewController.h"

typedef enum ProfileItemType : NSUInteger {
    kProfileItemStatements,
    kProfileItemAccount,
    kProfileItemTheme,
    kProfileItemHelpAndFeedBack
} ProfileItemType;

@interface ProfileViewController : FPViewController

@end
