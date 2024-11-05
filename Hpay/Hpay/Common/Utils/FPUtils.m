//
//  FPUtils.m
//  GiiiPlus
//
//  Created by apple on 2017/9/5.
//
//

#import "FPUtils.h"
#import "FBCoin.h"

@implementation FPUtils

+ (CGFloat)getTextHeight:(NSString *)content {

    return [self getTextHeight:content withSize:15];
}

+ (CGFloat)getTextHeight:(NSString *)content withSize:(CGFloat)fontSize {
    return [self getTextHeight:content withSize:fontSize andwidth:SCREEN_WIDTH - 40];
}

+ (CGFloat)getTextHeight:(NSString *)content withSize:(CGFloat)fontSize andwidth:(CGFloat)width {
    CGFloat commentH = 0.f;
    NSString *advise = [NSString stringWithFormat:@"%@", content];
    UIFont *font = UIFontMake(fontSize);
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize retSize = [advise boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                          options:
                                                  NSStringDrawingTruncatesLastVisibleLine |
                                                          NSStringDrawingUsesLineFragmentOrigin |
                                                          NSStringDrawingUsesFontLeading
                                       attributes:attribute
                                          context:nil].size;
    commentH += ceil(retSize.height) + 4;
    if (commentH == 0) {
        return 21;
    }
    return commentH;
}

+ (CGFloat)getTextRoundWidth:(NSString *)content withSize:(CGFloat)fontSize {
    CGFloat commentH = 0.f;
    NSString *advise = [NSString stringWithFormat:@"%@", content];
    UIFont *font = UIFontMake(fontSize);
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize retSize = [advise boundingRectWithSize:CGSizeMake(24, MAXFLOAT)
                                          options:
                                                  NSStringDrawingTruncatesLastVisibleLine |
                                                          NSStringDrawingUsesLineFragmentOrigin |
                                                          NSStringDrawingUsesFontLeading
                                       attributes:attribute
                                          context:nil].size;
    commentH += ceil(retSize.width) + 12;
    if (content.length == 1) {
        return 14;
    }
    return commentH;
}

+ (CGFloat)getTextWidth:(NSString *)content withSize:(CGFloat)fontSize {
    CGFloat commentH = 0.f;
    NSString *advise = [NSString stringWithFormat:@"%@", content];
    UIFont *font = UIFontMake(fontSize);
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize retSize = [advise boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 70, MAXFLOAT)
                                          options:
                                                  NSStringDrawingTruncatesLastVisibleLine |
                                                          NSStringDrawingUsesLineFragmentOrigin |
                                                          NSStringDrawingUsesFontLeading
                                       attributes:attribute
                                          context:nil].size;
    commentH += ceil(retSize.width) + 70;
    return commentH;
}

+ (CGFloat)getCodeWidth:(NSString *)content withSize:(CGFloat)fontSize {
    CGFloat commentH = 0.f;
    NSString *advise = [NSString stringWithFormat:@"%@", content];
    UIFont *font = UIFontMake(fontSize);
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize retSize = [advise boundingRectWithSize:CGSizeMake(60, MAXFLOAT)
                                          options:
                                                  NSStringDrawingTruncatesLastVisibleLine |
                                                          NSStringDrawingUsesLineFragmentOrigin |
                                                          NSStringDrawingUsesFontLeading
                                       attributes:attribute
                                          context:nil].size;
    commentH += ceil(retSize.width) + 6;
    return commentH;
}

+ (NSString *)convertEnToNum:(NSString *)en {
    if ([en isEqualToString:@"January"]) {
        return @"1";
    } else if ([en isEqualToString:@"February"]) {
        return @"2";
    } else if ([en isEqualToString:@"March"]) {
        return @"3";
    } else if ([en isEqualToString:@"April"]) {
        return @"4";
    } else if ([en isEqualToString:@"May"]) {
        return @"5";
    } else if ([en isEqualToString:@"June"]) {
        return @"6";
    } else if ([en isEqualToString:@"July"]) {
        return @"7";
    } else if ([en isEqualToString:@"August"]) {
        return @"8";
    } else if ([en isEqualToString:@"September"]) {
        return @"9";
    } else if ([en isEqualToString:@"October"]) {
        return @"10";
    } else if ([en isEqualToString:@"November"]) {
        return @"11";
    } else if ([en isEqualToString:@"December"]) {
        return @"12";
    }
    return @"";
}

