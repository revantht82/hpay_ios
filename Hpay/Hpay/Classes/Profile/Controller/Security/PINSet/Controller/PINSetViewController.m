#import "PINSetViewController.h"
#import "FPPasswordDotCell.h"
#import "ProfileHelperModel.h"
#import "AES128.h"
#import "SafeAuthViewController.h"
#import "PINSetRouter.h"
#import "NSString+Regular.h"
#import "HimalayaAuthManager.h"
#import "HCAmountTextField.h"
#import "ApiError.h"
#import "AlertActionItem.h"
#import "HPAYBioAuth.h"

@interface PINSetViewController () <UICollectionViewDelegate, UICollectionViewDataSource, SafeAuthDelegate>

@property(weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property(weak, nonatomic) IBOutlet UILabel *bottomTipsLabel;
@property(weak, nonatomic) IBOutlet UILabel *backupTipsLabel;
@property(weak, nonatomic) IBOutlet UIImageView *backupTipsImageView;
@property(weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(weak, nonatomic) IBOutlet HCAmountTextField *textField;
@property(weak, nonatomic) IBOutlet UIButton *forgotPINBtn;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelTopLayoutConstraint;
@property(strong, nonatomic) SafeAuthViewController *safeAuthVC;
@property(strong, nonatomic) PINSetRouter<PINSetRouterInterface> *router;
@end

@implementation PINSetViewController

- (PINSetRouter<PINSetRouterInterface> *)router {
    if (_router == nil) {
        _router = [[PINSetRouter alloc] init];
        _router.currentControllerDelegate = self;
        _router.navigationDelegate = self.navigationController;
        _router.tabBarControllerDelegate = self.tabBarController;
    }
    return _router;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self applyTheme];
    [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"Disable_Pinverification"];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self applyTheme];
}

- (void)applyTheme{
    self.titleLabel.textColor = [self getCurrentTheme].secondaryOnBackground;
    self.subTitleLabel.textColor = [self getCurrentTheme].primaryOnBackground;
    self.backupTipsLabel.textColor = [self getCurrentTheme].secondaryOnBackground;
    self.bottomTipsLabel.textColor = [self getCurrentTheme].secondaryOnBackground;
    self.view.backgroundColor = [self getCurrentTheme].background;
}

