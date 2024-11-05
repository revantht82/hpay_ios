//
//  RequestRouter.m
//  Hpay
//
//  Created by ONUR YILMAZ on 21/03/2022.
//  Copyright © 2022 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestRouter.h"
#import "FetchPhoneCodeViewController.h"
#import <ContactsUI/ContactsUI.h>
#import "TransferInfoViewController.h"


@interface RequestRouter () <CNContactPickerDelegate>

@end

@implementation RequestRouter

- (FetchPhoneCodeViewController *)fetchPhoneCodeViewController {
    FetchPhoneCodeViewController *vc = [SB_HOME instantiateViewControllerWithIdentifier:[FetchPhoneCodeViewController className]];
    return vc;
}

- (TransferInfoViewController *)transferInfoViewController {
    TransferInfoViewController *vc = [SB_HOME instantiateViewControllerWithIdentifier:[TransferInfoViewController className]];
    return vc;
}

- (void)presentFetchPhoneCodeWithCountryList:(FPCountryList *)countryList
                     countryDidSelectHandler:(void(^)(FPCountry *country))countryDidSelectHandler {
    
    FetchPhoneCodeViewController *vc = self.fetchPhoneCodeViewController;
    vc.countryList = countryList;
    [vc setClickBlock:countryDidSelectHandler];
    [self pushTo:vc];
}

- (void)presentContactPicker {
    
    CNContactPickerViewController *pickerVC = [[CNContactPickerViewController alloc] init];
    pickerVC.displayedPropertyKeys = @[CNContactPhoneNumbersKey];
    NSPredicate *pickerPredicate = [NSPredicate predicateWithFormat:@"(phoneNumbers.@count > 0)"];
    pickerVC.predicateForEnablingContact = pickerPredicate;
    pickerVC.predicateForSelectionOfContact = pickerPredicate;
    pickerVC.predicateForSelectionOfProperty = pickerPredicate;
    pickerVC.delegate = self;
    [self present:pickerVC];
}

- (void)pushToTransferInfoWithRequest:(struct TransferInfoNavigationRequest)request {
    
    TransferInfoViewController *vc = self.transferInfoViewController;
    vc.transferModel = request.transferModel;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"phoneCode"] = request.phoneCode;
    dict[@"cellPhone"] = request.cellPhone;
    dict[@"countryId"] = [NSString stringWithFormat:@"%ld", (long) request.countryCode];
    dict[@"email"] = request.email;
    vc.infoDict = dict;
    [self pushTo:vc];
}

#pragma mark - CNContactPickerDelegate

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
        
    if ([contactProperty.key isEqualToString:CNContactPhoneNumbersKey]) {
        [self configurePhoneNumberSelectionWithContactProperty:contactProperty];
    }
}

- (void)configurePhoneNumberSelectionWithContactProperty:(CNContactProperty *)contactProperty {
    CNPhoneNumber *phoneNum = contactProperty.value;
    NSString *phoneStr = phoneNum.stringValue;
    phoneStr = [phoneStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *countryCode = nil;
    NSString *separator = @"%20";
    if (iOSVersion < 12.0f) {
        separator = @"%C2%A0";
    }
    if ([phoneStr hasPrefix:@"+"]) {
        NSMutableArray *array = [[phoneStr componentsSeparatedByString:separator] mutableCopy];
        countryCode = [array.firstObject copy];
        phoneStr = [phoneStr stringByReplacingOccurrencesOfString:countryCode withString:@""];
        phoneStr = [phoneStr stringByReplacingOccurrencesOfString:separator withString:@""];
    } else if ([phoneStr hasPrefix:@"00 "]) {
        NSMutableArray *array = [[phoneStr componentsSeparatedByString:separator] mutableCopy];
        if (array.count > 1) {
            if (array.count > 2) {
                countryCode = [NSString stringWithFormat:@"+%@", array[1]];
                NSMutableString *phoneMutableString = [[NSMutableString alloc] init];
                for (NSInteger i = 2; i < array.count; i++) {
                    [phoneMutableString appendString:array[i]];
                }
                phoneStr = phoneMutableString;
            } else {
                phoneStr = array.lastObject;
            }
        }
    }
    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:separator withString:@""];
    
    if (phoneStr && phoneStr.length > 0) {
        phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        if (self.didPhoneNumberSelected) {
            self.didPhoneNumberSelected(phoneStr);
        }
    }
    
    if (countryCode && countryCode.length > 0) {
        if (self.didCountryCodeSelected) {
            self.didCountryCodeSelected(countryCode);
        }
    }
}

- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker {
    
}

@end
