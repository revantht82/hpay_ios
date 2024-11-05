#import "SafeAuthViewController.h"
#import "SafeAuthCodeTextField.h"
#import "FPCountDownButton.h"
#import "SafeAuthDataHelper.h"
#import "AES128.h"
#import "SafeAuthRouter.h"
#import "ApiError.h"

#define kAuthSendPhoneCodeTime [NSString stringWithFormat:@"send_auth_phone_code_time.%@",[GCUserManager manager].user.sub]

@interface SafeAuthViewController () <UITextFieldDelegate, SafeAuthCodeTextFieldBarDelegate>

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *solidVHConstraint;
@property(weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property(weak, nonatomic) IBOutlet UIButton *finishBtn;
@property(weak, nonatomic) IBOutlet UIView *pinV;
@property(weak, nonatomic) IBOutlet UIView *phoneV;
@property(weak, nonatomic) IBOutlet UIView *googleV;
@property(weak, nonatomic) IBOutlet UIView *lv1NoV;
@property(weak, nonatomic) IBOutlet UIView *loginPasswordV;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *phoneVH;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *googleVH;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *lv1NoVH;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *loginPasswordVH;
@property(weak, nonatomic) IBOutlet FPCountDownButton *phoneSendBtn;
@property(weak, nonatomic) IBOutlet FPCountDownButton *emailSendBtn;
@property(weak, nonatomic) IBOutlet UILabel *verificationCodeCountdownTipsLabel;
@property(weak, nonatomic) IBOutlet SafeAuthCodeTextField *phoneCodeTextfield;
@property(weak, nonatomic) IBOutlet SafeAuthCodeTextField *googleCodeTextfield;
@property(weak, nonatomic) IBOutlet SafeAuthCodeTextField *lv1NoTextfield;
@property(weak, nonatomic) IBOutlet SafeAuthCodeTextField *pinTextfield;
@property(weak, nonatomic) IBOutlet SafeAuthCodeTextField *loginPasswordTextfield;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *solidHeaderViewSpace;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *mSHConstraint;
@property(weak, nonatomic) IBOutlet UIView *solidHeaderView;
@property(weak, nonatomic) IBOutlet UIButton *maskBtn;
@property(weak, nonatomic) IBOutlet UIView *placeHolderBgView;
@property(weak, nonatomic) IBOutlet UILabel *phoneSecretyLabel;

@property(weak, nonatomic) IBOutlet UIView *topBackView;
@property(weak, nonatomic) IBOutlet UILabel *headerTitleLabel;
@property(weak, nonatomic) IBOutlet UIButton *headerActionButton;
@property(weak, nonatomic) IBOutlet UIView *contentBackView;

@property(weak, nonatomic) IBOutlet UIView *divider;

@property(assign, nonatomic) BOOL isShowLV1NO;
@property(assign, nonatomic) BOOL isShowGoogle;
@property(assign, nonatomic) BOOL isShowPhone;
@property(assign, nonatomic) BOOL isShowLoginPassword;
@property(assign, nonatomic) SafeAuthType authType;
@property(assign, nonatomic) BOOL hasShown;
@property(assign, nonatomic) BOOL isSendSMS;
@property(copy, nonatomic) NSString *divisionCode;
@property(copy, nonatomic) NSString *CellPhone;
@property(copy, nonatomic) NSString *Email;
@property(strong, nonatomic) NSTimer *phoneTimer;
@property(strong, nonatomic) SafeAuthRouter<SafeAuthRouterInterface> *router;

- (IBAction)sendCodeEvent:(FPCountDownButton *)sender;
- (IBAction)dissMissVC:(id)sender;
- (IBAction)cancelEvent:(id)sender;
- (IBAction)txtValueChangeEvent:(UITextField *)sender;
- (IBAction)sureEvent:(UIButton *)sender;

@end

@implementation SafeAuthViewController

- (SafeAuthRouter<SafeAuthRouterInterface> *)router {
    if (_router == nil) {
        _router = [[SafeAuthRouter alloc] init];
        _router.currentControllerDelegate = self;
        _router.navigationDelegate = self.navigationController;
        _router.tabBarControllerDelegate = self.tabBarController;
    }
    return _router;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor clearColor];
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    if (self.authType == SafeAuthTypeResetPIN) {
        [self sendEmailCodeEvent:self.emailSendBtn];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MBHUD hideInView:self.view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.phoneSendBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.fd_prefersNavigationBarHidden = YES;
    if (self.authType != SafeAuthTypeExceptionDevice) {
        self.phoneCodeTextfield.barDelegate = self;
    } else {
        self.pinTextfield.barDelegate = self;
    }
    self.googleCodeTextfield.barDelegate = self;
    self.lv1NoTextfield.barDelegate = self;
    self.loginPasswordTextfield.barDelegate = self;
    [self setupUIContent];
    if (self.authType != SafeAuthTypeExceptionDevice && self.authType != SafeAuthTypeOnlyLoginPassword && self.authType != SafeAuthTypeGesture) {
        self.solidHeaderView.hidden = YES;
        self.mScrollView.hidden = YES;
        [self fetchDataAndUpdateUI];
    } else {
        [self checkBindUpdateUI];
    }
    [self setupSendBtnHideState];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [self applyTheme];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self applyTheme];
}

