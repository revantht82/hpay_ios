//
//  FPValueDP.m
//  GiiiWalletMerchant
//
//  Created by apple on 2017/10/17.
//  Copyright © 2017年 fiipay. All rights reserved.
//

#import "FPValueDP.h"

@implementation FPValueDP

+ (NSString *)priceFormat:(NSString *)str {
    return [FPValueDP formatWithPriceBy:[FPValueDP reviseString:str]];
}


+ (NSString *)reviseString:(NSString *)str {
    //直接传入精度丢失有问题的Double类型
    double conversionValue = [str doubleValue];
    NSString *doubleString = [NSString stringWithFormat:@"%.2f", conversionValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

+ (double)productFromAStr:(NSString *)aStr withBStr:(NSString *)bStr {
    double conversionValueA = [aStr doubleValue];
    double conversionValueB = [bStr doubleValue];
    NSString *doubleString = [NSString stringWithFormat:@"%.2f", conversionValueA * conversionValueB];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber doubleValue];
}

+ (double)pFromAStr:(NSString *)aStr withBStr:(NSString *)bStr {
    double conversionValueA = [aStr doubleValue];
    double conversionValueB = [bStr doubleValue];
    NSString *doubleString = [NSString stringWithFormat:@"%f", conversionValueA * conversionValueB];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber doubleValue];
}

#pragma mark - 金钱格式化

+ (NSString *)formatWithPriceBy:(NSString *)priceStr {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = (NSNumberFormatterStyle) kCFNumberFormatterDecimalStyle;
    [numberFormatter setPositiveFormat:@"###,##0.00"];
    double t = [priceStr doubleValue];
    NSString *lp;
    if (t == 0) {
        lp = @"0.00";
    }
    else {
        lp = [numberFormatter stringFromNumber:@(t)];
    }
    return lp;
}

//获取中划线，用于旧价格划掉，参数textStr要加线的文字,原字符串textStr
+ (NSMutableAttributedString *)getCenterLineStr:(NSString *)lineStr WithString:(NSString *)textStr {
    NSRange range = [lineStr rangeOfString:textStr];
    return [FPValueDP getCenterLineByRange:range WithString:lineStr];
}

//获取下划线，用于超链接文字，参数textStr要加线的范围Range,原字符串textStr
+ (NSMutableAttributedString *)getUnderLineStr:(NSString *)lineStr WithString:(NSString *)textStr {
    NSRange range = [textStr rangeOfString:lineStr];
    return [FPValueDP getUnderLineByRange:range WithString:textStr];
}


//获取中划线，用于旧价格划掉，参数textStr要加线的范围Range,原字符串textStr
+ (NSMutableAttributedString *)getCenterLineByRange:(NSRange)range WithString:(NSString *)textStr {
    NSMutableAttributedString *attributeMarket = [[NSMutableAttributedString alloc] initWithString:textStr];
    [attributeMarket setAttributes:@{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle)} range:range];
    return attributeMarket;
}

//获取下划线，用于超链接文字，参数textStr要加线的范围Range,原字符串textStr
+ (NSMutableAttributedString *)getUnderLineByRange:(NSRange)range WithString:(NSString *)textStr {
    NSMutableAttributedString *attributeMarket = [[NSMutableAttributedString alloc] initWithString:textStr];
    [attributeMarket setAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:range];
    [attributeMarket addAttribute:NSFontAttributeName
                            value:UIFontMake(12)
                            range:range];
    [attributeMarket addAttribute:NSForegroundColorAttributeName
                            value:kDarkNightColor
                            range:range];

    return attributeMarket;
}

+ (NSString *)A:(NSString *)a jiaB:(NSString *)b {
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:a];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:b];
    NSDecimalNumber *resultNum = [num1 decimalNumberByAdding:num2];
    return resultNum.stringValue;
}

