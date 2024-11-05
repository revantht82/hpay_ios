//
//  NSString+Extension.h
//  Hpay
//
//  Created by Ugur Bozkurt on 20/08/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Extension)

- (NSString *)singleLine;

- (NSAttributedString *)newLineAttributed;

- (NSAttributedString *)attributed;

@end

NS_ASSUME_NONNULL_END
