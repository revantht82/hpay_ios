#import "PreTransferModel.h"

@implementation PreTransferModel

- (NSString *)price {
    if ([_Price isEqualToString:@""] || !_Price) {
        return @"0";
    } else {
        return _Price;
    }
}

- (NSString *)minCount {
    if ([_MinCount isEqualToString:@""] || !_MinCount) {
        return @"0";
    } else {
        return _MinCount;
    }
}

- (NSString *)coinBalance {
    if ([_CoinBalance isEqualToString:@""] || !_CoinBalance) {
        return @"0";
    } else {
        return _CoinBalance;
    }
}

- (NSString *)chargeFee {
    if ([_ChargeFee isEqualToString:@""] || !_ChargeFee) {
        return @"0";
    } else {
        return _ChargeFee;
    }
}

- (NSString *)givenName {
    NSString *name = [self.ToFullname componentsSeparatedByString:@" "].firstObject;
    if ([name length] > 0) {
        return name;
    }
    
    return @"";
}

- (NSString *)familyName {
    NSString *name = [self.ToFullname componentsSeparatedByString:@" "].lastObject;
    if ([name length] > 1 && ![self.givenName isEqualToString:name]) {
        return name;
    }
    
    return @"";
}

@end