//#pragma mark - 根据listType获取详情的URL
//+ (NSString *)fetchDetailUrlByListType:(StatementListType)type
//{
//    NSString *url = @"";
//    switch (type) {
//        case StatementListTypeDeposit:
//            //充币
//            url = DepositDetailURL;
//            break;
//        case StatementListTypeWithdraw:
//            //提币
//            url = WithdrawDetailURL;
//            break;
//        case StatementListTypePay:
//            //线下消费
//            url = OrderDetailURL;
//            break;
//        case StatementListTypeRefund:
//            //退款
//            url = OrderDetailURL;
//            break;
//        case StatementListTypeTransferOut:
//        case StatementListTypeTransferIn:
//            //转账
//            url = TransferDetailURL;
//            break;
//            
//        case StatementListTypeGateway:
//            //网购订单
//            url = GatewayOrderDetailURL;
//            break;
//        case StatementListTypeGatewayBack:
//            //网购退单
//            url = GatewayOrderDetailURL;
//            break;
////        case 11:
////            //缴费
////            url = BillerDetailURL;
////            break;
////        case 12:
////            //红包
////            url = BillerDetailURL;
////            break;
//        default:
//            break;
//    }
//    return url;
//}
#pragma mark - 根据listType获取详情navigation title

+ (struct MStatement)fetchDetailMStatementByListType:(StatementListType)type {
    struct MStatement mStatement;
    switch (type) {
        case StatementListTypeDeposit:
            //充币
            mStatement.url = [self convertByString:DepositDetailURL];
            break;
        case StatementListTypeWithdraw:
            //提币
            mStatement.url = [self convertByString:WithdrawDetailURL];
            break;
        case StatementListTypePay:
            //线下消费
            mStatement.url = [self convertByString:OrderDetailURL];
            break;
//        case StatementListTypeRefund:
//            //退款
//            mStatement.url = [self convertByString:OrderDetailURL];
//            break;
        case StatementListTypeTransferOut:
        case StatementListTypeTransferIn:
            //转账
            mStatement.url = [self convertByString:TransferDetailURL];
            break;
        case StatementListTypeGPayExchangeOut:
        case StatementListTypeGPayExchangeIn:
            //闪兑
            mStatement.url = [self convertByString:FastExchangDetailURL];
            break;
        case StatementListTypeGPayBuyCrpytoCode:
            //买币
            mStatement.url = [self convertByString:CurrencyPurchaseStatementDetailURL];
            break;
        case StatementListTypeGPaySellCrpytoCode:
            //售币
            mStatement.url = [self convertByString:CurrencySellingStatementDetailURL];
            break;
        case StatementListTypeGatewayOrderOutcome:
        case StatementListTypeGatewayOrderRefund:
            mStatement.url = [self convertByString:GatewayOrderOutcomeDetailURL];
            break;
        case StatementListTypeGateway:
        case StatementListTypeGatewayBack:
            //网购退单
            mStatement.url = [self convertByString:GatewayOrderIncomeDetailURL];
            break;
        case StatementListTypeHuazhuanOut:
        case StatementListTypeHuazhuanIn:
            mStatement.url = [self convertByString:HuaZhuanDetailURL];
            break;
        case StatementListTypeMerchantPaymentOut:
        case StatementListTypeMerchantPaymentIn:
            mStatement.url = [self convertByString:kMerchantPaymentDetailURL];
            break;
        case StatementListTypeMerchantRefund:
            mStatement.url = [self convertByString:kMerchantRefundDetailURL];
            break;
        case StatementListTypeMerchantRefundOut:
            mStatement.url = [self convertByString:kMerchantRefundDetailURL];
            break;
        case StatementListTypeRequestFundIn...StatementListTypeRequestPaymentOut:
            mStatement.url = [self convertByString:RequestFundDetailURL];
            break;
            
        default:
            //线下消费
            mStatement.url = [self convertByString:OrderDetailURL];
            break;
    }
    mStatement.title = [self convertByString:NSLocalizedStatement(@"details")];
    return mStatement;
}

+ (const char *)convertByString:(NSString *)str {
    const char *strChar = [str UTF8String];
    return strChar;
}

+ (NSString *)convertByChar:(const char *)strChar {
    if (strChar == NULL) {
        return nil;
    }
    NSString *str = [NSString stringWithUTF8String:strChar];
    return str;
}

