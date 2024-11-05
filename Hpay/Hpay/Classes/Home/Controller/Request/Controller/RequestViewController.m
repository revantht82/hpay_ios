//
//  requestViewController.m
//  Hpay
//
//  Created by ONUR YILMAZ on 21/03/2022.
//  Copyright © 2022 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestViewController.h"
#import "UIButton+ImageTitleSpacing.h"
#import "LoginHelperModel.h"
#import "HomeHelperModel.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "NSString+Regular.h"
#import "HPTextField.h"
#import "RequestRouter.h"
#import "FBCoin.h"
#import "HCToolBar.h"
#import "ApiError.h"

@interface RequestViewController ()
@property(weak, nonatomic) IBOutlet UIView *inputContainerView;
@property(weak, nonatomic) IBOutlet UIButton *phoneCodeBtn;
@property(weak, nonatomic) IBOutlet HPTextField *accountTF;
@property(weak, nonatomic) IBOutlet UIButton *nextBtn;
@property(weak, nonatomic) IBOutlet UILabel *sendToLabel;
@property(weak, nonatomic) IBOutlet UIButton *mobileBtn;
@property(weak, nonatomic) IBOutlet UIButton *emailBtn;
@property(weak, nonatomic) IBOutlet UIButton *contactsBtn;
@property(weak, nonatomic) IBOutlet UIView *mobileView;
@property(weak, nonatomic) IBOutlet UIView *emailView;
@property(weak, nonatomic) IBOutlet HPTextField *emailTf;
@property(weak, nonatomic) IBOutlet UILabel *placeTips;//Prompt statement
@property(weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property(weak, nonatomic) IBOutlet UIView *divider;

@property(copy, nonatomic) FPCountryList *countryList;
@property(assign, nonatomic) NSString *countryPhoneCode;
@property(strong, nonatomic) HCToolBar *toolBar;
@property(strong, nonatomic) RequestRouter<RequestRouterInterface> *router;

@property(nonatomic) BOOL isViewDidAppear;

@end

@implementation RequestViewController

- (RequestRouter<RequestRouterInterface> *)router {
    if (_router == nil) {
        _router = [[RequestRouter alloc] init];
        _router.currentControllerDelegate = self;
        _router.navigationDelegate = self.navigationController;
        _router.tabBarControllerDelegate = self.tabBarController;
    }
    return _router;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self checkStatus];
    [self.scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)]];
    [self configureCountrySelections];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.isViewDidAppear = YES;
    [self focusOnAccountField];
}

- (BOOL)canShowKeyboard {
    return self.isViewDidAppear && self.countryList;
}

- (void)focusOnAccountField{
    if ([self canShowKeyboard]) {
        [self.accountTF becomeFirstResponder];
    }
}

- (void)configureCountrySelections {
    MJWeakSelf
    void (^handleDidCountryCodeSelected)(NSString * _Nonnull countryCode) = ^(NSString * _Nonnull countryCode) {
        [weakSelf handleCountrySelectionFromContactPicker:countryCode];
    };
    
    void (^handleDidPhoneNumberSelected)(NSString *_Nonnull phoneNumber) = ^(NSString * _Nonnull phoneNumber) {
        [weakSelf handlePhoneNumberSelection:phoneNumber];
    };
    [self.router setDidCountryCodeSelected:handleDidCountryCodeSelected];
    [self.router setDidPhoneNumberSelected:handleDidPhoneNumberSelected];
}

