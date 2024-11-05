#import "FPKeyBoardManager.h"
#import "MLBPasswordTextField.h"
#import "FPPasswordTextField.h"
#import "UIViewController+CurrentViewController.h"
#import "ProfileHelperModel.h"
#import "HelpFeedbackViewController.h"
#import "PINSetViewController.h"
#import "AppDelegate.h"
#import "HCAmountTextField.h"
#import "HPAYBioAuth.h"

#define kcontentHeight  (SCREEN_HEIGHT==480)?426:(SCREEN_HEIGHT - (227 * layoutHeight()))

@interface FPKeyBoardManager () <MLBPasswordTextFieldDelegate, FPPasswordTextFieldDelegate>
@property(nonatomic, strong) UIView *backgroundView;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UIButton *closeBtn;
@property(nonatomic, strong) UIButton *useBioAuth;
@property(nonatomic, strong) MLBPasswordTextField *mlbPasswordTF;
@property(nonatomic, strong) FPPasswordTextField *fpPasswordTF;
@property(nonatomic, strong) HCAmountTextField *passwordTF;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *subTitleLabel;

@property(nonatomic, assign) CGFloat backgroundAlpha;
@property(nonatomic, assign) CGFloat animationDuration;
@property(nonatomic, assign) FPKeyBoardStyle keyBoardStyle;

@end

@implementation FPKeyBoardManager

#pragma mark - LifeCycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _keyBoardStyle = FPKeyBoardStyleDotImage;
        self.backgroundAlpha = 0.3;
        self.animationDuration = 0.3;
        [self initUI];
    }
    return self;
}

- (instancetype)initWithStyle:(FPKeyBoardStyle)style {
    self = [super init];
    if (self) {
        _keyBoardStyle = style;
    }
    return self;
}

- (void)initUI {
    self.hidden = YES;
    
    [AppDelegate.keyWindow addSubview:self];
    [AppDelegate.keyWindow bringSubviewToFront:self];
    [self addSubview:self.backgroundView];
    
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.closeBtn];
    [self.contentView addSubview:self.useBioAuth];
    [self.titleLabel sizeToFit];
    [self.contentView addSubview:self.titleLabel];
    [self.subTitleLabel sizeToFit];
    [self.contentView addSubview:self.subTitleLabel];
    
    if (self.keyBoardStyle == FPKeyBoardStyleDefault) {
        self.passwordTF = (HCAmountTextField*)self.mlbPasswordTF;
    } else {
        self.passwordTF = (HCAmountTextField*)self.fpPasswordTF;
    }
    [self.contentView addSubview:self.passwordTF];
    
    [self setNeedsUpdateConstraints];
    [self bindObserver];
    [self applyTheme];
    
    if ([[[HPAYBioAuth sharedInstance] getBioAuthOn] boolValue]){
        self.useBioAuth.hidden = NO;
    } else {
        self.useBioAuth.hidden = YES;
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self applyTheme];
}

- (void)applyTheme{
    id<ThemeProtocol> theme = [self getCurrentTheme];
    _contentView.backgroundColor = theme.surface;
    _closeBtn.tintColor = theme.primaryOnSurface;
    _titleLabel.textColor = theme.primaryOnSurface;
    _subTitleLabel.textColor = theme.primaryOnSurface;
    //_useBioAuth.tintColor = theme.primaryOnSurface;
}

- (void)bindObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyBoard) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)updateConstraints {
    
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(AppDelegate.keyWindow);
    }];
    
    [self.backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(kcontentHeight);
        make.top.equalTo(self.mas_bottom);
    }];
    
    [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(48, 48));
        make.top.equalTo(self.contentView.mas_top).with.offset(10);
        make.left.equalTo(self.contentView.mas_left);
    }];
    
    [self.useBioAuth mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(250, 20));
        make.top.equalTo(self.passwordTF.mas_bottom).with.offset(45);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.contentView.mas_top).with.offset(20);
    }];
    
    [self.subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.contentView.mas_top).with.offset(57);
    }];
    
    [self.passwordTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subTitleLabel.mas_bottom).with.offset(43);
        make.width.mas_equalTo(260);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.height.mas_equalTo(30);
    }];
    
    [super updateConstraints];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public Method