+ (NSString *)convertStartDateStrToTimeZoneFormat:(NSString *)str {
    NSString *utcDateStr = nil;
    if (str && str.length > 0) {
        NSString *dateString = [str stringByAppendingString:@"T00:00:00.000"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.timeZone = [NSTimeZone localTimeZone];
        formatter.dateFormat = @"Z";
        NSString *formattedCurrentTimeZone = [formatter stringFromDate:[NSDate date]];
        NSString *dateStringWithTimezone = [dateString stringByAppendingString:formattedCurrentTimeZone];
        utcDateStr = dateStringWithTimezone;
    }
    return utcDateStr;
}

+ (NSString *)convertEndDateStrToTimeZoneFormat:(NSString *)str {
    NSString *utcDateStr = nil;
    if (str && str.length > 0) {
        NSString *dateString = [str stringByAppendingString:@"T23:59:59.000"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.timeZone = [NSTimeZone localTimeZone];
        formatter.dateFormat = @"Z";
        NSString *formattedCurrentTimeZone = [formatter stringFromDate:[NSDate date]];
        NSString *dateStringWithTimezone = [dateString stringByAppendingString:formattedCurrentTimeZone];
        utcDateStr = dateStringWithTimezone;
    }
    return utcDateStr;
}

// MARK: - OLD Convert Helpers
+ (NSString *)convertSDateStr2UTCDateStr:(NSString *)str {
    NSString *utcDateStr = nil;
    if (str && str.length > 0) {
        NSString *tmpStr = [str stringByAppendingString:@" 00:00:00"];
        utcDateStr = [self getUTCStrFormateLocalStr:tmpStr];
    }
    return utcDateStr;
}

+ (NSString *)convertEDateStr2UTCDateStr:(NSString *)str {
    NSString *utcDateStr = nil;
    if (str && str.length > 0) {
        NSString *tmpStr = [str stringByAppendingString:@" 23:59:59"];
        utcDateStr = [self getUTCStrFormateLocalStr:tmpStr];
    }
    return utcDateStr;
}

+ (NSDictionary *)convertMonthDateStr2UTCStrDict:(NSString *)fromDateString toDate:(NSString*)toDateString {
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    NSArray *fAndlArr = [self getMonthFirstAndLastDayWith:fromDateString];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    
    if (fAndlArr && fAndlArr.count > 0) {
        NSString *StartDateStr = fAndlArr.firstObject;
        NSString *EndDateStr = fAndlArr.lastObject;
        if (StartDateStr && StartDateStr.length > 0) {
            StartDateStr = [self convertStartDateStrToTimeZoneFormat:StartDateStr];
            mDict[@"StartDate"] = [format dateFromString:fromDateString];
        }
        if (EndDateStr && EndDateStr.length > 0) {
            EndDateStr = [self convertEndDateStrToTimeZoneFormat:EndDateStr];
            mDict[@"EndDate"] = [format dateFromString:toDateString];
        }
    }
    return [mDict mutableCopy];
}

+ (NSDate *)nsstringConversionNSDate:(NSString *)dateStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *datestr = [dateFormatter dateFromString:dateStr];
    return datestr;
}

/**
 将本地日期字符串转为UTC日期字符串
 eg: 2017-10-25 02:07:39 -> 2017-10-24 18:07:39
 */
+ (NSString *)getUTCStrFormateLocalStr:(NSString *)localStr {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *dateFormatted = [format dateFromString:localStr];
    format.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSString *dateString = [format stringFromDate:dateFormatted];
//    if ([dateString rangeOfString:@" "].location != NSNotFound)
//    {
//        dateString = [dateString substringWithRange:NSMakeRange(0, [dateString rangeOfString:@" "].location)];
//    }
    return dateString;
}

//获取当月第一天和最后一天
+ (NSArray *)getMonthFirstAndLastDayWith:(NSString *)dateStr {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate *newDate = [format dateFromString:dateStr];
    double interval = 0;
    NSDate *firstDate = nil;
    NSDate *lastDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];

    BOOL OK = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&firstDate interval:&interval forDate:newDate];

    if (OK) {
        lastDate = [firstDate dateByAddingTimeInterval:interval - 1];
    } else {
        return @[@"", @""];
    }

    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *firstString = [myDateFormatter stringFromDate:newDate];
    NSString *lastString = [myDateFormatter stringFromDate:lastDate];
    return @[firstString, lastString];
}

#pragma mark - 保存首页币种数据到列表

+ (void)saveToCoinListToLocal:(NSArray *)list {
    NSArray *arr = [FBCoin mj_keyValuesArrayWithObjectArray:list];
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"HOMECOINLIST"];
}

#pragma mark - 读取首页币种数据到列表

+ (NSArray *)fetchCoinListFromLocal {
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"HOMECOINLIST"];
    if (arr && arr.count > 0) {
        arr = [FBCoin mModelArrayWithData:arr];
    }
    return arr;
}
@end