+ (NSString *)A:(NSString *)a jiaB:(NSString *)b withPlace:(NSInteger)place {
    NSString *tempA = a;
    NSString *tempB = b;
    if ([a hasPrefix:@"."]) {
        tempA = [NSString stringWithFormat:@"0%@", a];
    }
    if ([b hasPrefix:@"."]) {
        tempB = [NSString stringWithFormat:@"0%@", b];
    }
    NSString *aa = tempA ? (tempA.length > 0 ? tempA : @"0") : @"0";
    NSString *bb = tempB ? (tempB.length > 0 ? tempB : @"0") : @"0";
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:aa];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:bb];
    NSDecimalNumber *resultNum = [num1 decimalNumberByAdding:num2];
    NSNumberFormatter *nFormat = [[NSNumberFormatter alloc] init];
    [nFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    [nFormat setDecimalSeparator:@"."];
    [nFormat setMaximumFractionDigits:place];
    [nFormat setMinimumFractionDigits:place];
    if ([resultNum doubleValue] < 1) {
        if ([resultNum doubleValue] > 0) {
            return [NSString stringWithFormat:@"%@", [nFormat stringFromNumber:resultNum]];
        } else if ([resultNum doubleValue] == 0) {
            NSString *str = [NSString stringWithFormat:@"%@", [nFormat stringFromNumber:resultNum]];
            if (![str hasPrefix:@"0."]) {
                str = [NSString stringWithFormat:@"%@", [nFormat stringFromNumber:resultNum]];
            }
            return str;
        } else {
            NSString *str = [NSString stringWithFormat:@"%@", [nFormat stringFromNumber:resultNum]];
            if ([str rangeOfString:@"-."].location != NSNotFound) {
                str = [str stringByReplacingOccurrencesOfString:@"-." withString:@"-0."];
            }
            return str;
        }
    }
    return [nFormat stringFromNumber:resultNum];
}

+ (NSString *)A:(NSString *)a jiaB:(NSString *)b withPlace:(NSInteger)place isKillEndingZero:(BOOL)kill {
    NSString *str = [self A:a jiaB:b withPlace:place];
    return kill ? [self commonKill:str] : str;
}

+ (NSString *)decimalSeparatorStr:(NSString *)string {
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:string];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:@"0"];
    NSDecimalNumber *resultNum = [num1 decimalNumberBySubtracting:num2];
    NSNumberFormatter *nFormat = [[NSNumberFormatter alloc] init];
    [nFormat setDecimalSeparator:@"."];
    return [nFormat stringFromNumber:resultNum];
}

+ (NSString *)A:(NSString *)a jianB:(NSString *)b {
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:a];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:b];
    NSDecimalNumber *resultNum = [num1 decimalNumberBySubtracting:num2];
//    NSNumberFormatter *nFormat = [[NSNumberFormatter alloc] init];
//    [nFormat setDecimalSeparator:@"."];
//    return [nFormat stringFromNumber:resultNum];
    return resultNum.stringValue;
}

+ (NSString *)A:(NSString *)a jianB:(NSString *)b withPlace:(NSInteger)place {
    NSString *aa = a ? (a.length > 0 ? a : @"0") : @"0";
    NSString *bb = b ? (b.length > 0 ? b : @"0") : @"0";
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:aa];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:bb];
    NSDecimalNumber *resultNum = [num1 decimalNumberBySubtracting:num2];
    NSNumberFormatter *nFormat = [[NSNumberFormatter alloc] init];
    [nFormat setDecimalSeparator:@"."];
//    [nFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    [nFormat setMaximumFractionDigits:place];
    [nFormat setMinimumFractionDigits:place];
    if ([resultNum doubleValue] < 1) {
        if ([resultNum doubleValue] > 0) {
            return [NSString stringWithFormat:@"0%@", [nFormat stringFromNumber:resultNum]];
        } else if ([resultNum doubleValue] == 0) {
            NSString *str = [NSString stringWithFormat:@"%@", [nFormat stringFromNumber:resultNum]];
            if (![str hasPrefix:@"0."]) {
                str = [NSString stringWithFormat:@"0%@", [nFormat stringFromNumber:resultNum]];
            }
            return str;
        } else {
            NSString *str = [NSString stringWithFormat:@"%@", [nFormat stringFromNumber:resultNum]];
            if ([str rangeOfString:@"-."].location != NSNotFound) {
                str = [str stringByReplacingOccurrencesOfString:@"-." withString:@"-0."];
            }
            return str;
        }

    }
    return [nFormat stringFromNumber:resultNum];
