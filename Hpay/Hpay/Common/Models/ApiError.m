//
//  ApiError.m
//  Hpay
//
//  Created by Ugur Bozkurt on 29/07/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "ApiError.h"
#import "NSString+Extension.h"

@interface ApiError ()
@property(nonatomic) NSInteger code;
@property(nonatomic) NSString *message;
@end

@implementation ApiError

- (instancetype)initWithCode:(NSInteger)code message:(NSString *)message
{
    self = [super init];
    if (self) {
        _code = code;
        _message = message;
    }
    return self;
}

+ (instancetype)errorWithCode:(NSInteger)code message:(NSString *)message{
    return [[ApiError alloc] initWithCode:code message:message];
}

- (NSString *)prettyTitle{
    switch (_code) {
        case kFPNetWorkErrorCode:
            return [NSLocalizedString(@"pay_merchant_refresh.network_error.title_label", @"") singleLine];
        case kFPUnknownErrorCode:
            return NSLocalizedString(@"pay_merchant_refresh.backend_error.title_label", @"");
        default:
            return @"";
    }
}

- (NSString *)prettyMessage{
    switch (_code) {
        case kFPNetWorkErrorCode:
            return [NSLocalizedString(@"pay_merchant_refresh.network_error.description_label", @"") singleLine];
        case kErrorCodeFirstSetPinAlreadySet:
            return NSLocalizedString(@"set_pin_error", @"");
        case kErrorCodeVerifyPinCheck:
            return NSLocalizedString(@"verify_pin_error", @"");
        case kErrorCodeResetPinCodeMatch:
            return NSLocalizedString(@"reset_pin_code_match_error", @"");
        case kErrorCodeResetPinCodeExpired:
            return NSLocalizedString(@"reset_pin_code_expired_error", @"");
        case kErrorCodeReceiverAccountSuspended:
            return NSLocalizedString(@"receiver_account_suspended_message", @"");
        case kErrorCodeUserAccountSuspended:
            return NSLocalizedString(@"user_account_suspended_message", @"");
        case kErrorCodeReceiverAccountNotValid:
            return NSLocalizedString(@"RECEIVER_ACCOUNT_NOT_VALID", @"");
        case kErrorCodeReceiverUserCountryNotAllowedHPay:
            return NSLocalizedString(@"RECEIVER_USERCOUNTRY_NOT_ALLOWED_HPAY", @"");
        case kErrorCodeTransferToSelf:
            return NSLocalizedString(@"TRANSFER_TO_SELF", @"Attempt to send to self");
        case kErrorCodeSenderUserCountryNotAllowedHPay:
            return NSLocalizedString(@"SENDER_USERCOUNTRY_NOT_ALLOWED_HPAY", @"");
        case kErrorCodeInvalidCellPhone:
            return NSLocalizedString(@"INVALID_CELLPHONE", @"");
        case kFPUserNotExistCode:
            return NSLocalizedString(@"ACCOUNT_NOT_EXISTS", @"");
        case kErrorCodeSenderAccountIsNotValid:
            return NSLocalizedString(@"SENDER_ACCOUNT_NOT_VALID", @"");
        case kErrorCodeInvalidCoin:
            return NSLocalizedString(@"INVALID_COIN", @"");
        case kErrorCodeDecimalPointFormatError:
            return NSLocalizedString(@"DECIMAL_POINT_FORMAT_ERROR", @"");
        case kErrorCodeUserWalletDoesNotExist:
            return NSLocalizedString(@"USER_WALLET_NOTEXISTS", @"");
        case kErrorCodeInputAmountFlowLimit:
            return NSLocalizedString(@"INPUT_AMOUNT_FLOW_LIMIT", @"");
        case kErrorCodeInvalidKYCReceiver:
            return NSLocalizedString(@"invalid_kyc_receiver", @"");
        case kErrorCodeInvalidKYC:
            return NSLocalizedString(@"home.kycIsNotVerified.alertText", @"");
        case kFPUnknownErrorCode:
        case kFPNetRequestServerErrorCode:
            return NSLocalizedCommon(@"unexpected_error");
        case kErrorCodeMarketPriceNotAvailable:
            return NSLocalizedCommon(@"hcn_market_price_is_not_available");
        case kErrorCodeMaxPinAttemptExceeded:
            return NSLocalizedCommon(@"pin_attempt_exceeded");
        case kErrorCodeAMOUNT_EXCEEDS_MAX_LIMIT:
            return NSLocalizedString(@"group_send_amount_exceeded", @"");
        case kErrorCodeNOTES_VALUE_TOO_LONG:
            return NSLocalizedString(@"group_send_notes_value_too_long", @"");
        default:
            if (!_message || [_message isEqualToString:@""]) return NSLocalizedCommon(@"unexpected_error");
            else return _message;
    }
}