- (void)initUI {
    [self configureViewStateHandlingWithAlignment:kAlignmentFull height:NULL];
    self.fd_prefersNavigationBarHidden = NO;

    if (self.coinModel) {
        self.navigationItem.title = [NSString stringWithFormat:NSLocalizedDefault(@"transferTitle"), self.coinModel.Code];
    }
    
    [self.nextBtn setTitle:self.nextBtn.titleLabel.text.localizedUppercaseString forState:UIControlStateNormal];
    self.nextBtn.alpha = 0.5;
    self.accountTF.maxNumber = 20;
    self.emailTf.maxNumber = 60;
    self.accountTF.inputAccessoryView = self.toolBar;
    self.emailTf.inputAccessoryView = self.toolBar;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kLastLoginCountryModel]) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kLastLoginCountryModel];
        FPCountry *country = [NSKeyedUnarchiver unarchivedObjectOfClass:[FPCountry class] fromData:data error:NULL];
        if (country && country.PhoneCode) {
            self.countryPhoneCode = country.PhoneCode;
            [self.phoneCodeBtn setTitle:country.PhoneCode forState:UIControlStateNormal];
            [self.phoneCodeBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
        } else {
            [self.phoneCodeBtn setTitle:@"" forState:UIControlStateNormal];
        }
    }
    
    self.emailTf.placeholder = NSLocalizedDefault(@"email_field_placeholder");
    
    [self applyTheme];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self applyTheme];
}

- (void)applyTheme{
    id<ThemeProtocol> theme = [self getCurrentTheme];
    [_mobileBtn setTitleColor:theme.secondaryOnSurface forState:UIControlStateNormal];
    [_mobileBtn setTitleColor:theme.primaryOnSurface forState:UIControlStateSelected];
    [_emailBtn setTitleColor:theme.secondaryOnSurface forState:UIControlStateNormal];
    [_emailBtn setTitleColor:theme.primaryOnSurface forState:UIControlStateSelected];
    _contactsBtn.tintColor = theme.primaryOnSurface;
    _sendToLabel.textColor = theme.primaryOnSurface;
    self.inputContainerView.backgroundColor = theme.surface;
    self.view.backgroundColor = theme.background;
    self.scrollView.backgroundColor = theme.background;
    _phoneCodeBtn.backgroundColor = theme.background;
    [_phoneCodeBtn setTitleColor:theme.primaryOnBackground forState:UIControlStateNormal];
    _phoneCodeBtn.tintColor = theme.primaryOnBackground;
    _phoneCodeBtn.borderColor = theme.controlBorder;
    _nextBtn.backgroundColor = theme.primaryButton;
    _divider.backgroundColor = theme.primaryOnBackground;
}

- (void)checkStatus{
    [self showLoadingState];
    [HomeHelperModel checkTransferAbleCompletBlock:^(NSInteger errorCode, BOOL transferAble, NSString *message) {
        if (errorCode == kFPNetRequestSuccessCode) {
            if (transferAble) {
                [self loadCountryList:NO];
            } else {
                [self banTransferAlert];
            }
        }else{
            [self handleErrorWithErrorCode:errorCode message:message];
        }
    }];
}

- (void)banTransferAlert {
    AlertActionItem *cancelItem = [AlertActionItem defaultCancelItemWithHandler:^{
        [self.router popToRoot];
    }];
    
    AlertActionItem *contactItem = [AlertActionItem actionWithTitle:NSLocalizedCommon(@"contact") style:(AlertActionStyleDefault) handler:^{
        [self.router presentHelpFeedback];
    }];
    
    [self showAlertWithTitle:@""
                     message:NSLocalizedString(@"transfer.countryCodeIsNotSelectedWarning", @"")
                     actions:[NSArray arrayWithObjects:cancelItem, contactItem, nil]];
}

- (void)loadCountryList:(BOOL)show {
    if (show) {
        [MBHUD showInView:self.view withDetailTitle:nil withType:HUDTypeLoading];
    }
    [LoginHelperModel fetchCountryListCompleteBlock:^(FPCountryList *countryList, NSInteger errorCode, NSString *errorMessage) {
        [MBHUD hideInView:self.view];
        if (errorCode == kFPNetRequestSuccessCode && countryList && countryList.List.count > 0) {
            [self hideStatefulViewController];
            self.countryList = countryList;
            [self focusOnAccountField];
        } else if (self.countryList.List.count > 0){
            [MBHUD showInView:self.view withDetailTitle:errorMessage withType:HUDTypeError];
        }else{
            [self handleErrorWithErrorCode:errorCode message:errorMessage];
        }
    }];
}