- (void)setupUI {
    BOOL isCustomBackItem = NO;
    if (self.PINSetType != PINSetTypeVerifyFirstSetNewPIN && self.PINSetType != PINSetTypeVerifyFirstCheckSetNewPIN) {
        if (SCREEN_HEIGHT == 480) {
            self.titleLabelTopLayoutConstraint.constant = -20;
        }
    }
    
    self.backupTipsLabel.text = NSLocalizedProfile(@"be_sure_to_back_up_your_password_properly");

    if (self.PINSetType == PINSetTypeVerifyOldPIN) {
        self.titleLabel.hidden = YES;
        self.bottomTipsLabel.hidden = YES;
        self.subTitleLabel.text = NSLocalizedProfile(@"set_a_6_digit_pin");//
        self.navigationItem.title = NSLocalizedProfile(@"reset_pin");
        self.backupTipsLabel.hidden = YES;
        self.backupTipsImageView.hidden = YES;
        isCustomBackItem = YES;
    } else if (self.PINSetType == PINSetTypeVerifySetNewPIN) {
        self.titleLabel.hidden = YES;
        self.bottomTipsLabel.hidden = NO;
        self.forgotPINBtn.hidden = YES;
        self.subTitleLabel.text = NSLocalizedProfile(@"set_a_6_digit_pin");//
        self.navigationItem.title = NSLocalizedProfile(@"reset_pin");
        isCustomBackItem = YES;
    } else if (self.PINSetType == PINResetTypeVerifyPIN || self.PINSetType == PINResetTypeMustVerifyPIN) {
        self.titleLabel.hidden = YES;
        self.bottomTipsLabel.hidden = NO;
        self.forgotPINBtn.hidden = YES;
        self.subTitleLabel.text = NSLocalizedProfile(@"set_a_6_digit_pin");//
        self.navigationItem.title = NSLocalizedProfile(@"reset_pin");
        self.backupTipsLabel.text = NSLocalizedProfile(@"make_sure_to_keep_your_pin_safe");
        isCustomBackItem = (self.PINSetType == PINResetTypeVerifyPIN) ? YES : NO;
    } else if (self.PINSetType == PINSetTypeVerifyCheckSetNewPIN) {
        self.titleLabel.hidden = YES;
        self.bottomTipsLabel.hidden = YES;
        self.forgotPINBtn.hidden = YES;
        self.subTitleLabel.text = NSLocalizedProfile(@"set_a_6_digit_pin");//
        self.navigationItem.title = NSLocalizedProfile(@"reset_pin");
        isCustomBackItem = YES;
    } else if (self.PINSetType == PINSetTypeVerifyReSetNewPIN) {
        self.titleLabel.hidden = YES;
        self.forgotPINBtn.hidden = YES;
        self.navigationItem.title = NSLocalizedProfile(@"set_pin");
        self.subTitleLabel.text = NSLocalizedProfile(@"please_enter_new_pin");
        self.backupTipsLabel.hidden = YES;
        self.backupTipsImageView.hidden = YES;
        isCustomBackItem = YES;
    } else if (self.PINSetType == PINSetTypeVerifyCheckReSetNewPIN || self.PINSetType == PINSetTypeMustVerifyCheckReSetNewPIN) {
        self.titleLabel.hidden = YES;
        self.forgotPINBtn.hidden = YES;
        self.navigationItem.title = NSLocalizedProfile(@"reset_pin");
        self.subTitleLabel.text = NSLocalizedProfile(@"reenter_pin");
        self.backupTipsLabel.text = NSLocalizedProfile(@"make_sure_to_keep_your_pin_safe");
        self.backupTipsLabel.hidden = NO;
        self.backupTipsImageView.hidden = NO;
        self.bottomTipsLabel.hidden = NO;
        if (self.PINSetType == PINSetTypeVerifyCheckReSetNewPIN) {
            isCustomBackItem = YES;
            self.navigationItem.hidesBackButton = NO;
        }else{
            isCustomBackItem = NO;
            self.navigationItem.hidesBackButton = YES;
        }
    } else if (self.PINSetType == PINSetTypeVerifyFirstSetNewPIN) {
        self.titleLabel.hidden = NO;
        self.forgotPINBtn.hidden = YES;
        self.backupTipsLabel.hidden = NO;
        self.backupTipsImageView.hidden = NO;
        self.navigationItem.title = NSLocalizedProfile(@"set_pin");
        self.subTitleLabel.text = NSLocalizedProfile(@"set_a_6_digit_pin");//
    } else if (self.PINSetType == PINSetTypeVerifyFirstCheckSetNewPIN) {
        self.titleLabel.hidden = YES;
        self.forgotPINBtn.hidden = YES;
        self.subTitleLabel.text = NSLocalizedProfile(@"reenter_pin");
        self.bottomTipsLabel.hidden = YES;
        self.navigationItem.title = NSLocalizedProfile(@"set_pin");
        isCustomBackItem = YES;
    }
    if (isCustomBackItem) {
        //Back to confirm
        UIImage *image = [UIImage systemImageNamed:@"chevron.left"];
        if (self.PINSetType == PINSetTypeVerifyFirstCheckSetNewPIN) {
            image = [UIImage createImageWithColor:[UIColor whiteColor]];
        }
        UIBarButtonItem *leftBackBarItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(confirmBack)];
        self.navigationItem.leftBarButtonItem = leftBackBarItem;
    }

    self.textField.textColor = [UIColor clearColor];
    self.textField.tintColor = [UIColor clearColor];
    self.textField.font = UIFontMake(0);
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.textField.secureTextEntry = YES;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.enablesReturnKeyAutomatically = YES;
    self.textField.clearsOnBeginEditing = NO;
    [self.textField addTarget:self action:@selector(textDidChanged:) forControlEvents:UIControlEventEditingChanged];

    self.collectionView.backgroundColor = [UIColor clearColor];
    CGFloat minimumInteritemSpacing = 16;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = minimumInteritemSpacing;
    [self.collectionView registerClass:[FPPasswordDotCell class] forCellWithReuseIdentifier:@"FPPasswordDotCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat h = CGRectGetHeight(collectionView.frame);
    return CGSizeMake(h, h);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FPPasswordDotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FPPasswordDotCell class]) forIndexPath:indexPath];
    UIImage *image;
    if (self.textField.text.length > 0) {
        if (indexPath.item <= self.textField.text.length - 1) {
            image = [UIImage imageNamed:@"pic_pin_input"];
            cell.imageView.tintColor = [self getCurrentTheme].passwordDotFilled;
        } else {
            image = [UIImage imageNamed:@"pic_pin_input_none"];
            cell.imageView.tintColor = [self getCurrentTheme].passwordDot;
        }
    } else {
        image = [UIImage imageNamed:@"pic_pin_input_none"];
        cell.imageView.tintColor = [self getCurrentTheme].passwordDot;
    }
    cell.imageView.image = image;
    return cell;
}