//    return [self notRounding:[resultNum stringValue] afterPoint:place];

}

+ (NSString *)A:(NSString *)a jianB:(NSString *)b withPlace:(NSInteger)place isKillEndingZero:(BOOL)kill {
    NSString *str = [self A:a jianB:b withPlace:place];
    return kill ? [self commonKill:str] : str;
}

+ (NSString *)A:(NSString *)a chengyiB:(NSString *)b {
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:a];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:b];
    NSDecimalNumber *resultNum = [num1 decimalNumberByMultiplyingBy:num2];
//    NSNumberFormatter *nFormat = [[NSNumberFormatter alloc] init];
//    nFormat.numberStyle = NSNumberFormatterDecimalStyle;
//    [nFormat setDecimalSeparator:@"."];
//    return [nFormat stringFromNumber:resultNum];
    return resultNum.stringValue;
}

+ (NSString *)A:(NSString *)a chengyiB:(NSString *)b withPlace:(NSInteger)place roundingMode:(NSRoundingMode)roundingMode {
    NSString *aa = a ? (a.length > 0 ? a : @"0") : @"0";
    NSString *bb = b ? (b.length > 0 ? b : @"0") : @"0";
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:aa];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:bb];
    NSDecimalNumber *resultNum = [num1 decimalNumberByMultiplyingBy:num2];
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:roundingMode scale:place raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];

    resultNum = [resultNum decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    //    return [self notRounding:[resultNum stringValue] afterPoint:place];
    NSNumberFormatter *nFormat = [[NSNumberFormatter alloc] init];
    [nFormat setDecimalSeparator:@"."];

    //    [nFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    [nFormat setMaximumFractionDigits:place];
    [nFormat setMinimumFractionDigits:place];
    if ([resultNum doubleValue] < 1) {
        if ([resultNum doubleValue] > 0) {
            return [NSString stringWithFormat:@"%@", [nFormat stringFromNumber:resultNum]];
        } else if ([resultNum doubleValue] == 0) {
            NSString *str = [NSString stringWithFormat:@"%@", [nFormat stringFromNumber:resultNum]];
            if (![str hasPrefix:@"0."]) {
                str = [NSString stringWithFormat:@"%@", [nFormat stringFromNumber:resultNum]];
            }
            return str;
        } else {
            NSString *str = [NSString stringWithFormat:@"%@", [nFormat stringFromNumber:resultNum]];
            if ([str rangeOfString:@"-."].location != NSNotFound) {
                str = [str stringByReplacingOccurrencesOfString:@"-." withString:@"-0."];
            }
            return str;
        }
    }
    return [nFormat stringFromNumber:resultNum];
}

+ (NSString *)A:(NSString *)a chengyiB:(NSString *)b withPlace:(NSInteger)place {
    return [FPValueDP A:a chengyiB:b withPlace:place roundingMode:NSRoundDown];
}

+ (NSString *)A:(NSString *)a chengyiB:(NSString *)b withPlace:(NSInteger)place isKillEndingZero:(BOOL)kill {
    NSString *str = [self A:a chengyiB:b withPlace:place];
    return kill ? [self commonKill:str] : str;
}

+ (NSString *)A:(NSString *)a chuyiB:(NSString *)b {
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:a];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:b];
    NSDecimalNumber *resultNum = [num1 decimalNumberByDividingBy:num2];
    return resultNum.stringValue;
}

+ (NSString *)A:(NSString *)a chuyiB:(NSString *)b withPlace:(NSInteger)place {
    return [FPValueDP A:a chuyiB:b withPlace:place roundingMode:NSRoundDown];
}

