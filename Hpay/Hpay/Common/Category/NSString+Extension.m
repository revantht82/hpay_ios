//
//  NSString+Extension.m
//  Hpay
//
//  Created by Ugur Bozkurt on 20/08/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (NSString *)singleLine{
    return [self stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
}

- (NSAttributedString *)newLineAttributed{
    NSArray<NSString *> *splitted = [self componentsSeparatedByString:@"\n"];
    NSString *lastLineString = splitted.lastObject;
    NSRange range = [self rangeOfString:lastLineString];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSDictionary *attrs = @{ NSForegroundColorAttributeName : kMarigoldColor };
    [attributedString addAttributes:attrs range:range];
    return attributedString;
}

- (NSAttributedString *)attributed{
    return [[NSAttributedString alloc] initWithString:self];
}
@end
