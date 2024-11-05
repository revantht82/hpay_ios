//
//  UILabel+Extension.m
//  FiiiPay
//
//  Created by Singer on 2020/6/28.
//  Copyright © 2020 Himalaya. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

@dynamic localizeKey;

- (void)setLocalizeKey:(NSString *)localizeKey{
    if (localizeKey.length > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.text = NSLocalizedString(localizeKey, nil);
        });
    }
}
@end