- (void)handleErrorWithErrorCode:(NSInteger)code message:(NSString *)message{
    switch (code) {
        case kFPNetWorkErrorCode:{
            [self showNetworkErrorWithPrimaryButtonTitle:StateViewModel.retryButtonTitle
                                    secondaryButtonTitle:NULL
                                     didTapPrimaryButton:^(id  _Nonnull sender) {
                [self didTapRefresh:sender];
            } didTapSecondaryButton:NULL];
            break;
        }
        default:{
            [self showGenericApiErrorWithPrimaryButtonTitle:StateViewModel.retryButtonTitle
                                       secondaryButtonTitle:NULL didTapPrimaryButton:^(id  _Nonnull sender) {
                [self didTapRefresh:sender];
            } didTapSecondaryButton:NULL];
            break;
        }
    }
}

#pragma mark - TextFieldValueChange

- (IBAction)textFieldValueChange:(id)sender {
    if (self.mobileBtn.selected) {
        self.nextBtn.selected = self.nextBtn.userInteractionEnabled = self.accountTF.text.length >= 3 ? YES : NO;
        [self.nextBtn configureBackgroundColorFor:self.accountTF.text.length >= 3];
    } else {
        self.nextBtn.selected = self.nextBtn.userInteractionEnabled = [NSString verifyEmail:self.emailTf.text] ? YES : NO;
        [self.nextBtn configureBackgroundColorFor:[NSString verifyEmail:self.emailTf.text]];
    }
}

#pragma mark - Actions

- (IBAction)mobileClick:(id)sender {
    self.mobileBtn.selected = YES;
    self.emailBtn.selected = NO;
    self.mobileView.hidden = NO;
    self.emailView.hidden = YES;
    self.phoneCodeBtn.hidden = NO;
    self.accountTF.text = @"";
    self.emailTf.text = @"";
    self.nextBtn.selected = NO;
    self.nextBtn.userInteractionEnabled = NO;
    [self.accountTF becomeFirstResponder];
    
    self.placeTips.text = NSLocalizedDefault(@"send_via_phone_hint");
}

- (IBAction)emailClick:(id)sender {
    self.mobileBtn.selected = NO;
    self.emailBtn.selected = YES;
    self.mobileView.hidden = YES;
    self.emailView.hidden = NO;
    self.phoneCodeBtn.hidden = YES;
    self.accountTF.text = @"";
    self.emailTf.text = @"";
    self.nextBtn.selected = NO;
    self.nextBtn.userInteractionEnabled = NO;
    [self.emailTf becomeFirstResponder];
    self.placeTips.text = NSLocalizedDefault(@"send_via_email_hint");
}

#pragma mark - Select the country code

- (IBAction)selectPhoneCode:(id)sender {
    [self hideKeyboard];
    if (self.countryList && self.countryList.List.count > 0) {
        MJWeakSelf
        [self.router presentFetchPhoneCodeWithCountryList:self.countryList countryDidSelectHandler:^(FPCountry *country) {
            [weakSelf handleCountrySelectionWith:country];
        }];
    } else {
        [self loadCountryList:YES];
    }
}

