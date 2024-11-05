//
//  StatementModelHelper.h
//  FiiiPay
//
//  Created by apple on 2018/4/16.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "GLCNetworkRequest.h"
#import "FPStatementDetailOM.h"
#import "HimalayaPayAPIManager.h"

@interface StatementModelHelper : HimalayaPayAPIManager

+ (void)fetchStatementListWithPageSize:(NSInteger)PageSize
                      andPageIndex:(NSInteger)PageIndex
                         andFromDate:(NSString *)fromDate
                         andToDate:(NSString *)toDate
                         completeBlock:(void (^)(NSArray *statementList, NSInteger errorCode, NSString *errorMessage, NSInteger curPage))completBlock;

+ (void)fetchStatementListForDownload:(NSString*)startDate
                          andPageIndex:(NSString*)endDate
                             andExportType:(NSString *)exportType
                        completeBlock:(void (^)(NSArray *statementList, NSInteger errorCode, NSString *errorMessage, NSInteger curPage))completBlock;

+ (void)fetchDetailById:(NSString *)Id withUrl:(NSString *)url andType:(NSInteger)type andExport:(NSString *)export_format completeBlock:(void (^)(FPStatementDetailOM *detailModel, NSInteger errorCode, NSString *errorMessage))completBlock;

+ (void)cancelFundRequest: (NSString *)Id withUrl:(NSString *)url completionBlock:(void (^)(NSInteger errorCode, NSString *errorMessage))completionBlock;

+ (void)approveFundRequest: (NSString *)Id withUrl:(NSString *)url completionBlock:(void (^)(NSDictionary *dict, NSInteger errorCode, NSString *errorMessage))completionBlock;

+ (void) fetchStatementExportFromDate:(NSString *)fromDate andToDate:(NSString *)toDate andFormat:(NSString *)format completeBlock:(void (^)(NSString *URL, NSString *filename, NSInteger errorCode, NSString *errorMessage))completBlock;

+ (void)fetchSOAExportFromDate:(NSString *)fromDate andToDate:(NSString *)toDate andFormat:(NSString *)format completeBlock:(void (^)(NSString *URL, NSInteger errorCode, NSString *errorMessage))completBlock;

@end