- (void)applyTheme{
    id<ThemeProtocol> theme = [self getCurrentTheme];
    self.topBackView.backgroundColor = theme.surface;
    self.headerTitleLabel.textColor = theme.primaryOnSurface;
    [self.headerActionButton setTitleColor:theme.primaryOnSurface forState:UIControlStateNormal];
    self.contentBackView.backgroundColor = theme.surface;
    self.phoneSecretyLabel.textColor = theme.primaryOnSurface;
    self.phoneCodeTextfield.textColor = theme.primaryOnSurface;
    [self.emailSendBtn setTitleColor:theme.primaryOnSurface forState:UIControlStateNormal];
    self.divider.backgroundColor = theme.verticalDivider;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self commanHideKeyboard];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGFloat keyboardHeight = [[notification userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat bindH = [self fetchBindHeight];
    CGFloat toolBarHeight = 44.0f;
    self.solidHeaderViewSpace.constant = keyboardHeight + bindH + 90 - toolBarHeight;
    [UIView animateWithDuration:0.35 animations:^{
        [self.view layoutIfNeeded];
    }                completion:^(BOOL finished) {
    }];

}

#pragma mark - Get Google permission, and display the phone number with *

- (void)fetchDataAndUpdateUI {
    //Get Google permission, and display the phone number with *
    if (self.authType == SafeAuthTypeAllExceptLV1NO || self.authType == SafeAuthTypeAll || self.authType == SafeAuthTypePhone || (self.authType >= SafeAuthTypeBindPhone && self.authType <= SafeAuthTypeUpdateEmail)) {
        [MBHUD showInView:self.view withDetailTitle:nil withType:HUDTypeLoading];
        [SafeAuthDataHelper fetchAuthenticatorOpenedSecuritiesCompleteBlock:^(NSString *CellPhone, NSString *Email, BOOL IsOpenedAuthencator, NSInteger errorCode, NSString *errorMessage) {
            [MBHUD hideInView:self.view];
            if (errorCode == kFPNetRequestSuccessCode) {
                if (self.authType != SafeAuthTypePhone) {
                    self.isShowGoogle = IsOpenedAuthencator;
                }
                self.CellPhone = CellPhone;
                self.Email = Email;

                [self checkBindUpdateUI];
                self.mScrollView.hidden = NO;
                self.solidHeaderView.hidden = NO;
                [self setupSendBtnHideState];
            }
        }];
    } else {
        self.mScrollView.hidden = NO;
        self.solidHeaderView.hidden = NO;
    }
}

#pragma mark - 显示倒数按钮

- (void)showCountBtn {
    if (self.authType == SafeAuthTypeGoogle || self.authType == SafeAuthTypeExceptionDevice || self.authType == SafeAuthTypeGesture || self.authType == SafeAuthTypeResetPIN) {
        return;
    }
    self.hasShown = NO;
    __weak typeof(self) wself = self;
    NSString *lastSendSecondData;
    WS(weakSelf);
    if (self.divisionCode && self.divisionCode.length > 0) {
        lastSendSecondData = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@-%@", kAuthSendPhoneCodeTime, self.divisionCode]]];
        if (lastSendSecondData && lastSendSecondData.length > 0 && [lastSendSecondData rangeOfString:@"-"].location != NSNotFound) {
            NSArray *secondArr = [lastSendSecondData componentsSeparatedByString:@"-"];
            if (secondArr && secondArr.count > 0) {
                NSTimeInterval lastSendSecond = [secondArr.lastObject doubleValue];
                NSDate *now = [NSDate date];
                NSTimeInterval sendSecond = [now timeIntervalSince1970];
                if (sendSecond - lastSendSecond < 60 && self.divisionCode && [self.divisionCode isEqualToString:secondArr.firstObject]) {
                    //继续倒计时
                    [self.phoneSendBtn startCountDownWithSecond:60 - (sendSecond - lastSendSecond)];
                    [self.phoneSendBtn countDownChanging:^NSString *(FPCountDownButton *countDownButton, NSUInteger second) {
                        countDownButton.enabled = NO;
                        [countDownButton setTitleColor:kDustyColor forState:UIControlStateDisabled];
                        NSString *title = [NSString stringWithFormat:NSLocalizedString(@"sms_countdown_remaining", @"x秒后重新发送"), (unsigned long) second];

                        if (!wself.hasShown) {
                            wself.hasShown = YES;
                        }
                        [weakSelf resetSendBtnState:YES];
                        weakSelf.verificationCodeCountdownTipsLabel.text = title;

                        return NSLocalizedWallet(@"sms");
                    }];
                    [self.phoneSendBtn countDownFinished:^NSString *(FPCountDownButton *countDownButton, NSUInteger second) {
                        countDownButton.enabled = YES;
                        [countDownButton setTitleColor:[self getCurrentTheme].primaryOnSurface forState:UIControlStateNormal];
                        [weakSelf resetSendBtnState:NO];
                        return NSLocalizedWallet(@"sms");
                    }];
                }
            }
        }
    } else {
        lastSendSecondData = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:kAuthSendPhoneCodeTime]];
        NSTimeInterval lastSendSecond = [lastSendSecondData doubleValue];
        NSDate *now = [NSDate date];
        NSTimeInterval sendSecond = [now timeIntervalSince1970];
        if (sendSecond - lastSendSecond < 60) {
            // Keep counting down
            [self.phoneSendBtn startCountDownWithSecond:60 - (sendSecond - lastSendSecond)];
            [self.phoneSendBtn countDownChanging:^NSString *(FPCountDownButton *countDownButton, NSUInteger second) {
                countDownButton.enabled = NO;
                [countDownButton setTitleColor:kDustyColor forState:UIControlStateDisabled];
                NSString *title = [NSString stringWithFormat:NSLocalizedString(@"sms_countdown_remaining", @"x秒后重新发送"), (unsigned long) second];
                if (!wself.hasShown) {
                    wself.hasShown = YES;
                }
                [weakSelf resetSendBtnState:YES];
                weakSelf.verificationCodeCountdownTipsLabel.text = title;
                return NSLocalizedWallet(@"sms");
            }];
            [self.phoneSendBtn countDownFinished:^NSString *(FPCountDownButton *countDownButton, NSUInteger second) {
                countDownButton.enabled = YES;
                [countDownButton setTitleColor:[self getCurrentTheme].primaryOnSurface forState:UIControlStateNormal];
                [weakSelf resetSendBtnState:NO];
                return NSLocalizedWallet(@"sms");
            }];
        }
    }
}