+ (NSString *)A:(NSString *)a chuyiB:(NSString *)b withPlace:(NSInteger)place roundingMode:(NSRoundingMode)roundingMode {
    NSString *aa = a ? (a.length > 0 ? a : @"0") : @"0";
    NSString *bb = b ? (b.length > 0 ? b : @"0") : @"0";
    if ([bb isEqualToString:@"0"] || [bb doubleValue] == 0) {
        //分母不能为0
        return @"0";
    }
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:aa];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:bb];
    NSDecimalNumber *resultNum = [num1 decimalNumberByDividingBy:num2];
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:roundingMode scale:place raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];

    resultNum = [resultNum decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    //    return [self notRounding:[resultNum stringValue] afterPoint:place];
    NSNumberFormatter *nFormat = [[NSNumberFormatter alloc] init];
    [nFormat setDecimalSeparator:@"."];

    //    [nFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    [nFormat setMaximumFractionDigits:place];
    [nFormat setMinimumFractionDigits:place];
    if ([resultNum doubleValue] < 1) {
        if ([resultNum doubleValue] > 0) {
            return [NSString stringWithFormat:@"0%@", [nFormat stringFromNumber:resultNum]];
        } else if ([resultNum doubleValue] == 0) {
            NSString *str = [NSString stringWithFormat:@"%@", [nFormat stringFromNumber:resultNum]];
            if (![str hasPrefix:@"0."]) {
                str = [NSString stringWithFormat:@"0%@", [nFormat stringFromNumber:resultNum]];
            }
            return str;
        } else {
            NSString *str = [NSString stringWithFormat:@"%@", [nFormat stringFromNumber:resultNum]];
            if ([str rangeOfString:@"-."].location != NSNotFound) {
                str = [str stringByReplacingOccurrencesOfString:@"-." withString:@"-0."];
            }
            return str;
        }
    }
    return [nFormat stringFromNumber:resultNum];
}

+ (NSString *)A:(NSString *)a chuyiB:(NSString *)b withPlace:(NSInteger)place isKillEndingZero:(BOOL)kill {
    NSString *str = [self A:a chuyiB:b withPlace:place];
    return kill ? [self commonKill:str] : str;
}

+ (BOOL)A:(NSString *)a dayuB:(NSString *)b {
//    NSDecimalNumber *discount1 = [NSDecimalNumber decimalNumberWithString:a];
//    NSDecimalNumber *discount2 = [NSDecimalNumber decimalNumberWithString:b];
    NSDictionary *locale = @{NSLocaleDecimalSeparator: @"."};
    NSDecimalNumber *discount1 = [[NSDecimalNumber alloc] initWithString:a locale:locale];
    NSDecimalNumber *discount2 = [[NSDecimalNumber alloc] initWithString:b locale:locale];
    NSComparisonResult result = [discount1 compare:discount2];
    if (result == NSOrderedAscending) {
        return NO;
    } else if (result == NSOrderedSame) {
        return NO;
    } else if (result == NSOrderedDescending) {
        return YES;
    }
    return NO;

}

+ (BOOL)A:(NSString *)a dayuDengyuB:(NSString *)b {
//    NSDecimalNumber *discount1 = [NSDecimalNumber decimalNumberWithString:a];
//    NSDecimalNumber *discount2 = [NSDecimalNumber decimalNumberWithString:b];
    NSDictionary *locale = @{NSLocaleDecimalSeparator: @"."};
    NSDecimalNumber *discount1 = [[NSDecimalNumber alloc] initWithString:a locale:locale];
    NSDecimalNumber *discount2 = [[NSDecimalNumber alloc] initWithString:b locale:locale];
    NSComparisonResult result = [discount1 compare:discount2];
    if (result == NSOrderedAscending) {
        return NO;
    } else if (result == NSOrderedSame) {
        return YES;
    } else if (result == NSOrderedDescending) {
        return YES;
    }
    return NO;
}

