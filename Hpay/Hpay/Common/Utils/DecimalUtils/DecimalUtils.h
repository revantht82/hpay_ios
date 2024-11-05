@interface DecimalUtils : NSObject

@property(strong, nonatomic) NSNumberFormatter *numberFormatter;

+ (DecimalUtils*)shared;
- (NSString*)stringWithFractionDigitsWithInput:(NSString*)input withExactNumberOfDigits:(NSUInteger)decimalDigits;
- (NSString*)stringInLocalisedFormatWithInput:(NSString*)input preferredFractionDigits:(NSUInteger)fractionDigits;

@end