#pragma mark - More UI content

- (void)setupUIContent {
    [self.finishBtn setTitle:NSLocalizedString(@"confirm", @"").uppercaseString forState:UIControlStateNormal|UIControlStateDisabled];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 5;
    //There is a problem with account security verification, please contact customer service to appeal

    NSString *warningStr = NSLocalizedCommon(@"using_on_multiple_device");
    NSString *linkCSStr = NSLocalizedWallet(@"contact");
    NSString * str = [NSString stringWithFormat:NSLocalizedProfile(@"if_you_have_any_questions"), linkCSStr];
    if (self.authType == SafeAuthTypeExceptionDevice) {
        str = [NSString stringWithFormat:@"%@%@", warningStr, str];
    }

    NSInteger fontSize = 13;
    if (SCREEN_WIDTH == 320) {
        fontSize = 12;
    }

    self.finishBtn.enabled = NO;
    if (self.authType != SafeAuthTypeExceptionDevice) {

        NSString *placeHolderPhone = NSLocalizedDefault(@"email_verification_code");
        NSMutableAttributedString *phoneDefaultAttr = [[NSMutableAttributedString alloc] initWithString:placeHolderPhone];
        [phoneDefaultAttr addAttribute:NSFontAttributeName value:UIFontMake(15) range:NSMakeRange(0, placeHolderPhone.length)];
        [phoneDefaultAttr addAttribute:NSForegroundColorAttributeName value:kDustyColor range:NSMakeRange(0, placeHolderPhone.length)];
        self.phoneCodeTextfield.attributedPlaceholder = phoneDefaultAttr;
    } else {
        NSString *placeHolderPin = NSLocalizedCommon(@"verify_pin");
        NSMutableAttributedString *pinDefaultAttr = [[NSMutableAttributedString alloc] initWithString:placeHolderPin];
        [pinDefaultAttr addAttribute:NSFontAttributeName value:UIFontMake(15) range:NSMakeRange(0, placeHolderPin.length)];
        [pinDefaultAttr addAttribute:NSForegroundColorAttributeName value:kDustyColor range:NSMakeRange(0, placeHolderPin.length)];
        self.pinTextfield.attributedPlaceholder = pinDefaultAttr;
    }

    NSString *placeHolderGoogle = NSLocalizedWallet(@"谷歌验证码");
    NSMutableAttributedString *googleDefaultAttr = [[NSMutableAttributedString alloc] initWithString:placeHolderGoogle];
    [googleDefaultAttr addAttribute:NSFontAttributeName value:UIFontMake(15) range:NSMakeRange(0, placeHolderGoogle.length)];
    [googleDefaultAttr addAttribute:NSForegroundColorAttributeName value:kDustyColor range:NSMakeRange(0, placeHolderGoogle.length)];

    NSString *placeHolderlv1No = NSLocalizedWallet(@"请输入证件号");
    NSMutableAttributedString *lv1NoDefaultAttr = [[NSMutableAttributedString alloc] initWithString:placeHolderlv1No];
    [lv1NoDefaultAttr addAttribute:NSFontAttributeName value:UIFontMake(15) range:NSMakeRange(0, placeHolderlv1No.length)];
    [lv1NoDefaultAttr addAttribute:NSForegroundColorAttributeName value:kDustyColor range:NSMakeRange(0, placeHolderlv1No.length)];

    self.googleCodeTextfield.attributedPlaceholder = googleDefaultAttr;
    self.lv1NoTextfield.attributedPlaceholder = lv1NoDefaultAttr;
    if (self.authType != SafeAuthTypeExceptionDevice) {
        [self setupStatus];
        [self showCountBtn];
    }
}

