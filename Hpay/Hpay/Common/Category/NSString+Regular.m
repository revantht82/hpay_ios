//
//  NSString+Regular.m
//  GiiiPlus
//
//  Created by Mac on 2017/8/30.
//
//

#import "NSString+Regular.h"

@implementation NSString (Regular)

static NSString *const usernamePatternForKYC = @"[&<>(){}*%+,;:=^|]";
static NSString *const emailPattern = @"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*.\\w+([-.]\\w+)*$";
static NSString *const namePattern = @"^[a-zA-Z\\s·]*$";
static NSString *const userNamePattern = @"^[A-Z](?![a-zA-Z]+$)[0-9A-Za-z]{5,24}$";
static NSString *const loginPasswordPattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$";
static NSString *const loginPasswordRegexPatternZ = @"^[A-Za-z]{6,12}$";
static NSString *const loginPasswordRegexPatternN = @"^[0-9]{6,12}$";
static NSString *const verifyTextOrDigitalPattern = @"^[A-Za-z0-9]+$";
static NSString *const verifyAllNumberPattern = @"^[A-Za-z0-9]+$";
static NSString *const verifyMoneyPattern = @"(^[0-9]+$)|[.]?";

static NSString *const checkNamesForBothLanguage = @"/([A-Za-z]|\{Script=Hani})+/gu";
static NSString *const checkNamesOnlyAcceptsUnicodeCharsPattern = @"\p{^L}";

+ (BOOL)verifyUsernameForKYC:(NSString *)name {
    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", usernamePatternForKYC];
    return ![self textIsEmpty:name] && [self verifyUserName:name] && ![namePredicate evaluateWithObject:name];
}

+ (BOOL)verifyNickname:(NSString *)nickname {
    if (!nickname) nickname = @"";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z0-9\\s]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *specialCharCount = [regex stringByReplacingMatchesInString:nickname options:0 range:NSMakeRange(0, [nickname length]) withTemplate:@""];

    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[a-zA-Z]{1}(?=.*[0-9])[A-Za-z0-9@_]{5,12}$"];
    
    if ( ([namePredicate evaluateWithObject:nickname] && [specialCharCount length] <= 1) || [nickname length] == 0 ){
        return TRUE;
    }
    else {
        return FALSE;
    }
        
}

+ (BOOL)verifyEmail:(NSString *)email {
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailPattern];
    return [emailPredicate evaluateWithObject:email];
}

+ (BOOL)verifyUserName:(NSString *)userName {

    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", namePattern];
    return [namePredicate evaluateWithObject:userName];
}

+ (BOOL)verifyGiiiPlusUserName:(NSString *)userName {
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", userNamePattern];
    return [userNamePredicate evaluateWithObject:userName];
}

+ (BOOL)textIsEmpty:(NSString *)text {
    NSString *str = text;
    if (!str) {
        return YES;
    } else {

        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];

        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];

        if ([trimedString length] == 0) {
            return YES;
        } else {
            return NO;
        }
    }
}

/// Verify login password, 8-20 digits in English plus numbers
+ (BOOL)verifyLoginAccount:(NSString *)account {
    NSPredicate *loginPassworkPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", loginPasswordPattern];
    return [loginPassworkPredicate evaluateWithObject:account];
}

+ (BOOL)verifySingleAccountOrPwd:(NSString *)content {
    NSPredicate *loginPassworkPredicateZ = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", loginPasswordRegexPatternZ];
    NSPredicate *loginPassworkPredicateN = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", loginPasswordRegexPatternN];
    return [loginPassworkPredicateZ evaluateWithObject:content] || [loginPassworkPredicateN evaluateWithObject:content];
}

+ (BOOL)verifySingleSubPwd:(NSString *)content {
    NSPredicate *loginPassworkPredicateN = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", loginPasswordRegexPatternN];
    return [loginPassworkPredicateN evaluateWithObject:content];
}

/// Verify account, password letter plus number
+ (BOOL)verifyAccountOrPwd:(NSString *)content {
    NSPredicate *loginPassworkPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", loginPasswordPattern];
    return [loginPassworkPredicate evaluateWithObject:content];
}

+ (BOOL)verifyTextorDigital:(NSString *)text {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", verifyTextOrDigitalPattern];
    return [predicate evaluateWithObject:text];
}

+ (BOOL)verifyAllNumber:(NSString *)str {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", verifyAllNumberPattern];
    return [predicate evaluateWithObject:str];
}

/// The password needs 8-24 characters, and the password must contain at least 1 number, 1 symbol, 1 uppercase letter and 1 lowercase letter
+ (BOOL)verifyPasswordWithString:(NSString *)str {
    if (str.length >= 8 && str.length <= 24) {
        NSString *numberStrs = @"01234567890";
        NSString *symbolStrs = @"-/:;()£&@\".,?!'[]{}#%^*+=_\\|~<>€$¥•";
        NSString *letterStrs = @"abcdefghijklmnopqrstuvwxyz";
        NSString *capitalLetterStrs = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        NSString *temp = nil;
        BOOL hasNumberStr = NO;
        BOOL hassymbolStr = NO;
        BOOL hasLetterStr = NO;
        BOOL hasCapitalLetterStrs = NO;
        for (int i = 0; i < [str length]; i++) {
            temp = [str substringWithRange:NSMakeRange(i, 1)];
            if ([numberStrs containsString:temp]) {
                hasNumberStr = YES;
                continue;
            } else if ([symbolStrs containsString:temp]) {
                hassymbolStr = YES;
                continue;
            } else if ([letterStrs containsString:temp]) {
                hasLetterStr = YES;
                continue;
            } else if ([capitalLetterStrs containsString:temp]) {
                hasCapitalLetterStrs = YES;
                continue;
            }
        }
        if (hasNumberStr && hassymbolStr && hasLetterStr && hasCapitalLetterStrs) {
            return YES;
        }

    }
    return NO;
}

+ (BOOL)verifyMoney:(NSString *)str {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", verifyMoneyPattern];
    return [predicate evaluateWithObject:str];
}

+ (NSString *)reviseString:(NSString *)str {
    //Directly pass in the Double type with a problematic precision loss
    double conversionValue = [str doubleValue];
    NSString *doubleString = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

#pragma mark - Get the day of the week string according to week no

+ (NSString *)fetchWeekStrByWeekNo:(NSInteger)weekNo {
    NSString *str = @"";
    switch (weekNo) {
        case 1:
            str = @"Sunday";
            break;
        case 2:
            str = @"Monday";
            break;
        case 3:
            str = @"Tuesday";
            break;
        case 4:
            str = @"Wednesday";
            break;
        case 5:
            str = @"Thurday";
            break;
        case 6:
            str = @"Friday";
            break;
        case 7:
            str = @"Saturday";
            break;
        default:
            break;
    }
    return str;
}

#pragma mark - Return the month according to the number of months

+ (NSString *)fetchMonthStrByMonthNo:(NSInteger)monthNo {
    NSString *str = @"";
    switch (monthNo) {
        case 1:
            str = @"January";
            break;
        case 2:
            str = @"February";
            break;
        case 3:
            str = @"March";
            break;
        case 4:
            str = @"April";
            break;
        case 5:
            str = @"May";
            break;
        case 6:
            str = @"June";
            break;
        case 7:
            str = @"July";
            break;
        case 8:
            str = @"Aguest";
            break;
        case 9:
            str = @"September";
            break;
        case 10:
            str = @"October";
            break;
        case 11:
            str = @"November";
            break;
        case 12:
            str = @"December";
            break;
        default:
            break;
    }
    return str;
}


@end
