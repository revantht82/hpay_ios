//
//  FPUtils.h
//  GiiiPlus
//
//  Created by apple on 2017/9/5.
//
//

#import <Foundation/Foundation.h>

@interface FPUtils : NSObject
+ (CGFloat)getTextHeight:(NSString *)content;

+ (CGFloat)getTextHeight:(NSString *)content withSize:(CGFloat)fontSize;

+ (CGFloat)getTextHeight:(NSString *)content withSize:(CGFloat)fontSize andwidth:(CGFloat)width;


+ (CGFloat)getTextRoundWidth:(NSString *)content withSize:(CGFloat)fontSize;

+ (CGFloat)getTextWidth:(NSString *)content withSize:(CGFloat)fontSize;

+ (CGFloat)getCodeWidth:(NSString *)content withSize:(CGFloat)fontSize;

+ (NSString *)convertEnToNum:(NSString *)en;

//+ (NSString *)fetchDetailUrlByListType:(StatementListType)type;
//+ (NSString *)fetchDetailNavTitleByListType:(StatementListType)type;

struct MStatement {
    const char *url;
    const char *title;
};

+ (struct MStatement)fetchDetailMStatementByListType:(StatementListType)type;

+ (NSString *)convertByChar:(const char *)strChar;


+ (NSString *)convertSDateStr2UTCDateStr:(NSString *)str;
+ (NSString *)convertStartDateStrToTimeZoneFormat:(NSString *)str;

+ (NSString *)convertEDateStr2UTCDateStr:(NSString *)str;
+ (NSString *)convertEndDateStrToTimeZoneFormat:(NSString *)str;

+ (NSDictionary *)convertMonthDateStr2UTCStrDict:(NSString *)fromDateString toDate:(NSString*)toDateString;


+ (void)saveToCoinListToLocal:(NSArray *)list;

+ (NSArray *)fetchCoinListFromLocal;
@end
