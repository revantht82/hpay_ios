#import "SettingViewController.h"
#import "LoginHelperModel.h"
#import "SettingsRouter.h"

@interface SettingViewController ()
@property(weak, nonatomic) IBOutlet UILabel *languageLabel;
@property(weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property(strong, nonatomic) SettingsRouter<SettingsRouterInterface> *router;
@property(weak, nonatomic) IBOutlet UILabel *versionLabel;
@property(weak, nonatomic) IBOutlet UILabel *environmentLabel;
@end

@implementation SettingViewController

- (SettingsRouter<SettingsRouterInterface> *)router {
    if (_router == nil) {
        _router = [[SettingsRouter alloc] init];
        _router.currentControllerDelegate = self;
        _router.navigationDelegate = self.navigationController;
        _router.tabBarControllerDelegate = self.tabBarController;
    }
    return _router;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![GCUserManager manager].isLogin) {
        self.logoutBtn.hidden = YES;
    }
    [self configureVersionLabel];
}

/// Display language
- (IBAction)languageAction:(UITapGestureRecognizer *)sender {
}

/// Use Agreement
- (IBAction)agreementAction:(UITapGestureRecognizer *)sender {
    [self.router pushToAgreementPrivacyForEULA];
}

/// Privacy Policy
- (IBAction)privacypolicyAction:(UITapGestureRecognizer *)sender {
    [self.router pushToAgreementPrivacyDataPolicy];
}

/// About us
- (IBAction)aboutusAction:(UITapGestureRecognizer *)sender {
}

- (IBAction)logoutAction:(UIButton *)sender {
    AlertActionItem *cancelItem = [AlertActionItem defaultCancelItem];
    AlertActionItem *okItem = [AlertActionItem actionWithTitle:NSLocalizedProfile(@"confirm") style:(AlertActionStyleDefault) handler:^{
        [LoginHelperModel logoutCompleteBlock:^(BOOL isSuccess, NSString *message) {
        }];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[GCUserManager manager] logOut];
            [[NSNotificationCenter defaultCenter] postNotificationName:kLogOutNotification object:nil];
            [self.router updateTheWindowRootAsTabBarWithAnimation];
        });
    }];
    [self showAlertWithTitle:@""
                     message:NSLocalizedProfile(@"log_out_title")
                     actions:[NSArray arrayWithObjects:cancelItem, okItem, nil]];
}

- (void)configureVersionLabel {
    
    NSString *version = [NSString stringWithFormat:@"%@ (%@)", kAppVersion, kAppBulidNumber];
    [self.versionLabel setText:version];
    [self configureEnvironmentLabelWithIsShown:NO];

    [self configureEnvironmentLabelWithIsShown:kShowEnvironmentVariable];

}

- (void)configureEnvironmentLabelWithIsShown:(BOOL)isShown {
    
    [self.environmentLabel setHidden:!isShown];
    
    if (isShown) {
        NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
        [self.environmentLabel setText:bundleId];
    }
}

@end
