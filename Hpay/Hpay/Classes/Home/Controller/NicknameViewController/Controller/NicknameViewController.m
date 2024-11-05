//
//  NicknameViewController.m
//  FiiiPay
//
//  Created by Mac on 2018/6/8.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "NicknameViewController.h"
#import "UIButton+ImageTitleSpacing.h"
#import "LoginHelperModel.h"
#import "HomeHelperModel.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "NSString+Regular.h"
#import "HPTextField.h"
#import "FBCoin.h"
#import "HCToolBar.h"
#import "ApiError.h"
#import "HimalayaPayAPIManager.h"
#import "UserConfigResponse.h"
#import "HimalayaAuthKeychainManager.h"


@interface NicknameViewController ()
@property(weak, nonatomic) IBOutlet UIView *inputContainerView;

@property(weak, nonatomic) IBOutlet UIButton *nextBtn;
@property(weak, nonatomic) IBOutlet UIView *emailView;
@property(weak, nonatomic) IBOutlet HPTextField *emailTf;
@property(weak, nonatomic) IBOutlet UILabel *placeTips;//Prompt statement
@property(weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property(weak, nonatomic) IBOutlet UIView *divider;

@property(strong, nonatomic) HCToolBar *toolBar;

@property(nonatomic) BOOL isViewDidAppear;

@end

@implementation NicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self.scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)]];
    
    NSError *error;
    UserConfigResponse *userConfig = [HimalayaAuthKeychainManager loadUserConfigToKeychain:&error];
    
    if (!error) {
        self.emailTf.text = userConfig.nickname;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.isViewDidAppear = YES;
}

- (BOOL)canShowKeyboard {
    return self.isViewDidAppear;
}

- (void)initUI {
    [self configureViewStateHandlingWithAlignment:kAlignmentFull height:NULL];
    self.fd_prefersNavigationBarHidden = NO;
    
    self.navigationItem.title = NSLocalizedString(@"nickname.title", @"");
    
    
    [self.nextBtn setTitle:self.nextBtn.titleLabel.text.localizedUppercaseString forState:UIControlStateNormal];
    self.nextBtn.alpha = 0.5;
    self.emailTf.maxNumber = 12;
    self.emailTf.inputAccessoryView = self.toolBar;
    
    self.emailTf.placeholder = NSLocalizedString(@"create_secure_alias", @"");
    
    self.emailView.hidden = NO;
    self.nextBtn.selected = NO;
    self.nextBtn.userInteractionEnabled = NO;
    [self.emailTf becomeFirstResponder];
    self.placeTips.text = NSLocalizedString(@"create_secure_alias_tips", @"");
    
    [self applyTheme];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self applyTheme];
}

- (void)applyTheme{
    id<ThemeProtocol> theme = [self getCurrentTheme];
    self.inputContainerView.backgroundColor = theme.surface;
    self.view.backgroundColor = theme.background;
    self.scrollView.backgroundColor = theme.background;
    
    _nextBtn.backgroundColor = theme.primaryButton;
    _divider.backgroundColor = theme.primaryOnBackground;
}


- (void)handleErrorWithErrorCode:(NSInteger)code message:(NSString *)message{
    switch (code) {
        case kFPNetWorkErrorCode:{
            [self showNetworkErrorWithPrimaryButtonTitle:StateViewModel.retryButtonTitle
                                    secondaryButtonTitle:NULL
                                     didTapPrimaryButton:^(id  _Nonnull sender) {
                //[self didTapRefresh:sender];
            } didTapSecondaryButton:NULL];
            break;
        }
        default:{
            [self showGenericApiErrorWithPrimaryButtonTitle:StateViewModel.retryButtonTitle
                                       secondaryButtonTitle:NULL didTapPrimaryButton:^(id  _Nonnull sender) {
                //[self didTapRefresh:sender];
            } didTapSecondaryButton:NULL];
            break;
        }
    }
}

#pragma mark - TextFieldValueChange

- (IBAction)textFieldValueChange:(id)sender {
    self.nextBtn.selected = self.nextBtn.userInteractionEnabled = [NSString verifyNickname:self.emailTf.text] ? YES : NO;
    [self.nextBtn configureBackgroundColorFor:[NSString verifyNickname:self.emailTf.text]];
}

#pragma mark - Actions

- (IBAction)nextAction:(id)sender {
    [MBHUD showInView:self.view withDetailTitle:nil withType:HUDTypeLoading];
    
    [HimalayaPayAPIManager POST:SetNicknameURL parameters:@{@"nickname": self.emailTf.text} successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        
        [MBHUD hideInView:self.view];
        NSDictionary *dict = (NSDictionary *) data;
        
        NSError *error;
        UserConfigResponse *userConfig = [HimalayaAuthKeychainManager loadUserConfigToKeychain:&error];
        if (!error) {
            userConfig.nickname = dict[@"NickName"];
        }
        [HimalayaAuthKeychainManager saveUserConfigToKeychain:userConfig];
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"done", "") message:NSLocalizedString(@"nickname_changed", @"") preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"okay", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        [MBHUD hideInView:self.view];
        
        NSString *title = NSLocalizedString(@"nickname.error.title_label", @"");
        if (code == kErrorCodeINVALID_NICKNAME) {
            title = NSLocalizedString(@"nickname.error.INVALID_NICKNAME", @"");;
        }
        else if (code == kErrorCodeNICKNAME_ALREADY_EXIST) {
            title = NSLocalizedString(@"nickname.error.NICKNAME_ALREADY_EXIST", @"");;
        }
        else if (code == kErrorCodeNICKNAME_REQUIRED) {
            title = NSLocalizedString(@"nickname.error.NICKNAME_REQUIRED", @"");;
        }
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"okay", nil) style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        
    }];
}

#pragma mark - Next

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

@end
