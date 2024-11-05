#import "FPStatementDetailOM.h"
#import "NSString+UTCTimeStamp.h"
#import "DecimalUtils.h"

@implementation FPStatementDetailOM
MJCodingImplementation

- (id)copyWithZone:(NSZone *)zone {
    FPStatementDetailOM *copy = [[[self class] allocWithZone:zone] init];
    copy.Id = self.Id;
    copy.Code = self.Code;
    copy.Timestamp = self.Timestamp;
    copy.CreationTimeStamp = self.CreationTimeStamp;
    copy.ExpiredTimeStamp = self.ExpiredTimeStamp;
    copy.FiatAmount = self.FiatAmount;
    copy.FiatCurrency = self.FiatCurrency;
    copy.CryptoAmount = self.CryptoAmount;
    copy.Type = self.Type;
    copy.Status = self.Status;
    copy.MerchantName = self.MerchantName;
    copy.MarkUp = self.MarkUp;
    copy.TotalFiatAmount = self.TotalFiatAmount;
    copy.ExchangeRate = self.ExchangeRate;
    copy.RefundTimestamp = self.RefundTimestamp;
    copy.OrderNo = self.OrderNo;

    copy.CurrentExchangeRate = self.CurrentExchangeRate;
    copy.IncreaseRate = self.IncreaseRate;


    copy.StatusName = self.StatusName;
    copy.Name = self.Name;
    copy.TransactionFee = self.TransactionFee;
    copy.Address = self.Address;
    copy.CheckTime = self.CheckTime;
    copy.TransactionId = self.TransactionId;
    copy.Note = self.Note;
    copy.Notes = self.Notes;
    copy.ProductCategory = self.ProductCategory;
    copy.Tag = self.Tag;
    copy.NeedTag = self.NeedTag;

    copy.TradeType = self.TradeType;
    copy.TransferType = self.TransferType;
    copy.RequestType = self.RequestType;
    copy.CoinCode = self.CoinCode;
    copy.CoinName = self.CoinName;
    copy.Amount = self.Amount;
    copy.AvailableBalance = self.AvailableBalance;
    copy.AccountName = self.AccountName;
    copy.Fullname = self.Fullname;
    copy.CorrespondingName = self.CorrespondingName;
    copy.RelatedAccountName = self.RelatedAccountName;
    copy.RelatedUserName = self.RelatedUserName;
    copy.ExTransferTypeStr = self.ExTransferTypeStr;
    copy.ExTransferType = self.ExTransferType;
    copy.CryptoCode = self.CryptoCode;

    copy.oTime = self.oTime;
    copy.refundOTime = self.refundOTime;

    copy.SelfPlatform = self.SelfPlatform;

    copy.TradeDescription = self.TradeDescription;
    copy.BonusFrom = self.BonusFrom;
    copy.TypeStr = self.TypeStr;
    copy.TradeNo = self.TradeNo;
    copy.BillerCode = self.BillerCode;
    copy.ReferenceNumber = self.ReferenceNumber;

    copy.HasRefund = self.HasRefund;
    copy.RefundAmount = self.RefundAmount;
    copy.PocketId = self.PocketId;
    copy.redPocketRefundStr = self.redPocketRefundStr;
    copy.CryptoActualAmount = self.CryptoActualAmount;
    copy.UserAccountName = self.UserAccountName;
    copy.FeeCryptoCode = self.FeeCryptoCode;
    copy.TransactionTypeId = self.TransactionTypeId;
    copy.profitOTime = self.profitOTime;
    copy.PayTypeName = self.PayTypeName;
    copy.DetailTypeName = self.DetailTypeName;
    copy.PayType = self.PayType;
    copy.ActualCryptoAmount = self.ActualCryptoAmount;
    copy.CustomerAccount = self.CustomerAccount;
    copy.Reference = self.Reference;
    copy.DecimalPlace = self.DecimalPlace;
    copy.filePath = self.filePath;
    copy.fileType = self.fileType;
    copy.fileName = self.fileName;
    copy.NickName = self.NickName;
    copy.GroupReference = self.GroupReference;
    
    return copy;
}

