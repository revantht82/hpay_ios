//
//  StatementModelHelper.m
//  FiiiPay
//
//  Created by apple on 2018/4/16.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "StatementModelHelper.h"
#import "FPStatementOM.h"
#import "FPUtils.h"

@implementation StatementModelHelper

#define KMaxType StatementListTypeGPaySellCrpytoCode

#pragma mark - 获取statement list

+ (void)fetchStatementExportFromDate:(NSString *)fromDate
                          andToDate:(NSString *)toDate
                            andFormat:(NSString *)format
                         completeBlock:(void (^)(NSString *URL, NSString *filename, NSInteger errorCode, NSString *errorMessage))completBlock {
    NSString *urlStr = StatementListSingleURL;
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    
    mDict[@"export"] = format;
    mDict[@"StartDate"] = fromDate;
    mDict[@"EndDate"] = toDate;
    
    [self GET:urlStr parameters:mDict successBlock:^(NSObject *_Nullable data, NSObject *_Nullable extension, NSString *_Nullable message) {
        
        NSDictionary *dict = (NSDictionary *) data;
        NSString *filePath = dict[@"filePath"];
        NSString *fileName = [NSString stringWithFormat:@"%@.%@", dict[@"fileName"], dict[@"fileType"]];
        
        completBlock(filePath, fileName, kFPNetRequestSuccessCode, message);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        completBlock(nil, nil, code, message);
    }];
}

+ (void)fetchSOAExportFromDate:(NSString *)fromDate
                          andToDate:(NSString *)toDate
                            andFormat:(NSString *)format
                 completeBlock:(void (^)(NSString *URL, NSInteger errorCode, NSString *errorMessage))completBlock {
    NSString *urlStr = SOAExportURL;
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];

    mDict[@"FileType"] = format;
    mDict[@"FromDate"] = fromDate;
    mDict[@"ToDate"] = toDate;

    [self POST:urlStr parameters:mDict successBlock:^(NSObject *_Nullable data, NSObject *_Nullable extension, NSString *_Nullable message) {

    NSDictionary *dict = (NSDictionary *) data;
    NSString *filePath = dict[@"filePath"];

    completBlock(filePath, kFPNetRequestSuccessCode, message);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
    completBlock(nil, code, message);
    }];

}

+ (void)fetchStatementListWithPageSize:(NSInteger)PageSize
                          andPageIndex:(NSInteger)PageIndex
                          andFromDate:(NSString *)fromDate
                          andToDate:(NSString *)toDate
                         completeBlock:(void (^)(NSArray *statementList, NSInteger errorCode, NSString *errorMessage, NSInteger curPage))completBlock {
    NSString *urlStr = StatementListSingleURL;
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    mDict[@"PageSize"] = @(PageSize);
    mDict[@"PageIndex"] = @(PageIndex);
    mDict[@"MaxType"] = [NSString stringWithFormat:@"%@", @(KMaxType)];
    
    if (fromDate) {
//        NSDictionary *dateDict = [FPUtils convertMonthDateStr2UTCStrDict:fromDate toDate:toDate];
//        if (dateDict && dateDict.count > 0) {
//            mDict[@"StartDate"] = dateDict[@"StartDate"];
//            mDict[@"EndDate"] = dateDict[@"EndDate"];
//        } else {
//            //正常不走这里
//            mDict[@"Mounth"] = fromDate;
//        }
        mDict[@"StartDate"] = fromDate;
        mDict[@"EndDate"] = toDate;
    }
    
    [self GET:urlStr parameters:mDict successBlock:^(NSObject *_Nullable data, NSObject *_Nullable extension, NSString *_Nullable message) {
        NSDictionary *dict = (NSDictionary *) data;
        NSInteger page = [dict[@"CurrentPageIndex"] integerValue];
        NSArray *list = [FPStatementOM mModelArrayWithData:dict[@"List"]];
        completBlock(list, kFPNetRequestSuccessCode, message, page);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        completBlock(nil, code, message, 0);
    }];
}


#pragma mark - 获取交易详情

+ (void)fetchDetailById:(NSString *)Id withUrl:(NSString *)url andType:(NSInteger)type andExport:(NSString *)export_format completeBlock:(void (^)(FPStatementDetailOM *detailModel, NSInteger errorCode, NSString *errorMessage))completBlock {
    NSMutableDictionary *param = @{}.mutableCopy;
    if ([url isEqualToString:OrderDetailURL] || [url isEqualToString:RequestFundDetailURL] || [url isEqualToString:RequestFundRetriveURL] || [url isEqualToString:GatewayOrderOutcomeDetailURL] || [url isEqualToString:GatewayOrderIncomeDetailURL] || [url isEqualToString:CurrencySellingStatementDetailURL]) {
        param[@"OrderId"] = Id;
    } else if ([url isEqualToString:HuaZhuanDetailURL]) {
        param[@"CapitalTransferId"] = Id;
    } else {
        param[@"Id"] = Id;
    }
    
    if (export_format != nil){
        param[@"export"] = export_format;
    }
    
    [self GET:url parameters:param successBlock:^(NSObject *_Nullable data, NSObject *_Nullable extension, NSString *_Nullable message) {
        NSDictionary *dict = (NSDictionary *) data;
        //NSLog(@"%@", dict);
        FPStatementDetailOM *model = [FPStatementDetailOM mModelWithData:dict];
        completBlock(model, kFPNetRequestSuccessCode, message);
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        completBlock(nil, code, message);
    }];
}

+ (void)cancelFundRequest: (NSString *)Id withUrl:(NSString *)url completionBlock:(void (^)(NSInteger errorCode, NSString *errorMessage))completionBlock {
    NSMutableDictionary *param = @{}.mutableCopy;
    param[@"OrderId"] = Id;
    [self POST:url parameters:param successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        
        completionBlock(kFPNetRequestSuccessCode, message);
    } failureBlock:^(NSInteger code, NSString * _Nullable message) {
        
        completionBlock(code, message);
    }];
}

+ (void)approveFundRequest: (NSString *)Id withUrl:(NSString *)url completionBlock:(void (^)(NSDictionary *Dcit, NSInteger errorCode, NSString *errorMessage))completionBlock {
    NSMutableDictionary *param = @{}.mutableCopy;
    param[@"OrderId"] = Id;
    [self POST:url parameters:param successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        NSDictionary *dict = (NSDictionary *) data;
        FPStatementDetailOM *model = [FPStatementDetailOM mModelWithData:dict];

        completionBlock(dict, kFPNetRequestSuccessCode, message);
    } failureBlock:^(NSInteger code, NSString * _Nullable message) {
        
        completionBlock(nil, code, message);
    }];
}

+ (void)fetchStatementListForDownload:(NSString *)startDate andPageIndex:(NSString *)endDate andExportType:(NSString *)exportType completeBlock:(void (^__strong)(NSArray *__strong, NSInteger, NSString *__strong, NSInteger))completBlock {
}

@end