#pragma mark - Update send button

- (void)updateSendBtn:(BOOL)isSendSMSCode {
    NSDate *now = [NSDate date];
    NSTimeInterval sendSecond = [now timeIntervalSince1970];
    if (self.divisionCode && self.divisionCode.length > 0) {
        NSString *str = [NSString stringWithFormat:@"%@-%@", self.divisionCode, @(sendSecond)];
        [[NSUserDefaults standardUserDefaults] setObject:str forKey:[NSString stringWithFormat:@"%@-%@", kAuthSendPhoneCodeTime, self.divisionCode]];
    } else {
        NSString *str = [NSString stringWithFormat:@"%@", @(sendSecond)];
        [[NSUserDefaults standardUserDefaults] setObject:str forKey:[NSString stringWithFormat:@"%@", kAuthSendPhoneCodeTime]];
    }

    FPCountDownButton *btn = self.phoneSendBtn;
    NSString *btnTitle = NSLocalizedWallet(@"sms");
    if (!isSendSMSCode) {
        btn = self.emailSendBtn;
        btnTitle = NSLocalizedDefault(@"resetPin.safeAuth.resendButton.title");
    }

    [btn startCountDownWithSecond:60];
    WS(weakSelf);
    [btn countDownChanging:^NSString *(FPCountDownButton *countDownButton, NSUInteger second) {
        countDownButton.enabled = NO;
        [countDownButton setTitleColor:kDustyColor forState:UIControlStateDisabled];
        NSString *title = [NSString stringWithFormat:NSLocalizedString(@"sms_countdown_remaining", @"已发送Xs"), (unsigned long) second];
        [weakSelf resetSendBtnState:YES];
        weakSelf.verificationCodeCountdownTipsLabel.text = title;
        return btnTitle;
    }];
    [btn countDownFinished:^NSString *(FPCountDownButton *countDownButton, NSUInteger second) {
        countDownButton.enabled = YES;
        [countDownButton setTitleColor:[self getCurrentTheme].primaryOnSurface forState:UIControlStateNormal];
        [weakSelf resetSendBtnState:NO];
        return btnTitle;
    }];
}

- (void)resetSendBtnState:(BOOL)isCountDownChanging {
    if (isCountDownChanging) {
        self.phoneSendBtn.hidden = YES;
        self.emailSendBtn.hidden = YES;
        self.verificationCodeCountdownTipsLabel.hidden = NO;
    } else {
        self.phoneSendBtn.hidden = NO;
        self.emailSendBtn.hidden = NO;
        self.verificationCodeCountdownTipsLabel.hidden = YES;
        [self setupSendBtnHideState];
    }
}

- (void)setupSendBtnHideState {
    if (self.authType == SafeAuthTypeBindPhone || self.authType == SafeAuthTypeUpdateEmail) {
        self.phoneSendBtn.hidden = YES;
    } else if (self.authType == SafeAuthTypeBindEmail || self.authType == SafeAuthTypeUpdatePhone) {
        self.emailSendBtn.hidden = YES;
    } else if (self.authType == SafeAuthTypeResetPIN) {
        self.phoneSendBtn.hidden = YES;
        self.emailSendBtn.hidden = NO;
    } else {
        self.phoneSendBtn.hidden = NO;
        self.emailSendBtn.hidden = NO;
    }
    if (self.emailSendBtn.hidden && !self.phoneSendBtn.hidden) {
        [self.phoneSendBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.equalTo(self.emailSendBtn.mas_centerY);
        }];
    }
}

#pragma mark - Configuration type

- (void)configWithAuthType:(SafeAuthType)authType {
    self.authType = authType;
}

- (void)configWithAuthType:(SafeAuthType)authType andDivisionCode:(NSString *)divisionCode {
    self.authType = authType;
    self.divisionCode = divisionCode;
}

- (void)configWithAuthType:(SafeAuthType)authType andLV1Auth:(BOOL)lv1Enable andGoogleAuth:(BOOL)googleEnable {
    self.authType = authType;
    self.isShowLV1NO = lv1Enable;
    self.isShowPhone = YES;
    self.isShowGoogle = googleEnable;
}

#pragma mark - Configure UI type