+ (NSDictionary *)mDataReplaceDictionary {
    return @{
            @"CurrentExchangeRate": @"CurrentExchangeRate",
            @"IncreaseRate": @"IncreaseRate",
            @"Id": @"Id",
            @"Code": @"Code",
            @"Timestamp": @"Timestamp",
            @"CreationTimeStamp": @"CreationTimeStamp",
            @"ExpiredTimeStamp": @"ExpiredTimeStamp",
            @"FiatAmount": @"FiatAmount",
            @"FiatCurrency": @"FiatCurrency",
            @"CryptoAmount": @"CryptoAmount",
            @"Type": @"Type",
            @"Status": @"Status",
            @"MerchantName": @"MerchantName",
            @"MarkUp": @"MarkUp",
            @"TotalFiatAmount": @"TotalFiatAmount",
            @"ExchangeRate": @"ExchangeRate",
            @"RefundTimestamp": @"RefundTimestamp",
            @"OrderNo": @"OrderNo",
            @"Remark": @"Remark",
            @"StatusName": @"StatusName",
            @"Name": @"Name",
            @"TransactionFee": @"TransactionFee",
            @"Address": @"Address",
            @"CheckTime": @"CheckTime",
            @"TransactionId": @"TransactionId",
            @"Note": @"Note",
            @"Notes": @"Notes",
            @"ProductCategory": @"ProductCategory",
            @"Tag": @"Tag",
            @"NeedTag": @"NeedTag",
            @"SelfPlatform": @"SelfPlatform",
            @"TradeType": @"TradeType",
            @"TransferType": @"TransferType",
            @"RequestType": @"RequestType",
            @"CoinCode": @"CoinCode",
            @"CoinName": @"CoinName",
            @"Amount": @"Amount",
            @"AvailableBalance": @"AvailableBalance",
            @"AccountName": @"AccountName",
            @"Fullname": @"Fullname",
            @"CorrespondingName": @"CorrespondingName",
            @"RelatedAccountName": @"RelatedAccountName",
            @"RelatedUserName": @"RelatedUserName",
            @"ExTransferType": @"ExTransferType",
            @"CryptoCode": @"CryptoCode",
            @"ExTransferTypeStr": @"ExTransferTypeStr",
            @"TradeDescription": @"TradeDescription",
            @"BonusFrom": @"BonusFrom",
            @"TypeStr": @"TypeStr",
            @"TradeNo": @"TradeNo",
            @"HasRefund": @"HasRefund",
            @"RefundAmount": @"RefundAmount",
            @"PocketId": @"PocketId",
            @"redPocketRefundStr": @"redPocketRefundStr",
            @"CryptoActualAmount": @"CryptoActualAmount",
            @"UserAccountName": @"UserAccountName",
            @"FeeCryptoCode": @"FeeCryptoCode",
            @"TransactionTypeId" : @"TransactionTypeId",
            @"PayTypeName": @"PayTypeName",
            @"PayType": @"PayType",
            @"DetailTypeName": @"DetailTypeName",
            @"ActualCryptoAmount": @"ActualCryptoAmount",
            @"CustomerAccount": @"CustomerAccount",
            @"Reference": @"Reference",
            @"DeepLink": @"DeepLink",
            @"DecimalPlace": @"DecimalPlace",
            @"filePath":@"filePath",
            @"fileName":@"fileName",
            @"fileType":@"fileType",
            @"NickName":@"NickName",
            @"GroupReference":@"GroupReference"
    };
}

+ (NSArray *)mModelArrayWithData:(NSArray *)data {
    [FPStatementDetailOM mj_setupReplacedKeyFromPropertyName:^NSDictionary * {
        return [FPStatementDetailOM mDataReplaceDictionary];
    }];
    return [self mj_objectArrayWithKeyValuesArray:data];
}

+ (instancetype)mModelWithData:(NSDictionary *)data {
    [FPStatementDetailOM mj_setupReplacedKeyFromPropertyName:^NSDictionary * {
        return [FPStatementDetailOM mDataReplaceDictionary];
    }];
    return [self mj_objectWithKeyValues:data];
}

- (NSString *)oTime {
    if (self.Timestamp) {
        NSString *str = [NSString timespToSystemTimeZoneFormatSecond:self.Timestamp];
        return str;
    }
    return @"";
}

- (NSString *)refundOTime {
    if (self.RefundTimestamp) {
        NSString *str = [NSString timespToSystemTimeZoneFormatSecond:self.RefundTimestamp];
        return str;
    }
    return @"";
}

-(NSString*)oStatusName {
    NSString *stateName;
    switch (self.Status.intValue) {
        case 1:
            stateName = NSLocalizedString(@"order_status.pending", comment: @"");
            break;
        case 2:
            stateName = NSLocalizedString(@"order_status.complete", comment: @"");
            break;
        case 3:
            stateName = NSLocalizedString(@"order_status.cancelled", comment: @"");
            break;
        case 8:
            stateName = NSLocalizedString(@"order_status.expired", comment: @"");
            break;
        case 12:
            stateName = NSLocalizedString(@"order_status.failed", comment: @"");
            break;
        default:
            stateName = NSLocalizedString(@"order_status.unknown", comment: @"");
            break;
    }
    return stateName;
}

- (NSString *)oCreateTime {
    if (self.CreationTime) {
        NSString *str = [NSString timespToSystemTimeZoneFormatSecond:self.CreationTime];
        return str;
    }
    return @"";
}

- (NSString *)oCreationTimeStamp {
    if (self.CreationTimeStamp) {
        NSString *str = [NSString timespToSystemTimeZoneFormatSecond:self.CreationTimeStamp];
        return str;
    }
    return @"";
}

- (NSString *)oExpiredTimeStamp {
    if (self.ExpiredTimeStamp) {
        NSString *str = [NSString timespToSystemTimeZoneFormatSecond:self.ExpiredTimeStamp];
        return str;
    }
    return @"";
}

- (NSString *)oAvailableBalance {
    if (self.AvailableBalance) {
        NSString *amountStr = [DecimalUtils.shared stringInLocalisedFormatWithInput:self.AvailableBalance preferredFractionDigits:self.DecimalPlace];
        NSString *coinStr = [NSString stringWithFormat:@"%@ %@",
                             amountStr,
                             self.CoinName];
        return coinStr;
    }
    return @"";
}

- (NSString *)profitOTime {
    if (self.Timestamp) {
        NSDate *localDate = [NSDate dateWithTimeIntervalSince1970:[self.Timestamp doubleValue] / 1000.0];     //＋0000 表示的是当前时间是个世界时间。
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        NSString *str = [dateFormatter stringFromDate:localDate];
        return str;
    }
    return @"";
}

- (NSString *)redPocketRefundStr {
    if (self.HasRefund) {
        return [NSString stringWithFormat:NSLocalizedStatement(@"refund_amount"), self.RefundAmount, self.CryptoCode];
    }
    return @"";
}

- (NSString *)fromAmountStr {
    if (self.FromAmount) {
        return [NSString stringWithFormat:@"%@ %@", self.FromAmount, self.FromCryptoCode];
    }
    return @"";
}


- (NSString *)toAmountStr {
    if (self.ToAmount) {
        return [NSString stringWithFormat:@"%@ %@", self.ToAmount, self.ToCryptoCode];
    }
    return @"";
}
@end