- (BOOL)checkPIN {
    NSString *str = self.textField.text;
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    for (NSInteger i = 0; i < 10; i++) {
        NSString *s = [NSString stringWithFormat:@"%zd%zd%zd%zd%zd%zd", i, i, i, i, i, i];
        [array addObject:s];
    }
    if ([array containsObject:str]) {
        self.textField.text = nil;
        [self.collectionView reloadData];
        [MBHUD showInView:self.view withDetailTitle:NSLocalizedProfile(@"pin_cannot_be_repeated") withType:HUDTypeError];
        return NO;
    } else {
        NSString *tem;
        BOOL isContinuousIncreasing = YES;
        BOOL isContinuousDiminishing = YES;
        for (NSInteger i = 0; i < str.length; i++) {
            NSString *current = [str substringWithRange:NSMakeRange(i, 1)];
            if (i > 0) {
                NSString *last = [tem copy];
                if (([last integerValue] + 1) == [current integerValue]) {
                    isContinuousIncreasing = YES;
                } else {
                    isContinuousIncreasing = NO;
                    break;
                }
            }
            tem = [current copy];
        }

        for (NSInteger i = 0; i < str.length; i++) {
            NSString *current = [str substringWithRange:NSMakeRange(i, 1)];
            if (i > 0) {
                NSString *last = [tem copy];
                if (([last integerValue] - 1) == [current integerValue]) {
                    isContinuousDiminishing = YES;
                } else {
                    isContinuousDiminishing = NO;
                    break;
                }
            }
            tem = [current copy];
        }
        if (isContinuousIncreasing || isContinuousDiminishing) {
            self.textField.text = nil;
            [self.collectionView reloadData];
            [MBHUD showInView:self.view withDetailTitle:NSLocalizedProfile(@"pin_cannot_be_sequencial") withType:HUDTypeError];
            return NO;
        }

    }
    return YES;
}