- (NSString *)prettyMerchantCreateErrorTitle{
    switch (_code) {
        case kErrorCodePaymentCompleted:
            return NSLocalizedString(@"pay_merchant.pay_failed_alert.reason_completed.title", @"");
        case kErrorCodePaymentCancelled:
        case kErrorCodePaymentInsufficientBalance:
        case kErrorCodePaymentExpired:
            return NSLocalizedString(@"payment_failed", @"");
        default:
            return @"";
    }
}

- (NSString *)prettyMerchantCreateErrorMessage{
    switch (_code) {
        case kErrorCodePaymentExpired:
            return NSLocalizedString(@"pay_merchant.pay_failed_alert.reason_expired.message", @"Payment failed due to expiration alert message on Pay Merchant screen");
        case kErrorCodePaymentCompleted:
            return NSLocalizedString(@"pay_merchant.pay_failed_alert.reason_completed.message", @"Payment failed due to being already completed alert message on Pay Merchant screen");
        case kErrorCodePaymentCancelled:
            return NSLocalizedString(@"pay_merchant.pay_failed_alert.reason_cancelled.message", @"Payment failed due to being cancelled alert message on Pay Merchant screen");
        case kErrorCodePaymentInsufficientBalance:
            return NSLocalizedString(@"pay_merchant.pay_failed_alert.reason_insufficient_balance.message", @"Payment failed due to not having sufficient balance alert message on Pay Merchant screen");
        default:
            return [self prettyMessage];
    }
}

- (NSString *)prettyMerchantCancelErrorTitle{
    switch (_code) {
        case kErrorCodePaymentCancelled:
            return NSLocalizedString(@"pay_merchant.cancel_successful_alert.title", @"");
        case kErrorCodePaymentExpired:
            return NSLocalizedString(@"pay_merchant.cancel_failed_alert.reason_expired.title", @"Cancel failed because payment expired alert title on Pay Merchant screen");
        case kErrorCodePaymentCompleted:
            return NSLocalizedString(@"pay_merchant.cancel_failed_alert.reason_completed.title", @"Cancel failed because payment completed alert title on Pay Merchant screen");
        case kErrorCodeUserAccountSuspended:
            return @"";
        default:
            return NSLocalizedString(@"pay_merchant.cancel_failed_alert.reason_unknown.title", @"Cancel failed alert title on Pay Merchant screen");
    }
}

- (NSString *)prettyMerchantCancelErrorMessage{
    switch (_code) {
        case kErrorCodePaymentCancelled:
            return NSLocalizedString(@"pay_merchant.cancel_successful_alert.message", @"");
        case kErrorCodePaymentExpired:
            return NSLocalizedString(@"pay_merchant.cancel_failed_alert.reason_expired.message", @"Cancel failed because payment expired alert message on Pay Merchant screen");
        case kErrorCodePaymentCompleted:
            return NSLocalizedString(@"pay_merchant.cancel_failed_alert.reason_completed.message", @"Cancel failed because payment completed alert message on Pay Merchant screen");
        default:
            return [self prettyMessage];
    }
}

@end
