//
//  RequestRouter.h
//  Hpay
//
//  Created by ONUR YILMAZ on 21/03/2022.
//  Copyright © 2022 Himalaya. All rights reserved.
//

#import "HPHomeBaseRouter.h"
#import "FPCountryList.h"

@class PreTransferModel;

struct TransferInfoNavigationRequest {
    PreTransferModel * _Nullable transferModel;
    NSString * _Nullable email;
    NSString * _Nullable phoneCode;
    NSString * _Nullable cellPhone;
    NSString * _Nullable countryCode;
};

@protocol RequestRouterInterface <HPHomeBaseRouterInterface>

- (void)presentContactPicker;
- (void)presentFetchPhoneCodeWithCountryList:(FPCountryList *_Nullable)countryList
                     countryDidSelectHandler:(void(^_Nonnull)(FPCountry * _Nonnull country))countryDidSelectHandler;


- (void)pushToTransferInfoWithRequest:(struct TransferInfoNavigationRequest)request;

@end

NS_ASSUME_NONNULL_BEGIN

@interface RequestRouter : HPHomeBaseRouter <RequestRouterInterface>

@property(copy, nonatomic, nullable) void (^didPhoneNumberSelected)(NSString *phoneNumber);
@property(copy, nonatomic, nullable) void (^didCountryCodeSelected)(NSString *countryCode);

@end

NS_ASSUME_NONNULL_END