- (void)setupStatus {
    self.isShowLoginPassword = NO;
    switch (self.authType) {
        case SafeAuthTypeAll: {
            // According to the return judgment, it is temporarily written to death
            self.isShowPhone = YES;
            self.isShowLV1NO = YES;
            self.isShowGoogle = YES;
        }
            break;
        case SafeAuthTypeAllExceptLV1NO: {
            // According to the return judgment, it is temporarily written to death
            self.isShowPhone = YES;
            self.isShowLV1NO = NO;
            self.isShowGoogle = YES;
        }
            break;
        case SafeAuthTypePhone: {
            // According to the return judgment, it is temporarily written to death
            self.isShowPhone = YES;
            self.isShowLV1NO = NO;
            self.isShowGoogle = YES;
        }
            break;
        case SafeAuthTypeGoogle: //Only verify Google, when Google has been bound, use this type when Google verification is enabled, login
        {
            self.isShowPhone = NO;
            self.isShowLV1NO = NO;
            self.isShowGoogle = YES;
        }
            break;
        case SafeAuthTypeGesture:
        case SafeAuthTypeOnlyLoginPassword: {
            self.isShowPhone = NO;
            self.isShowLV1NO = NO;
            self.isShowGoogle = NO;
            self.isShowLoginPassword = YES;
        }
            break;
        case SafeAuthTypeResetPIN: {
            self.isShowPhone = YES;
            self.isShowLV1NO = NO;
            self.isShowGoogle = NO;
        }
            break;
        default: {
            self.isShowPhone = YES;
            self.isShowLV1NO = NO;
            self.isShowGoogle = NO;
        }
            break;
    }
    [self checkBindUpdateUI];
}

#pragma mark - Refresh UI based on state

- (void)checkBindUpdateUI {
    self.phoneV.hidden = YES;
    self.googleV.hidden = YES;
    self.lv1NoV.hidden = YES;
    self.pinV.hidden = YES;
    self.loginPasswordV.hidden = YES;
    self.googleVH.constant = 0;
    self.phoneVH.constant = 0;
    self.lv1NoVH.constant = 0;
    self.loginPasswordVH.constant = 0;

    if (self.isShowPhone) {
        if (self.authType != SafeAuthTypeExceptionDevice) {
            self.phoneV.hidden = NO;
        } else {
            self.pinV.hidden = NO;
        }

        self.phoneVH.constant = 87;
    }
    if (self.isShowGoogle) {
        self.googleV.hidden = NO;
        self.googleVH.constant = 87;
    }
    if (self.isShowLV1NO) {
        self.lv1NoV.hidden = NO;
        self.lv1NoVH.constant = 87;
    }
    if (self.isShowLoginPassword) {
        self.loginPasswordV.hidden = NO;
        self.loginPasswordVH.constant = 87;
    }
    CGFloat bindH = [self fetchBindHeight];
    self.mSHConstraint.constant = 90 + bindH;
    self.solidHeaderViewSpace.constant = 90 + bindH;


    if (self.authType == SafeAuthTypeExceptionDevice) {
        self.solidVHConstraint.constant = 180;
    } else {
        self.solidVHConstraint.constant = 110;
    }
    [self.view layoutIfNeeded];
}

#pragma mark - Get UI height

- (CGFloat)fetchBindHeight {
    CGFloat heigth_val = 0;
    if (self.isShowPhone) {
        heigth_val += 87;
    }
    if (self.isShowGoogle) {
        heigth_val += 87;
    }
    if (self.isShowLV1NO) {
        heigth_val += 87;
    }
    if (self.isShowLoginPassword) {
        heigth_val += 87;
    }
    return heigth_val;
}

- (IBAction)dissMissVC:(id)sender {
    if (self.dissMissEvent) {
        self.dissMissEvent();
    } else {
        [UIView animateWithDuration:0.15 animations:^{
            self.maskBtn.backgroundColor = UIColorFromRGBA(0x000000, 0);
        }                completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:YES completion:NULL];
        }];
    }
}

- (void)startAnimationEvent {
    [UIView animateWithDuration:0.15 animations:^{
        self.maskBtn.backgroundColor = UIColorFromRGBA(0x000000, 0.61);
    }];
}

- (IBAction)cancelEvent:(id)sender {
    [MBHUD hideInView:self.view];
    if (self.dissMissEvent) {
        self.dissMissEvent();
    } else {
        [UIView animateWithDuration:0.35 animations:^{
            self.maskBtn.backgroundColor = UIColorFromRGBA(0x000000, 0);
        }                completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:YES completion:NULL];
        }];
    }
}

- (IBAction)sendCodeEvent:(FPCountDownButton *)sender {
    if (sender == self.phoneSendBtn) {
        if (self.authType < SafeAuthTypeBindPhone || self.authType > SafeAuthTypeUpdateEmail) {
            if (self.CellPhone.length == 0) {
                [MBHUD showInView:self.view withDetailTitle:NSLocalizedWallet(@"bind_phone") withType:HUDTypeFailWithoutImage];
                return;
            }
        }
        self.isSendSMS = YES;
        [MBHUD showInView:self.view withDetailTitle:nil withType:HUDTypeLoading];

        [SafeAuthDataHelper sendSafePhoneSMSCodeWithDivisionCode:self.divisionCode CompleteBlock:^(BOOL success, NSInteger errorCode, NSString *errorMessage) {
            [MBHUD hideInView:self.view];
            if (errorCode == kFPNetRequestSuccessCode && success) {
                [self updateSendBtn:YES];
            } else {
                errorMessage ? [MBHUD showInView:self.view withDetailTitle:errorMessage withType:HUDTypeError] : nil;
            }
        }];
    }
}

