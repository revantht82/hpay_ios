//
//  TransferRouter.h
//  Hpay
//
//  Created by Olgu Sirman on 12/01/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "HPHomeBaseRouter.h"
#import "FPCountryList.h"
#import "HomeViewController.h"

@class PreTransferModel;

struct TransferInfoNavigationRequest {
    PreTransferModel * _Nullable transferModel;
    NSString * _Nullable userHash;
    NSString * _Nullable email;
    NSString * _Nullable phoneCode;
    NSString * _Nullable cellPhone;
    NSString * _Nullable countryCode;
};

@protocol TransferRouterInterface <HPHomeBaseRouterInterface>

- (void)presentContactPicker;
- (void)presentFetchPhoneCodeWithCountryList:(FPCountryList *_Nullable)countryList
                     countryDidSelectHandler:(void(^_Nonnull)(FPCountry * _Nonnull country))countryDidSelectHandler;


- (void)pushToTransferInfoWithRequest:(struct TransferInfoNavigationRequest)request;
- (void)pushToChooseCoinTransfer:(NSDictionary*_Nullable)request;
- (void)pushToChooseCoinTransferNew:(NSArray*_Nullable)receivers;
@end

NS_ASSUME_NONNULL_BEGIN

@interface TransferRouter : HPHomeBaseRouter <TransferRouterInterface>

@property(copy, nonatomic, nullable) void (^didPhoneNumberSelected)(NSString *phoneNumber);
@property(copy, nonatomic, nullable) void (^didCountryCodeSelected)(NSString *countryCode);

@end

NS_ASSUME_NONNULL_END
