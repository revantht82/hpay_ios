//
//  TransferViewController.m
//  FiiiPay
//
//  Created by Mac on 2018/6/8.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "TransferViewController.h"
#import "UIButton+ImageTitleSpacing.h"
#import "LoginHelperModel.h"
#import "HomeHelperModel.h"
//#import "TPKeyboardAvoidingScrollView.h"
#import "NSString+Regular.h"
#import "HPTextField.h"
#import "TransferRouter.h"
#import "FBCoin.h"
#import "HCToolBar.h"
#import "ApiError.h"
#import "AVUtils.h"
#import "NSString+URL.h"
#import "HomeViewController.h"
#import "ReceiverListViewCell.h"
#import "ReceiverListFooterView.h"
#import "ReceiverListHeaderView.h"
#import "UserConfigResponse.h"
#import "HimalayaAuthKeychainManager.h"

@interface TransferViewController () <UITableViewDataSource, UITableViewDelegate>
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
//@property(weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property(weak, nonatomic) IBOutlet UIView *divider;
@property (weak, nonatomic) IBOutlet UITableView *receiversTable;

@property(copy, nonatomic) FPCountryList *countryList;
@property(assign, nonatomic) NSString *countryPhoneCode;
@property(strong, nonatomic) HCToolBar *toolBar;
@property(strong, nonatomic) TransferRouter<TransferRouterInterface> *router;

@property(nonatomic) BOOL isViewDidAppear;
@property(nonatomic) BOOL isAddMore;
@property(nonatomic) BOOL lockedAddRemove;
@property(strong, nonatomic) NSMutableArray *fundsReceiversList;
@property(strong, nonatomic) NSNumber *SendToGroupThreshold;

@end

@implementation TransferViewController