- (IBAction)sendEmailCodeEvent:(FPCountDownButton *)sender {
    if (sender == self.emailSendBtn) {
        if (self.authType < SafeAuthTypeBindPhone || self.authType > SafeAuthTypeResetPIN) {
            if (self.Email.length == 0) {
                [MBHUD showInView:self.view withDetailTitle:NSLocalizedWallet(@"bind_email") withType:HUDTypeFailWithoutImage];
                return;
            }
        }

        self.phoneCodeTextfield.text = NULL;
        self.isSendSMS = NO;
        [MBHUD showInView:self.view withDetailTitle:nil withType:HUDTypeLoading];
        [SafeAuthDataHelper sendSafePhoneEmailCodeWithDivisionCode:self.divisionCode CompleteBlock:^(BOOL success, NSInteger errorCode, NSString *errorMessage) {
            [MBHUD hideInView:self.view];
            if (errorCode == kFPNetRequestSuccessCode && success) {
                [self updateSendBtn:NO];
            }else if (errorCode == kFPNetWorkErrorCode){
                [self showAlertForConnectionFailure];
            } else {
                ApiError *error = [ApiError errorWithCode:errorCode message:errorMessage];
                [MBHUD showInView:self.view withDetailTitle:error.prettyMessage withType:HUDTypeError];
            }
        }];
    }
}


#define kAlphaNum @"0123456789"
#define kAlphaCharatersNum @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789()（）"
#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ((textField != self.lv1NoTextfield && textField != self.pinTextfield && textField != self.loginPasswordTextfield) || (textField == self.googleCodeTextfield && self.authType == SafeAuthTypeExceptionDevice)) {
        if (textField.text.length == 6 && ![string isEqualToString:@""]) {
            return NO;
        }
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
        BOOL canChange = [string isEqualToString:filtered];
        if (canChange) {
            if (textField.text.length + string.length >= 6 && ![string isEqualToString:@""]) {
                NSString *mixStr = [NSString stringWithFormat:@"%@%@", textField.text, string];
                textField.text = [mixStr substringToIndex:6];
                [self updateBtnStatu:[self canNextValidateAction]];
                return NO;
            }
        }
        return canChange;
    } else {
        if (textField.text.length == 50 && ![string isEqualToString:@""]) {
            return NO;
        }
        if (textField.text.length + string.length >= 50 && ![string isEqualToString:@""]) {
            NSString *mixStr = [NSString stringWithFormat:@"%@%@", textField.text, string];
            textField.text = [mixStr substringToIndex:50];
            [self updateBtnStatu:[self canNextValidateAction]];
            return NO;
        }
    }
    return YES;

}

#pragma mark - Textfield value ChangeEvent

