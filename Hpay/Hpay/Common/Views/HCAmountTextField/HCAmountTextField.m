#import "HCAmountTextField.h"

@implementation HCAmountTextField

- (void)configure {
    [super configure];
    self.keyboardType = UIKeyboardTypeDecimalPad;
    self.placeholder = NSLocalizedDefault(@"enter");
}

- (BOOL)isValidAmount:(NSString *)text {
    return (![text isEqualToString:@""] && (text.length > 0));
}

- (BOOL)isAmountDecimalNumberValid:(NSString *)amountText {
    NSDecimalNumber * decimal = [NSDecimalNumber decimalNumberWithString:amountText];
    NSComparisonResult isDecimalZeroComparison = [decimal compare:[NSNumber numberWithDouble:0]];
    return (isDecimalZeroComparison == NSOrderedDescending);
}

@end