- (TransferRouter<TransferRouterInterface> *)router {
    if (_router == nil) {
        _router = [[TransferRouter alloc] init];
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
    [self.receiversTable addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)]];
    [self configureCountrySelections];
    self.fundsReceiversList = [[NSMutableArray alloc] init];
    self.lockedAddRemove = FALSE;
    
    NSError *error;
    UserConfigResponse *userConfig = [HimalayaAuthKeychainManager loadUserConfigToKeychain:&error];
    if (!error && userConfig.SendToGroupThreshold && [userConfig.SendToGroupThreshold intValue] > 0 ) {
        self.SendToGroupThreshold = userConfig.SendToGroupThreshold;
    } else {
        self.SendToGroupThreshold = @1;
    }
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.userHash) {
        [self showLoadingState];
        [self nextAction:nil];
    }
    
    [self.receiversTable reloadData];
    self.lockedAddRemove = FALSE;
    self.isAddMore = FALSE;
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
    else {
        self.navigationItem.title = [NSString stringWithFormat:NSLocalizedDefault(@"transferTitle"), @""];
    }
    
    //[self.nextBtn setTitle:@"Add receiver" forState:UIControlStateNormal];
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
    
    UIButton *rightExportButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [rightExportButton.widthAnchor constraintEqualToConstant:25].active = YES;
    [rightExportButton.heightAnchor constraintEqualToConstant:25].active = YES;
    
    [rightExportButton addTarget:self action:@selector(qrButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [rightExportButton setImage:[UIImage imageNamed:@"qr-code-scan-icon"] forState:UIControlStateNormal];
    UIBarButtonItem * rightButtonItem =[[UIBarButtonItem alloc] initWithCustomView:rightExportButton];
    [self.navigationItem setRightBarButtonItem:rightButtonItem animated:YES];
    self.navigationItem.rightBarButtonItems = @[rightButtonItem];
    
    //[_placeTips removeFromSuperview];
    
    _receiversTable.delegate = self;
    _receiversTable.dataSource = self;
    
    [_receiversTable registerNib:[UINib nibWithNibName:@"ReceiverListViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ReceiverListViewCellId"];
    
    [_receiversTable registerNib:[UINib nibWithNibName:@"ReceiverListFooterView" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"ReceiverListFooterViewId"];
    [_receiversTable registerNib:[UINib nibWithNibName:@"ReceiverListHeaderView" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"ReceiverListHeaderViewID"];
    
    ReceiverListHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"ReceiverListHeaderView" owner:nil options:nil].lastObject;
    _placeTips = headerView.placeTips;
    _receiversTable.tableFooterView = headerView;
    
    [self applyTheme];
}

-(void)addMoreBtnPressed{
    if (self.lockedAddRemove) return;
    
    if (self.fundsReceiversList.count >= [self.SendToGroupThreshold intValue]) {
        AlertActionItem *cancelItem = [AlertActionItem defaultOKItem];
        
        [self showAlertWithTitle:NSLocalizedString(@"transfer.send_to_group.group_limit_reached.title", nil)
                         message:[NSString stringWithFormat: NSLocalizedString(@"transfer.send_to_group.group_limit_reached.desc", nil), self.SendToGroupThreshold]
                         actions:[NSArray arrayWithObjects:cancelItem, nil]];
        return;
    }
    
    
    self.lockedAddRemove = TRUE;
    
    _isAddMore = TRUE;
    [self nextAction:nil];
}

- (void) qrButtonPressed{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[HomeViewController class]]) {
            [(HomeViewController*)controller openQRScanner];
            break;
        }
    }
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
    self.receiversTable.backgroundColor = theme.background;
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
    //[self.nextBtn setTitle:@"Add receiver" forState:UIControlStateNormal];
    //_isAddMore = TRUE;
    
    if (_fundsReceiversList.count > 0) {
        self.nextBtn.selected = self.nextBtn.userInteractionEnabled = YES;
        [self.nextBtn configureBackgroundColorFor:YES];
        return;
    }
    
    if (self.mobileBtn.selected) {
        self.nextBtn.selected = self.nextBtn.userInteractionEnabled = self.accountTF.text.length >= 3 ? YES : NO;
        [self.nextBtn configureBackgroundColorFor:self.accountTF.text.length >= 3];
        
        if (self.accountTF.text.length == 0 && self.fundsReceiversList.count > 0){
            self.nextBtn.selected = self.nextBtn.userInteractionEnabled = YES;
            [self.nextBtn configureBackgroundColorFor:YES];
            
            //[self.nextBtn setTitle:@"Select coin to send" forState:UIControlStateNormal];
            //_isAddMore = FALSE;
        }
        
    } else {
        self.nextBtn.selected = self.nextBtn.userInteractionEnabled = [NSString verifyEmail:self.emailTf.text] ? YES : NO;
        [self.nextBtn configureBackgroundColorFor:[NSString verifyEmail:self.emailTf.text]];
        
        if (self.emailTf.text.length == 0 && self.fundsReceiversList.count > 0){
            self.nextBtn.selected = self.nextBtn.userInteractionEnabled = YES;
            [self.nextBtn configureBackgroundColorFor:YES];
            
            //[self.nextBtn setTitle:@"Select coin to send" forState:UIControlStateNormal];
            //_isAddMore = FALSE;
        }
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
    
    #if TARGET_IPHONE_SIMULATOR
    self.accountTF.text = @"7393442303";
    FPCountry *country = [[FPCountry alloc] init];
    country.Name = @"United Kingdom";
    country.PhoneCode = @"+44";
    country.Name = @"ying guo";
    [self handleCountrySelectionWith:country];
    #endif
    
    [self textFieldValueChange:nil];
    
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
    
    #if TARGET_IPHONE_SIMULATOR
    int r = arc4random_uniform(3);
    if (r==0) self.emailTf.text = @"gkextst+01@gmail.com";
    else if (r==1) self.emailTf.text = @"tradingbuy1@gmail.com";
    else self.emailTf.text = @"hpaystaging.test@gmail.com";
    #endif
    
    [self textFieldValueChange:nil];
}

-(void) removeButtonPressed:(UIButton*)sender {
    if (self.lockedAddRemove) return;
    self.lockedAddRemove = TRUE;
    //[self.receiversTable beginUpdates];
    //[self.receiversTable insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    //[self.receiversTable deleteRowsAtIndexPaths:[[NSArray alloc] initWithObjects:, nil] withRowAnimation:UITableViewRowAnimationRight];
    //[self.receiversTable reloadData];
    //[self.receiversTable endUpdates];
    
    [self.fundsReceiversList removeObjectAtIndex:sender.tag];
    
    [self.receiversTable performBatchUpdates:^{
        [self.receiversTable deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    } completion:^(BOOL finished){
        if( finished){
            [self.receiversTable reloadData];
            self.lockedAddRemove = FALSE;
            if (self.fundsReceiversList.count > 0) {
                [self.nextBtn configureBackgroundColorFor:YES];
            }
            else {
                [self.nextBtn configureBackgroundColorFor:NO];
            }
        }
    }];
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
    if (!self.isAddMore && self.fundsReceiversList.count > 0) {
        [self.router pushToChooseCoinTransferNew:self.fundsReceiversList];
        return;
    }
        
    if (self.userHash) {
        [MBHUD showInView:self.view withDetailTitle:nil withType:HUDTypeLoading];
        [HomeHelperModel preTransfer:self.coinModel.Id toUserHash:self.userHash completBlock:^(NSInteger errorCode, NSString *message, PreTransferModel *transferModel) {
            [MBHUD hideInView:self.view];
            
            if (errorCode == kFPNetRequestSuccessCode) {
                struct TransferInfoNavigationRequest request;
                request.transferModel = transferModel;
                request.transferModel.CoinId = self.coinModel.Id;
                request.transferModel.CoinCode = self.coinModel.Code;
                request.transferModel.CoinDecimalPlace = self.coinModel.DecimalPlace;
                request.transferModel.MinCount = self.coinModel.minAmount;
                request.transferModel.CoinBalance = self.coinModel.UseableBalance;
                request.transferModel.FiatCurrency = self.coinModel.FiatCurrency;
                request.transferModel.Price = self.coinModel.FiatExchangeRate;
                request.transferModel.ChargeFee = self.coinModel.ChargeFee;
      
                request.userHash = self.userHash;
                [self.router pushToTransferInfoWithRequest:request];
            } else {
                [self handlePreTransferError:errorCode remoteMessage:message];
            }
        }];
    }
    else if (self.mobileBtn.selected) {
        
        if (!self.countryPhoneCode) {
            AlertActionItem *okItem = [AlertActionItem defaultOKItem];
            
            [self showAlertWithTitle:@""
                             message:NSLocalizedString(@"transfer.countryCodeIsNotSelectedWarning", @"")
                             actions:[NSArray arrayWithObject:okItem]];
            self.isAddMore = FALSE;
            self.lockedAddRemove = FALSE;
            return;
        }
        NSString *coinId = nil;
        if (self.coinModel && self.coinModel.Id){
            coinId = self.coinModel.Id;
        }
        if (self.countryPhoneCode && self.accountTF.text.length > 0) {
            [MBHUD showInView:self.view withDetailTitle:nil withType:HUDTypeLoading];
            [HomeHelperModel preTransfer:coinId toCountryId:self.countryPhoneCode toCellphone:self.accountTF.text email:nil completBlock:^(NSInteger errorCode, NSString *message, PreTransferModel *transferModel) {
                [MBHUD hideInView:self.view];
                
                if (errorCode == kFPNetRequestSuccessCode) {
                    //NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    //dict[@"transferModel"] = transferModel;
                    //dict[@"phoneCode"] = self.phoneCodeBtn.titleLabel.text;
                    //dict[@"cellPhone"] = self.accountTF.text;
                    //dict[@"countryId"] = [NSString stringWithFormat:@"%ld", (long) self.countryPhoneCode];
                    
                    if ([self findAccountDuplicates:transferModel.ToAccountId]) {
                        self.isAddMore = FALSE;
                        self.lockedAddRemove = FALSE;
                        [MBHUD showInView:self.view withDetailTitle:NSLocalizedString(@"transfer.send_to_group.duplicate_receiver_error", nil) withType:HUDTypeError];
                        return;
                    }
                    
                    transferModel.phone = [NSString stringWithFormat:@"%@ %@", self.phoneCodeBtn.titleLabel.text, self.accountTF.text];
                    [self.fundsReceiversList insertObject:transferModel atIndex:0];
                    self.accountTF.text = @"";
                    
                    if (self.isAddMore) {
                        self.isAddMore = FALSE;
                        
                        [self.receiversTable performBatchUpdates:^{
                            [self.receiversTable insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                        } completion:^(BOOL finished){
                            if( finished){
                                [self.receiversTable reloadData];
                                self.lockedAddRemove = FALSE;
                            }
                        }];
                        //[self.nextBtn setTitle:@"Select coin to send" forState:UIControlStateNormal];
                    } else {
                        [self.router pushToChooseCoinTransferNew:self.fundsReceiversList];
                    }
                } else {
                    [self handlePreTransferError:errorCode remoteMessage:message];
                    self.isAddMore = FALSE;
                    self.lockedAddRemove = FALSE;
                }
                
            }];
        } else {
            self.lockedAddRemove = FALSE;
            self.isAddMore = FALSE;
        }
    } else {
        if (self.emailTf.text.length > 0) {
            [MBHUD showInView:self.view withDetailTitle:nil withType:HUDTypeLoading];
            NSString *coinId = nil;
            if (self.coinModel && self.coinModel.Id){
                coinId = self.coinModel.Id;
            }
            
            [HomeHelperModel preTransfer:coinId toCountryId:self.countryPhoneCode toCellphone:nil email:self.emailTf.text completBlock:^(NSInteger errorCode, NSString *message, PreTransferModel *transferModel) {
                [MBHUD hideInView:self.view];
                
                if (errorCode == kFPNetRequestSuccessCode) {
                    
                    //NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    //dict[@"transferModel"] = transferModel;
                    //dict[@"email"] = self.emailTf.text;
                    
                    if ([self findAccountDuplicates:transferModel.ToAccountId]) {
                        self.isAddMore = FALSE;
                        self.lockedAddRemove = FALSE;
                        [MBHUD showInView:self.view withDetailTitle:NSLocalizedString(@"transfer.send_to_group.duplicate_receiver_error", nil) withType:HUDTypeError];
                        return;
                    }
                    
                    transferModel.email = self.emailTf.text;
                    
                    [self.fundsReceiversList insertObject:transferModel atIndex:0];
                    self.emailTf.text = @"";
                    
                    if (self.isAddMore) {
                        self.isAddMore = FALSE;
                        
                        [self.receiversTable performBatchUpdates:^{
                            [self.receiversTable insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                        } completion:^(BOOL finished){
                            if( finished){
                                [self.receiversTable reloadData];
                                self.lockedAddRemove = FALSE;
                            }
                        }];
                        //[self.nextBtn setTitle:@"Select coin to send" forState:UIControlStateNormal];
                    } else {
                        [self.router pushToChooseCoinTransferNew:self.fundsReceiversList];
                    }
                } else {
                    [self handlePreTransferError:errorCode remoteMessage:message];
                    self.isAddMore = FALSE;
                    self.lockedAddRemove = FALSE;
                }
            }];
        } else {
            self.isAddMore = FALSE;
            self.lockedAddRemove = FALSE;
        }
    }
}

-(BOOL)findAccountDuplicates:(NSString*)ToAccountId {
    for (PreTransferModel *transferModel in self.fundsReceiversList){
        
        if ([transferModel.ToAccountId isEqualToString:ToAccountId]){
            return true;
        }
    }
    
    return false;
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

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.SendToGroupThreshold && [self.SendToGroupThreshold intValue] > 1) {
        return 1;
    } else {
        return 0;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _fundsReceiversList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReceiverListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiverListViewCellId" forIndexPath:indexPath];
    if(cell == nil) {
        cell = [[ReceiverListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReceiverListViewCellId"];
    }
    PreTransferModel *item = _fundsReceiversList[indexPath.row];
    cell.name.text = [NSString stringWithFormat:@"%@ - %@", item.ToAccountName, item.ToFullname];
    
    cell.removeBtn.tag = indexPath.row;
    [cell.removeBtn addTarget:self action:@selector(removeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    ReceiverListFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ReceiverListFooterViewId"];
    [footerView.addMoreBtn setTitle:NSLocalizedString(@"transfer.send_to_group.button_title", nil) forState:UIControlStateNormal];
    [footerView.addMoreBtn addTarget:self action:@selector(addMoreBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [footerView.addMoreBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 90;
}
@end