- (void)textDidChanged:(UITextField *)textField {
    [self.collectionView reloadData];
    if (textField.text.length == 6) {
        switch (self.PINSetType) {
            case PINSetTypeVerifyOldPIN: {
                NSString *pin = [AES128 encryptAES128:textField.text];
                [ProfileHelperModel verifyPinOnUpdatePin:pin completeBlock:^(BOOL result, NSInteger errorCode, NSString *errorMessage) {
                    if (result) {
                        if (![NSString textIsEmpty:textField.text]) {
                            [self.router pushToPinSetVerifyNewPinWithOldPin:self.textField.text];
                        }
                    } else {
                        if (errorCode == 10013) {
                            //The PIN code has been locked and will be automatically unlocked after 1 hour.
                            //If you forget the PIN code, please contact customer service to appeal
                            AlertActionItem *cancelItem = [AlertActionItem defaultCancelItemWithHandler:^{
                                [self.textField becomeFirstResponder];
                            }];
                            AlertActionItem *okItem = [AlertActionItem actionWithTitle:NSLocalizedProfile(@"contact") style:(AlertActionStyleDefault) handler:^{
                                [[NSNotificationCenter defaultCenter] postNotificationName:kFPContactCSNotification object:nil];
                                [self.router pushToHelpFeedback];
                            }];
                            [self showAlertWithTitle:@""
                                             message:errorMessage
                                             actions:[NSArray arrayWithObjects:cancelItem, okItem, nil]];
                        } else {
                            [self showAlertWithPresenter:self errorMessage:errorMessage];
                        }
                        
                        self.textField.text = nil;
                        [self.collectionView reloadData];
                    }
                }];
            }
                break;
                
            case PINResetTypeVerifyPIN :
            case PINResetTypeMustVerifyPIN: {
                if (![self checkPIN]) {
                    return;
                }
                if (![NSString textIsEmpty:textField.text]) {
                    BOOL isMustVerifyReset = (self.PINSetType == PINResetTypeVerifyPIN) ? NO : YES;
                    [self.router pushToPinSetVerifyCheckReSetNewPINWith:self.textField.text forVerificationtype:isMustVerifyReset];
                }
            }
                break;
            case PINSetTypeVerifySetNewPIN: {
                if (![self checkPIN]) {
                    return;
                }
                [self.router pushToPinSetWith:self.pinCode
                                  withPinText:self.textField.text
                                   withOldPin:self.oldPin
                                      smsCode:self.smsCode];
            }
                break;
            case PINSetTypeVerifyCheckSetNewPIN: {
                if (![self checkPIN]) {
                    return;
                }
                if (![textField.text isEqualToString:self.pinText]) {
                    [MBHUD showInView:self.view.window withDetailTitle:NSLocalizedProfile(@"pin_doesnt_match_reenter") withType:HUDTypeError];
                    [self.router clearThePinAndPop];
                    return;
                }
                [self presentSafeAuth];
            }
                break;
            case PINSetTypeVerifyReSetNewPIN: {
                if (![self checkPIN]) {
                    return;
                }
                if (![NSString textIsEmpty:textField.text]) {
                    [self.router pushToPinSetVerifyCheckReSetNewPINWith:textField.text forVerificationtype:NO];
                }
            }
                break;
            case PINSetTypeVerifyCheckReSetNewPIN:
            case PINSetTypeMustVerifyCheckReSetNewPIN:
            {
                
                if (![textField.text isEqualToString:self.pinCode]) {
                    [MBHUD showInView:self.view.window withDetailTitle:NSLocalizedProfile(@"pin_doesnt_match_reenter") withType:HUDTypeError];
                    [self.router clearThePinAndPop];
                    return;
                }
                if (![self checkPIN]) {
                    return;
                }
                [self presentSafeAuth];
                
            }
                break;
                
            case PINSetTypeVerifyFirstSetNewPIN: {
                if (![self checkPIN]) {
                    return;
                }
                if (![NSString textIsEmpty:textField.text]) {
                    [self.router pushToPinSetWithVerifyFirstCheckSetNewPIN:textField.text];
                }
            }
                break;
            case PINSetTypeVerifyFirstCheckSetNewPIN: {
                if (![self checkPIN]) {
                    return;
                }
                if (![textField.text isEqualToString:self.pinCode]) {
                    [MBHUD showInView:self.view.window withDetailTitle:NSLocalizedProfile(@"pin_doesnt_match_reenter") withType:HUDTypeError];
                    [self.router clearThePinAndPop];
                    return;
                }
                [ProfileHelperModel securitySetPin:[AES128 encryptAES128:textField.text] completeBlock:^(BOOL result, NSInteger errorCode, NSString *errorMessage) {
                    if (result) {
                        [textField resignFirstResponder];
                        [self updateTheUserPinStatus];
                        [self.router dismissOrClose];
                    } else {
                        [self showAlertWithPresenter:self errorMessage:errorMessage];
                        [self.router clearThePinAndPop];
                    }
                }];
            }
                break;
            default:
                break;
        }
    }
    if (textField.text.length > 6) {
        textField.text = [textField.text substringToIndex:6];
    }
}

- (void)updateTheUserPinStatus {
    [GCUserManager manager].user.isPinSet = [NSNumber numberWithBool:YES];
}

- (void)presentSafeAuth {
    MJWeakSelf
    SafeAuthViewController *safeAuthVC = [self.router presentToSafeAuthWithAllWithDismissEvent:^{
        AlertActionItem *cancelItem = [AlertActionItem defaultCancelItem];
        
        AlertActionItem *okItem = [AlertActionItem actionWithTitle:NSLocalizedProfile(@"confirm") style:(AlertActionStyleDefault) handler:^{
            [weakSelf.safeAuthVC hideSafeVC:NO];
            [weakSelf.router dismiss];
        }];

        [weakSelf.safeAuthVC showAlertWithTitle:@""
                         message:NSLocalizedProfile(@"resetPin.safeAuth.dismiss.alert.message")
                         actions:[NSArray arrayWithObjects:cancelItem, okItem, nil]];
    }];
    self.safeAuthVC = safeAuthVC;
    self.safeAuthVC.safeDelegate = self;
}

