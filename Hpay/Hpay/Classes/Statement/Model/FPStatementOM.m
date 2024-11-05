//
//  FPStatementOM.m
//  FiiiPay
//
//  Created by apple on 2018/4/16.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "FPStatementOM.h"
#import "NSString+UTCTimeStamp.h"

@implementation FPStatementOM
MJCodingImplementation

- (id)copyWithZone:(NSZone *)zone {
    FPStatementOM *copy = [[[self class] allocWithZone:zone] init];
    copy.OrderId = self.OrderId;
    copy.IconUrl = self.IconUrl;
    copy.Code = self.Code;
    copy.Status = self.Status;
    copy.StatusName = self.StatusName;
    copy.Name = self.Name;
    copy.Timestamp = self.Timestamp;
    copy.FiatAmount = self.FiatAmount;
    copy.FiatCurrency = self.FiatCurrency;
    copy.CryptoAmount = self.CryptoAmount;
    copy.Type = self.Type;

    copy.utc2Local = self.utc2Local;
    copy.dateGroupTitle = self.dateGroupTitle;
    copy.typeName = self.typeName;
    copy.BEtypeName = self.BEtypeName;
    copy.RefundStatusStr = self.RefundStatusStr;
    return copy;
}

+ (NSDictionary *)mDataReplaceDictionary {
    return @{
            @"OrderId": @"OrderId",
            @"IconUrl": @"IconUrl",
            @"Code": @"Code",
            @"Status": @"Status",
            @"StatusName": @"StatusName",
            @"Name": @"Name",
            @"Timestamp": @"Timestamp",
            @"FiatAmount": @"FiatAmount",
            @"FiatCurrency": @"FiatCurrency",
            @"CryptoAmount": @"CryptoAmount",
            @"Type": @"Type",
            @"RefundStatusStr": @"RefundStatusStr",
            @"decimalPlace": @"DecimalPlace",
            @"BEtypeName":@"TypeName"
    };
}

+ (NSArray *)mModelArrayWithData:(NSArray *)data {
    [FPStatementOM mj_setupReplacedKeyFromPropertyName:^NSDictionary * {
        return [FPStatementOM mDataReplaceDictionary];
    }];
    return [self mj_objectArrayWithKeyValuesArray:data];
}

+ (instancetype)mModelWithData:(NSDictionary *)data {
    [FPStatementOM mj_setupReplacedKeyFromPropertyName:^NSDictionary * {
        return [FPStatementOM mDataReplaceDictionary];
    }];
    return [self mj_objectWithKeyValues:data];
}

- (NSString *)utc2Local {
    if (self.Timestamp) {
        NSString *str = [NSString timespToSystemTimeZoneFormat:self.Timestamp];
        return str;
    }

    return @"";
}

- (NSString *)dateGroupTitle {
    NSDate *localDate = [NSDate dateWithTimeIntervalSince1970:[self.Timestamp doubleValue]/1000.0];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    return [dateFormatter stringFromDate:localDate];
}

- (NSString *)typeName {

    if (self.BEtypeName) return self.BEtypeName;
        
    NSString *str = @"";
    if (self.Type) {
        switch ([self.Type integerValue]) {
            case StatementListTypeDeposit:
                //充币
                str = NSLocalizedStatement(@"deposit");
                break;
            case StatementListTypeWithdraw:
                //提币
                str = NSLocalizedStatement(@"withdrawal");
                break;
            case StatementListTypePay:
                //消费
                str = NSLocalizedStatement(@"offline_consumption");
                break;
//            case StatementListTypeRefund:
//                //退款
//                str = NSLocalizedStatement(@"offline_consumption");
//                break;
            case StatementListTypeTransferOut:
                str = NSLocalizedStatement(@"transactionHistory.sent");
                break;
            case StatementListTypeTransferIn:
                str = NSLocalizedString(@"transactionHistory.received", @"Transaction history screen HpayToHpayIn label");
                break;
            case StatementListTypeGPayExchangeOut:
            case StatementListTypeGPayExchangeIn:
                //闪兑
                str = NSLocalizedDefault(@"exchange");
                break;
            case StatementListTypeGPayBuyCrpytoCode:
                //购买币
                str = NSLocalizedDefault(@"purchase_token");
                break;
            case StatementListTypeGPaySellCrpytoCode:
                //售币
                str = NSLocalizedDefault(@"sell_token");
                break;
            case StatementListTypeGatewayOrderOutcome:
            case StatementListTypeGatewayOrderRefund:
                str = NSLocalizedDefault(@"online_payment");
                break;
            case StatementListTypeGateway:
            case StatementListTypeGatewayBack:
                str = NSLocalizedDefault(@"gateway_financial_report");
                break;
            case StatementListTypeHuazhuanOut:
                str = NSLocalizedString(@"transactionHistory.transferred_out", @"Transaction history screen HpayToExchangeOut label");
                break;
            case StatementListTypeHuazhuanIn:
                str = NSLocalizedString(@"transactionHistory.transferred_in", @"Transaction history screen ExchangeToHpayIn label");
                break;
            case StatementListTypeMerchantPaymentOut:
                str = NSLocalizedStatement(@"purchased");
                break;
            case StatementListTypeMerchantPaymentIn:
                str = NSLocalizedStatement(@"payment_received");
                break;
            case StatementListTypeMerchantRefund:
                str = NSLocalizedStatement(@"refunded");
                break;
                
            case StatementListTypeMerchantRefundOut:
                str = NSLocalizedStatement(@"refund_out");
                break;
                
            case StatementListTypeRequestFundIn:
                if ([self.Status isEqual:@"1"]) {
                    str = NSLocalizedStatement(@"RequestFund");
                    
                } else if ([self.Status isEqual:@"2"]) {
                    str = NSLocalizedStatement(@"ReceivedRequest");
                } else {
                    str = NSLocalizedStatement(@"UnknownData");
                }
                break;
            case StatementListTypeRequestFundOut:
                if ([self.Status isEqual:@"1"]) {
                    str = NSLocalizedStatement(@"UnknownData");
                    
                } else if ([self.Status isEqual:@"2"]) {
                    str = NSLocalizedStatement(@"SentRequest");
                } else {
                    str = NSLocalizedStatement(@"UnknownData");
                }
                break;
            case StatementListTypeRequestPaymentIn:
                if ([self.Status isEqual:@"1"]) {
                    str = NSLocalizedStatement(@"request");
                    
                } else if ([self.Status isEqual:@"2"]) {
                    str = NSLocalizedStatement(@"ReceivedRequest");
                } else {
                    str = NSLocalizedStatement(@"UnknownData");
                }
                break;
            case StatementListTypeRequestPaymentOut:
                if ([self.Status isEqual:@"1"]) {
                    str = NSLocalizedStatement(@"UnknownData");
                    
                } else if ([self.Status isEqual:@"2"]) {
                    str = NSLocalizedStatement(@"SentRequest");
                } else {
                    str = NSLocalizedStatement(@"UnknownData");
                }
                break;
            default:
                break;
        }
    }
    return str;
}
@end
