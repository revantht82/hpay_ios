//
//  NSString+Regular.h
//  GiiiPlus
//
//  Created by Mac on 2017/8/30.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Regular)

+ (BOOL)verifyUsernameForKYC:(NSString *)name;

+ (BOOL)verifyEmail:(NSString *)email;

/// Verify the GiiiPlus username, the first letter is capitalized, contains numbers and letters, 6-25 digits
+ (BOOL)verifyGiiiPlusUserName:(NSString *)userName;

+ (BOOL)textIsEmpty:(NSString *)text;

+ (BOOL)verifyUserName:(NSString *)userName;

+ (BOOL)verifyNickname:(NSString *)nickname;

/// Verify login password, 8-20 digits in English plus numbers
+ (BOOL)verifyLoginAccount:(NSString *)account;

+ (BOOL)verifyAllNumber:(NSString *)str;

/// Verify account, password letter plus number
+ (BOOL)verifyAccountOrPwd:(NSString *)content;

+ (BOOL)verifyTextorDigital:(NSString *)text;

/// The password needs 8-24 characters, and the password must contain at least 1 number, 1 symbol, 1 uppercase letter and 1 lowercase letter
+ (BOOL)verifyPasswordWithString:(NSString *)str;

+ (BOOL)verifyMoney:(NSString *)str;

+ (BOOL)verifySingleAccountOrPwd:(NSString *)content;

+ (BOOL)verifySingleSubPwd:(NSString *)content;

/*!
 @brief Fix the loss of floating-point precision
 @param str Pass in the data fetched by the interface
 @return Corrected accuracy data
 */
+ (NSString *)reviseString:(NSString *)str;

#pragma mark - Get the day of the week string according to week no

/**
 * desc : Get the day of the week string according to week no
 */
+ (NSString *)fetchWeekStrByWeekNo:(NSInteger)weekNo;

#pragma mark - Return the month according to the number of months

+ (NSString *)fetchMonthStrByMonthNo:(NSInteger)monthNo;

@end