- (void)showKeyBoard {
    self.hidden = NO;
    self.closeBtn.userInteractionEnabled = NO;
    
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:self.animationDuration animations:^{
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.mas_equalTo(kcontentHeight);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        [self layoutIfNeeded];
    }                completion:^(BOOL finished) {
        if (finished) {
            if ([[[HPAYBioAuth sharedInstance] getBioAuthOn] boolValue]){
                NSString *pin = [[HPAYBioAuth sharedInstance] getPIN];
                if (pin && ![pin isEqualToString:@""]) {
                    if (self.keyBoardCallBack) {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            self.keyBoardCallBack(pin, self);
                        });
                        
                    }
                }
            }
            [self.passwordTF becomeFirstResponder];
            self.closeBtn.userInteractionEnabled = YES;
        }
    }];
}

+ (void)hideKeyBoard{
    for (NSObject *obj in AppDelegate.keyWindow.subviews) {
        BOOL isKeyboard = [obj isKindOfClass:[FPKeyBoardManager class]];
        if (isKeyboard){
            [(FPKeyBoardManager *)obj hideKeyBoard];
        }
    }
}

 - (void)hideKeyBoard {
    [self.passwordTF resignFirstResponder];
    
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:self.animationDuration animations:^{
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.mas_equalTo(kcontentHeight);
            make.top.equalTo(self.mas_bottom);
        }];
        [self layoutIfNeeded];
    }                completion:^(BOOL finished) {
        
        //Can add condition for "finished" boolean if app would like to follow the dismissal of pin screen or not (below 3 lines of code inside the if loop)
        
        if (self.keyBoardCloseCallBack) {
            self.keyBoardCloseCallBack();
        }
        [self removeFromSuperview];
    }];
}

- (void)clear {
    if (self.keyBoardStyle == FPKeyBoardStyleDefault) {
        [self.mlbPasswordTF mlb_clear];
    } else {
        [self.fpPasswordTF fp_clear];
    }
    
}

- (void) useBiometricPressed {
    NSString *pin = [[HPAYBioAuth sharedInstance] getPIN];
    if (pin && ![pin isEqualToString:@""]) {
        self.keyBoardCallBack(pin, self);
    }
}

#pragma mark - MLBPasswordTextFieldDelegate

- (void)mlb_passwordTextField:(MLBPasswordTextField *)pwdTextField didFilledPassword:(NSString *)password {
    if (self.keyBoardCallBack) {
        self.keyBoardCallBack(password, self);
    }
}

- (void)fp_passwordTextField:(FPPasswordTextField *)pwdTextField didFilledPassword:(NSString *)password {
    if (self.keyBoardCallBack) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.keyBoardCallBack(password, self);
        });
        
    }
}

#pragma mark - Lazy Properties

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = UIFontMake(16);
        _titleLabel.textColor = kDustyColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel new];
        _subTitleLabel.font = UIFontMake(16);
        _subTitleLabel.textColor = kDarkNightColor;
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.text = NSLocalizedProfile(@"please_enter_pin");
    }
    return _subTitleLabel;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.alpha = 0.3;
    }
    return _backgroundView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithPointSize:24];
        [_closeBtn setImage:[UIImage systemImageNamed:@"xmark" withConfiguration:configuration] forState:UIControlStateNormal];
        [_closeBtn setTintColor:kDarkNightColor];
        [_closeBtn addTarget:self action:@selector(hideKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIButton *)useBioAuth {
    if (!_useBioAuth) {
        _useBioAuth = [UIButton buttonWithType:UIButtonTypeSystem];
        [_useBioAuth setTitle:NSLocalizedString(@"biometric.tryagain.button", nil) forState:UIControlStateNormal];
        _useBioAuth.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_useBioAuth addTarget:self action:@selector(useBiometricPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _useBioAuth;
}

- (MLBPasswordTextField *)mlbPasswordTF {
    if (!_mlbPasswordTF) {
        _mlbPasswordTF = [[MLBPasswordTextField alloc] init];
        _mlbPasswordTF.mlb_delegate = self;
        _mlbPasswordTF.mlb_showCursor = NO;
        _mlbPasswordTF.mlb_borderWidth = 1;
    }
    return _mlbPasswordTF;
}

- (FPPasswordTextField *)fpPasswordTF {
    if (!_fpPasswordTF) {
        _fpPasswordTF = [FPPasswordTextField new];
        _fpPasswordTF.fp_delegate = self;
        _fpPasswordTF.backgroundColor = [UIColor clearColor];
    }
    return _fpPasswordTF;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setSubTitle:(NSString *)subTitle {
    _subTitle = subTitle;
    self.subTitleLabel.text = subTitle;
}

@end