+ (BOOL)A:(NSString *)a dengyuB:(NSString *)b; {
//    NSDecimalNumber *discount1 = [NSDecimalNumber decimalNumberWithString:a];
//    NSDecimalNumber *discount2 = [NSDecimalNumber decimalNumberWithString:b];
    NSDictionary *locale = @{NSLocaleDecimalSeparator: @"."};
    NSDecimalNumber *discount1 = [[NSDecimalNumber alloc] initWithString:a locale:locale];
    NSDecimalNumber *discount2 = [[NSDecimalNumber alloc] initWithString:b locale:locale];
    NSComparisonResult result = [discount1 compare:discount2];
    if (result == NSOrderedAscending) {
        return NO;
    } else if (result == NSOrderedSame) {
        return YES;
    } else if (result == NSOrderedDescending) {
        return NO;
    }
    return NO;

}

+ (BOOL)A:(NSString *)a xiaoyuB:(NSString *)b {
//    NSDecimalNumber *discount1 = [NSDecimalNumber decimalNumberWithString:a];
//    NSDecimalNumber *discount2 = [NSDecimalNumber decimalNumberWithString:b];
    NSDictionary *locale = @{NSLocaleDecimalSeparator: @"."};
    NSDecimalNumber *discount1 = [[NSDecimalNumber alloc] initWithString:a locale:locale];
    NSDecimalNumber *discount2 = [[NSDecimalNumber alloc] initWithString:b locale:locale];
    NSComparisonResult result = [discount1 compare:discount2];
    if (result == NSOrderedAscending) {
        return YES;
    } else if (result == NSOrderedSame) {
        return NO;
    } else if (result == NSOrderedDescending) {
        return NO;
    }
    return NO;

}

+ (BOOL)A:(NSString *)a xiaoyuDengyuB:(NSString *)b {
//    NSDecimalNumber *discount1 = [NSDecimalNumber decimalNumberWithString:a];
//    NSDecimalNumber *discount2 = [NSDecimalNumber decimalNumberWithString:b];
    NSDictionary *locale = @{NSLocaleDecimalSeparator: @"."};
    NSDecimalNumber *discount1 = [[NSDecimalNumber alloc] initWithString:a locale:locale];
    NSDecimalNumber *discount2 = [[NSDecimalNumber alloc] initWithString:b locale:locale];
    NSComparisonResult result = [discount1 compare:discount2];
    if (result == NSOrderedAscending) {
        return YES;
    } else if (result == NSOrderedSame) {
        return YES;
    } else if (result == NSOrderedDescending) {
        return NO;
    }
    return NO;
}


+ (NSString *)notRounding:(NSString *)price afterPoint:(NSInteger)position {
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    //    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    ouncesDecimal = [[NSDecimalNumber alloc] initWithString:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    //    return roundedOunces;// 整数的不带小数点
    NSString *string = [NSString stringWithFormat:@"%@", roundedOunces];
    if ([string rangeOfString:@"."].length == 0) {
        string = [string stringByAppendingString:@".00000000"];
    } else {
        NSRange range = [string rangeOfString:@"."];
        if (string.length - range.location - 1 == position) {

        } else {
            NSString *tmp = string;
            for (NSUInteger i = string.length - range.location - 1; i < position; i++) {
                tmp = [tmp stringByAppendingString:@"0"];
            }
            string = tmp;
        }
    }
    return string;//整数.00格式
}

+ (NSString *)string:(NSString *)originStr withPlace:(NSInteger)place {
    NSDecimalNumber *doubleNumber = [NSDecimalNumber decimalNumberWithString:originStr];
    NSNumberFormatter *nFormat = [[NSNumberFormatter alloc] init];
    [nFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    [nFormat setMaximumFractionDigits:place];
    [nFormat setMinimumFractionDigits:place];
    return [nFormat stringFromNumber:doubleNumber];
}


#pragma mark - 公共处理

+ (NSString *)commonKill:(NSString *)str {
    if ([str rangeOfString:@"."].location != NSNotFound) {
        NSString *s = nil;
        NSInteger offset = str.length - 1;
        while (offset) {
            s = [str substringWithRange:NSMakeRange(offset, 1)];
            if ([s isEqualToString:@"0"] && (offset > [str rangeOfString:@"."].location + 2)) {
                offset--;
            } else {
                break;
            }
        }
        NSString *outNumber = [str substringToIndex:offset + 1];
        NSLog(@"%@", outNumber);
        return outNumber;
    }
    return str;
}
@end