- (void)handleCountrySelectionWith:(FPCountry *)country {
    self.countryPhoneCode = country.PhoneCode;
    [self.phoneCodeBtn setTitle:[NSString stringWithFormat:@"%@", country.PhoneCode] forState:UIControlStateNormal];
    [self.phoneCodeBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
}

#pragma mark - The address book

- (IBAction)contactAction:(id)sender {
    [self.router presentContactPicker];
}

#pragma mark - Next

- (IBAction)nextAction:(id)sender {
    if (self.mobileBtn.selected) {
        
        if (!self.countryPhoneCode) {
            AlertActionItem *okItem = [AlertActionItem defaultOKItem];
            
            [self showAlertWithTitle:@""
                             message:NSLocalizedString(@"transfer.countryCodeIsNotSelectedWarning", @"")
                             actions:[NSArray arrayWithObject:okItem]];
            return;
        }
        
        if (self.countryPhoneCode && self.coinModel && self.coinModel.Id && self.accountTF.text.length > 0) {
            [MBHUD showInView:self.view withDetailTitle:nil withType:HUDTypeLoading];
            [HomeHelperModel preTransfer:self.coinModel.Id toCountryId:self.countryPhoneCode toCellphone:self.accountTF.text email:nil completBlock:^(NSInteger errorCode, NSString *message, PreTransferModel *transferModel) {
                [MBHUD hideInView:self.view];
                
                if (errorCode == kFPNetRequestSuccessCode) {
                    struct TransferInfoNavigationRequest request;
                    request.transferModel = transferModel;
                    request.phoneCode = self.phoneCodeBtn.titleLabel.text;
                    request.cellPhone = self.accountTF.text;
                    request.countryCode = self.countryPhoneCode;
                    [self.router pushToTransferInfoWithRequest:request];
                } else {
                    [self handlePreTransferError:errorCode remoteMessage:message];
                }
            }];
        }
    } else {
        [MBHUD showInView:self.view withDetailTitle:nil withType:HUDTypeLoading];
        [HomeHelperModel preTransfer:self.coinModel.Id toCountryId:self.countryPhoneCode toCellphone:nil email:self.emailTf.text completBlock:^(NSInteger errorCode, NSString *message, PreTransferModel *transferModel) {
            [MBHUD hideInView:self.view];
            
            if (errorCode == kFPNetRequestSuccessCode) {
                struct TransferInfoNavigationRequest request;
                request.transferModel = transferModel;
                request.email = self.emailTf.text;
                [self.router pushToTransferInfoWithRequest:request];
            } else {
                [self handlePreTransferError:errorCode remoteMessage:message];
            }
        }];
    }
}

- (void)handlePreTransferError:(NSInteger)errorCode remoteMessage:(NSString *)remoteMessage {
    switch (errorCode) {
        case kFPNetWorkErrorCode:{
            [self showAlertForConnectionFailure];
            break;
        }
        case kErrorCodeMarketPriceNotAvailable:{
            [self.tabBarController showAlertForMarketPriceNotAvailable];
            break;
        }
        case kErrorCodeMerchantRestricted: {
            [self.tabBarController showAlertForMerchantRestricted];
            break;
        }
        case kErrorCodeRestrictedCountry: {
            [self.tabBarController showAlertForAccountRestrictedCoutry];
            break;
        }
        case kErrorCodeAccountRestrictedToRecieve: {
            [self.tabBarController showAlertForRestrictedToRecieve];
            break;
        }
        case kErrorCodeReciverAccountInRestrictedCoutry: {
            [self.tabBarController showAlertForRecieverInRestrictedCoutry];
            break;
        }
            
        case kErrorCodeUserAccountSuspended: {
            [self.tabBarController showAlertForAccountSuspended];
            break;
        }
            
        default:{
            ApiError *error = [ApiError errorWithCode:errorCode message:remoteMessage];
            [MBHUD showInView:self.view withDetailTitle:error.prettyMessage withType:HUDTypeError];
            break;
        }
    }
}

- (void)handleCountrySelectionFromContactPicker:(NSString *)countryCode {
    if (self.countryList.List.count > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"PhoneCode = %@", countryCode];
        NSArray *filteredArray = [self.countryList.List filteredArrayUsingPredicate:predicate];
        if (filteredArray.count > 0) {
            FPCountry *country = [filteredArray firstObject];
            [self handleCountrySelectionWith:country];
        }
    }
}

- (void)handlePhoneNumberSelection:(NSString *)phoneNumber {
    self.accountTF.text = [NSString stringWithFormat:@"%@", phoneNumber];
    self.nextBtn.selected = self.nextBtn.userInteractionEnabled = YES;
    [self.nextBtn configureBackgroundColorFor:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideKeyboard];
}

- (HCToolBar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[HCToolBar alloc] init];
        MJWeakSelf
        [_toolBar setDidToolBarDoneSelected:^{
            [weakSelf hideKeyboard];
        }];
    }
    return _toolBar;
}

#pragma mark -StatefulViewController actions

- (void)didTapRefresh:(id)sender{
    [self checkStatus];
}

@end
