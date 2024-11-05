#import "DecimalUtils.h"

@implementation DecimalUtils

- (NSNumberFormatter*)numberFormatter {
    if (!_numberFormatter) {
        _numberFormatter = [[NSNumberFormatter alloc] init];
        [_numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [_numberFormatter setMinimumFractionDigits:2];
        [_numberFormatter setMaximumFractionDigits:2];
        [_numberFormatter setDecimalSeparator:@"."];
        [_numberFormatter setAlwaysShowsDecimalSeparator:YES];
    }
    return _numberFormatter;
}

static DecimalUtils *shared = nil;

// MARK: - Static

+ (DecimalUtils*)shared {
    static dispatch_once_t dispatchOnce;

    dispatch_once(&dispatchOnce,^{
        shared = [[DecimalUtils alloc] init];
    });
    return shared;
}

- (NSString*)stringWithFractionDigitsWithInput:(NSString*)input withExactNumberOfDigits:(NSUInteger)decimalDigits {
    NSNumber *currentNumber = [self.numberFormatter numberFromString:input];
    NSString *decimalString = [NSString stringWithFormat:@"%%.%luf", (unsigned long)decimalDigits];
    return [NSString stringWithFormat:decimalString, [currentNumber doubleValue]];
}

- (NSString*)stringInLocalisedFormatWithInput:(NSString*)input preferredFractionDigits:(NSUInteger)fractionDigits {
    NSNumberFormatter *formatter = [self.numberFormatter copy];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMinimumFractionDigits:fractionDigits];
    [formatter setMaximumFractionDigits:fractionDigits];
    NSNumber *inputNumber = [formatter numberFromString:input];
    [formatter setUsesGroupingSeparator:YES];
    [formatter setDecimalSeparator:NSLocale.currentLocale.decimalSeparator];
    [formatter setGroupingSeparator:NSLocale.currentLocale.groupingSeparator];
    return [formatter stringFromNumber:inputNumber];
}

@end