- (IBAction)txtValueChangeEvent:(UITextField *)sender {
    [self updateBtnStatu:[self canNextValidateAction]];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (((self.authType != SafeAuthTypeExceptionDevice && !self.phoneCodeTextfield.isFirstResponder) || (self.authType == SafeAuthTypeExceptionDevice && !self.pinTextfield.isFirstResponder)) && !self.googleCodeTextfield.isFirstResponder && !self.lv1NoTextfield.isFirstResponder) {
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

#pragma mark - SafeAuthCodeTextFieldBarDelegate

- (void)barFinishEvent:(SafeAuthCodeTextField *)sender {
    [self commanHideKeyboard];
}

- (void)hideSafeVC:(BOOL)outSideDissmiss {
    [self commanHideKeyboard];
    if (!outSideDissmiss) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (void)commanHideKeyboard {
    if (((self.authType != SafeAuthTypeExceptionDevice && self.phoneCodeTextfield.isFirstResponder) || (self.authType == SafeAuthTypeExceptionDevice && self.pinTextfield.isFirstResponder)) || self.googleCodeTextfield.isFirstResponder || self.lv1NoTextfield.isFirstResponder || self.loginPasswordTextfield.isFirstResponder) {
        [self hideKeyboard];
        CGFloat bindH = [self fetchBindHeight];
        self.solidHeaderViewSpace.constant = 90 + bindH;
        [UIView animateWithDuration:0.35 animations:^{
            [self.view layoutIfNeeded];
        }                completion:^(BOOL finished) {
            self.mScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 90 + bindH);
        }];
    }
}

- (IBAction)sureEvent:(UIButton *)sender {
    [self updateBtnStatu:NO];
    [self commanHideKeyboard];
    if (self.authType == SafeAuthTypeGoogle) {
        if (self.googleCodeTextfield.text && self.googleCodeTextfield.text.length < 6) {
            [MBHUD showInView:self.view withDetailTitle:NSLocalizedWallet(@"verification_code_rule") withType:HUDTypeError];
            [self updateBtnStatu:YES];
            return;
        }

        NSString *googleCode = self.googleCodeTextfield.text;
        if (self.safeDelegate && [self.safeDelegate respondsToSelector:@selector(finishWithGoogleCode:)]) {
            [self.safeDelegate finishWithGoogleCode:((googleCode && googleCode.length > 0) ? googleCode : nil)];
        }
    } else if (self.authType == SafeAuthTypeAllExceptLV1NO) {
        if (self.isShowPhone && self.phoneCodeTextfield.text && self.phoneCodeTextfield.text.length < 6) {
            [MBHUD showInView:self.view withDetailTitle:NSLocalizedWallet(@"verification_code_rule") withType:HUDTypeError];
            [self updateBtnStatu:YES];
            return;
        }
        if (self.isShowGoogle && self.googleCodeTextfield.text && self.googleCodeTextfield.text.length < 6) {
            [MBHUD showInView:self.view withDetailTitle:NSLocalizedWallet(@"verification_code_rule") withType:HUDTypeError];
            [self updateBtnStatu:YES];
            return;
        }

        if (self.safeDelegate && [self.safeDelegate respondsToSelector:@selector(finishWithSMSCode:andEmailCode:andGoogleCode:)]) {
            NSString *smsCode = nil;
            NSString *emailCode = nil;
            if (self.isSendSMS) {
                smsCode = self.phoneCodeTextfield.text;
            } else {
                emailCode = self.phoneCodeTextfield.text;
            }
            [self.safeDelegate finishWithSMSCode:smsCode andEmailCode:emailCode andGoogleCode:self.googleCodeTextfield.text];
        }

    } else if (self.authType == SafeAuthTypeExceptionDevice) {
        if (self.isShowGoogle && self.googleCodeTextfield.text && self.googleCodeTextfield.text.length < 6) {
            [MBHUD showInView:self.view withDetailTitle:NSLocalizedWallet(@"verification_code_rule") withType:HUDTypeError];
            [self updateBtnStatu:YES];
            return;
        }

        if (self.safeDelegate && [self.safeDelegate respondsToSelector:@selector(finishSafeAuthVC:andLv1:andPin:andGoogleCode:)]) {
            if (self.pinTextfield.text && self.pinTextfield.text.length > 0) {
                NSString *lv1 = (self.lv1NoTextfield.text && self.lv1NoTextfield.text.length > 0) ? self.lv1NoTextfield.text : nil;
                NSString *googleCode = (self.googleCodeTextfield.text && self.googleCodeTextfield.text.length > 0) ? self.googleCodeTextfield.text : nil;
                [self.safeDelegate finishSafeAuthVC:self andLv1:lv1 andPin:[AES128 encryptAES128:self.pinTextfield.text] andGoogleCode:googleCode];
            }

        }
    } else if (self.authType == SafeAuthTypeAll) {
        if (self.isShowPhone && self.phoneCodeTextfield.text && self.phoneCodeTextfield.text.length < 6) {
            [MBHUD showInView:self.view withDetailTitle:NSLocalizedWallet(@"verification_code_rule") withType:HUDTypeError];
            [self updateBtnStatu:YES];
            return;
        }
        if (self.isShowGoogle && self.googleCodeTextfield.text && self.googleCodeTextfield.text.length < 6) {
            [MBHUD showInView:self.view withDetailTitle:NSLocalizedWallet(@"verification_code_rule") withType:HUDTypeError];
            [self updateBtnStatu:YES];
            return;
        }

        if (self.safeDelegate && [self.safeDelegate respondsToSelector:@selector(finishSafeAuthVC:andLv1:andSmsCode:andEmailCode:andGoogleCode:)]) {
            NSString *smsCode = nil;
            NSString *emailCode = nil;
            if (self.isSendSMS) {
                smsCode = (self.phoneCodeTextfield.text && self.phoneCodeTextfield.text.length > 0) ? self.phoneCodeTextfield.text : nil;
            } else {
                emailCode = (self.phoneCodeTextfield.text && self.phoneCodeTextfield.text.length > 0) ? self.phoneCodeTextfield.text : nil;
            }

            NSString *lv1 = (self.lv1NoTextfield.text && self.lv1NoTextfield.text.length > 0) ? self.lv1NoTextfield.text : nil;
            NSString *googleCode = (self.googleCodeTextfield.text && self.googleCodeTextfield.text.length > 0) ? self.googleCodeTextfield.text : nil;
            [self.safeDelegate finishSafeAuthVC:self andLv1:lv1 andSmsCode:smsCode andEmailCode:emailCode andGoogleCode:googleCode];
        }
    } else if (self.authType == SafeAuthTypeResetPIN) {
        
        if (self.phoneCodeTextfield.text && self.phoneCodeTextfield.text.length < 6) {
            [MBHUD showInView:self.view withDetailTitle:NSLocalizedWallet(@"verification_code_rule") withType:HUDTypeError];
            [self updateBtnStatu:YES];
            return;
        }
        
        if (self.safeDelegate && [self.safeDelegate respondsToSelector:@selector(finishSafeAuthVC:andEmailCode:)]) {
            NSString *emailCode = (self.phoneCodeTextfield.text && self.phoneCodeTextfield.text.length > 0) ? self.phoneCodeTextfield.text : nil;
            [self.safeDelegate finishSafeAuthVC:self andEmailCode:emailCode];
        }
        
    } else {

        if (self.isShowPhone && self.phoneCodeTextfield.text && self.phoneCodeTextfield.text.length < 6) {
            [MBHUD showInView:self.view withDetailTitle:NSLocalizedWallet(@"verification_code_rule") withType:HUDTypeError];
            [self updateBtnStatu:YES];
            return;
        }
        if (self.safeDelegate && [self.safeDelegate respondsToSelector:@selector(finishWithSMSCode:andEmailCode:andGoogleCode:)]) {
            NSString *smsCode = nil;
            NSString *emailCode = nil;
            if (self.isSendSMS) {
                smsCode = (self.phoneCodeTextfield.text && self.phoneCodeTextfield.text.length > 0) ? self.phoneCodeTextfield.text : nil;
            } else {
                emailCode = (self.phoneCodeTextfield.text && self.phoneCodeTextfield.text.length > 0) ? self.phoneCodeTextfield.text : nil;
            }
            NSString *googleCode = (self.googleCodeTextfield.text && self.googleCodeTextfield.text.length > 0) ? self.googleCodeTextfield.text : nil;
            [self.safeDelegate finishWithSMSCode:smsCode andEmailCode:emailCode andGoogleCode:googleCode];
        }
    }
}

- (void)updateBtnStatu:(BOOL)beEnable {
    self.finishBtn.enabled = beEnable;
    if (beEnable) {
        self.finishBtn.layer.shadowColor = UIColorFromRGBA(0x1E79FF, 1).CGColor;
        self.finishBtn.layer.shadowOffset = CGSizeMake(0, 3);
        self.finishBtn.layer.shadowOpacity = 0.35;
        self.finishBtn.layer.shadowRadius = 4.5;
        self.finishBtn.clipsToBounds = NO;
    } else {
        self.finishBtn.layer.shadowColor = UIColorFromRGBA(0x1E79FF, 0).CGColor;
        self.finishBtn.layer.shadowOffset = CGSizeMake(0, 0);
        self.finishBtn.layer.shadowOpacity = 0;
        self.finishBtn.layer.shadowRadius = 0;
        self.finishBtn.clipsToBounds = NO;
    }
}

#pragma mark - Whether it meets the verification button highlighting rules

- (BOOL)canNextValidateAction {
    BOOL next = NO;
    NSString *lv1NoText = self.lv1NoTextfield.text;
    NSString *smsCodeText = self.phoneCodeTextfield.text;
    NSString *pinText = self.pinTextfield.text;
    NSString *googleCodeText = self.googleCodeTextfield.text;
    NSString *loginPasswordText = self.loginPasswordTextfield.text;
    BOOL googleCodeCondition = (!self.isShowGoogle || (self.isShowGoogle && googleCodeText && googleCodeText.length > 0));
    BOOL lv1NoCondition = (!self.isShowLV1NO || (self.isShowLV1NO && lv1NoText && lv1NoText.length > 0));
    switch (self.authType) {
        case SafeAuthTypeAll://lv1,smsCode,(googleCode needs to determine whether to open)
        {
            if (lv1NoText && lv1NoText.length > 0 && smsCodeText && smsCodeText.length > 0 && googleCodeCondition) {
                next = YES;
            }
        }
            break;
        case SafeAuthTypeAllExceptLV1NO://smsCode, (googleCode needs to determine whether to open)
        {
            if (smsCodeText && smsCodeText.length > 0 && googleCodeCondition) {
                next = YES;
            }
        }
            break;
        case SafeAuthTypePhone://smsCode
        {
            if (smsCodeText && smsCodeText.length > 0) {
                next = YES;
            }
        }
            break;
        case SafeAuthTypeGoogle://googleCode
        {
            next = googleCodeCondition;
        }
            break;
        case SafeAuthTypeExceptionDevice://(lv1 needs to judge whether it is kyc),pin, (googleCode needs to judge whether to open)
        {
            if (lv1NoCondition && pinText && pinText.length > 0 && googleCodeCondition) {
                next = YES;
            }
        }
            break;
        case SafeAuthTypeGesture:
        case SafeAuthTypeOnlyLoginPassword: {
            if (loginPasswordText.length >= 8 && loginPasswordText.length <= 24) {
                next = YES;
            }
        }
            break;
        case SafeAuthTypeBindEmail:
        case SafeAuthTypeUpdateEmail:
        case SafeAuthTypeBindPhone:
        case SafeAuthTypeUpdatePhone: {
            if (googleCodeCondition && smsCodeText.length > 0) {
                next = YES;
            }
        }
            break;
        case SafeAuthTypeResetPIN: {
            if (smsCodeText.length > 0) {
                next = YES;
            }
        }
            break;
        default:
            next = NO;
            break;
    }
    return next;
}

@end