- (void)confirmBack {
    if (self.PINSetType == PINSetTypeVerifyFirstSetNewPIN || self.PINSetType == PINSetTypeVerifyFirstCheckSetNewPIN) {
        return;
    }
    
    if (self.PINSetType == PINSetTypeVerifyOldPIN) {
        [self.router dismissOrClose];
        return;
    }

    if (self.PINSetType == PINSetTypeVerifyReSetNewPIN) {
        [self.router dismissOrClose];
        return;
    }
    
    AlertActionItem *cancelItem = [AlertActionItem defaultCancelItemWithHandler:^{
        [self.textField becomeFirstResponder];
    }];
    
    AlertActionItem *okItem = [AlertActionItem actionWithTitle:NSLocalizedProfile(@"confirm") style:(AlertActionStyleDefault) handler:^{
        [self.router dismissOrClose];
    }];

    [self showAlertWithTitle:@""
                     message:NSLocalizedProfile(@"want_to_quit")
                     actions:[NSArray arrayWithObjects:cancelItem, okItem, nil]];
}

- (void)clearPIN {
    self.textField.text = nil;
    [self.collectionView reloadData];
}

- (void)finishWithSMSCode:(NSString *)smsCode andEmailCode:(NSString *)emailCode andGoogleCode:(NSString *)googleCode {
    if (self.PINSetType == PINSetTypeVerifyCheckSetNewPIN) {
        [self.safeAuthVC hideSafeVC:NO];
        NSString *newPin = [AES128 encryptAES128:self.textField.text];
        NSString *oldPin = [AES128 encryptAES128:self.oldPin];
        [ProfileHelperModel updatePinWithNewPin:newPin oldPin:oldPin completeBlock:^(BOOL result1, NSInteger errorCode1, NSString *errorMessage1) {
            if (result1) {
                [MBHUD showInView:self.view.window withDetailTitle:NSLocalizedDefault(@"change_success") withType:HUDTypeFailWithoutImage];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.router dismiss];
                });
            } else {
                if (errorCode1 == 10015) {
                    [self.router clearThePinAndPop];
                }
                [self showAlertWithPresenter:self errorMessage:errorMessage1];
            }
        }];
    }
}

- (void)finishSafeAuthVC:(SafeAuthViewController *)vc andLv1:(NSString *)lv1 andSmsCode:(NSString *)smsCode andEmailCode:(NSString *)emailCode andGoogleCode:(NSString *)googleCode {
    if (self.PINSetType == PINSetTypeVerifyCheckReSetNewPIN || self.PINSetType == PINSetTypeMustVerifyCheckReSetNewPIN) {
        NSString *newPin = [AES128 encryptAES128:self.textField.text];
        [ProfileHelperModel resetPinWithNewPin:newPin lv1Number:lv1 smsCode:smsCode emailCode:emailCode googleCode:googleCode completeBlock:^(BOOL result1, NSInteger errorCode, NSString *errorMessage) {
            if (result1) {
                if ([[[HPAYBioAuth sharedInstance] getBioAuthOn] boolValue]){
                    [[HPAYBioAuth sharedInstance] savePIN:newPin];
                }
                [vc hideSafeVC:NO];
                [self.router dismiss];
            } else {
                [self showAlertWithPresenter:vc errorMessage:errorMessage];
            }
        }];
    }
}

- (void)finishSafeAuthVC:(SafeAuthViewController *)vc andEmailCode:(NSString *)emailCode {
    
    NSString *newPin = [AES128 encryptAES128:self.textField.text];
    WS(weakSelf);
    [ProfileHelperModel resetPinWithNewPin:newPin lv1Number:nil smsCode:nil emailCode:emailCode googleCode:nil completeBlock:^(BOOL result1, NSInteger errorCode, NSString *errorMessage) {
        if (result1) {
            if ([[[HPAYBioAuth sharedInstance] getBioAuthOn] boolValue]){
                [[HPAYBioAuth sharedInstance] savePIN:newPin];
            }
            [vc hideSafeVC:NO];
            [weakSelf dismiss];
        } else {
            [weakSelf showAlertWithPresenter:vc errorMessage:errorMessage];
        }
    }];
}

- (void)dismiss{
    [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:@"Disable_Pinverification"];
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)showAlertWithPresenter:(UIViewController *)presenter errorMessage:(NSString *)errorMessage{
    AlertActionItem *okItem = [AlertActionItem defaultOKItem];
    [presenter showAlertWithTitle:@""
                     message:errorMessage
                     actions:[NSArray arrayWithObject:okItem]];
}

@end
