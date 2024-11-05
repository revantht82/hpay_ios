#import "HelpFeedbackListViewController.h"
#import "SettingsRouter.h"
#import "ProfileRouter.h"
#import "FetchUserConfigAndInfoUseCase.h"
#import "UserConfigResponse.h"
#import "HimalayaAuthKeychainManager.h"

@interface HelpFeedbackListViewController ()

@property (weak, nonatomic) IBOutlet UIView *userAgreementDividerView;
@property (weak, nonatomic) IBOutlet UIView *customerServiceDividerView;
@property (weak, nonatomic) IBOutlet UIView *privacyPolicyDividerView;

@property (weak, nonatomic) IBOutlet UIView *userAgreementView;
@property(weak, nonatomic) IBOutlet UILabel *userAgreementLabel;
@property(weak, nonatomic) IBOutlet UIImageView *userAgreementRightImageView;

@property (weak, nonatomic) IBOutlet UIView *privacyPolicyView;
@property(weak, nonatomic) IBOutlet UILabel *privacyPolicyLabel;
@property(weak, nonatomic) IBOutlet UIImageView *privacyPolicyRightImageView;


@property (weak, nonatomic) IBOutlet UIView *customerServiceView;
@property(weak, nonatomic) IBOutlet UILabel *customerServiceLabel;
@property(weak, nonatomic) IBOutlet UIImageView *customerServiceRightImageView;

@property(weak, nonatomic) IBOutlet UILabel *versionLabel;
@property(weak, nonatomic) IBOutlet UILabel *environmentLabel;
@property(strong, nonatomic) SettingsRouter<SettingsRouterInterface> *router;
@property(strong, nonatomic) ProfileRouter<ProfileRouterInterface> *profileRouter;

@property (nonatomic) FetchUserConfigAndInfoUseCase *fetchUserConfigAndInfoUseCase;
@end

@implementation HelpFeedbackListViewController

- (SettingsRouter<SettingsRouterInterface> *)router {
    if (_router == nil) {
        _router = [[SettingsRouter alloc] init];
        _router.currentControllerDelegate = self;
        _router.navigationDelegate = self.navigationController;
        _router.tabBarControllerDelegate = self.tabBarController;
    }
    return _router;
}

- (ProfileRouter<ProfileRouterInterface> *)profileRouter {
    if (_profileRouter == nil) {
        _profileRouter = [[ProfileRouter alloc] init];
        _profileRouter.currentControllerDelegate = self;
        _profileRouter.navigationDelegate = self.navigationController;
        _profileRouter.tabBarControllerDelegate = self.tabBarController;
    }
    return _profileRouter;
}

- (UserConfigResponse *)userConfig{
    NSError *error;
    return [HimalayaAuthKeychainManager loadUserConfigToKeychain:&error];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureVersionLabel];
    
    self.navigationItem.title = NSLocalizedDefault(@"help_and_feedback");
    self.navigationItem.backButtonTitle = @" ";
    
    _fetchUserConfigAndInfoUseCase = [[FetchUserConfigAndInfoUseCase alloc] init];
    NSString *termsurl = [self userConfig].termsUrl;
        
    if(![GCUserManager manager].isLogin){
        self.userAgreementView.hidden=true;
        self.privacyPolicyView.hidden=true;
    }

    if([termsurl length]==0)
   {
       self.userAgreementView.hidden=true;
       self.privacyPolicyView.hidden=true;
   }
    
    [self applyTheme];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self applyTheme];
}

- (void)applyTheme{
    self.view.backgroundColor = [self getCurrentTheme].background;
    
    self.userAgreementDividerView.backgroundColor = [self getCurrentTheme].verticalDivider;
    self.privacyPolicyDividerView.backgroundColor = [self getCurrentTheme].verticalDivider;
    self.customerServiceDividerView.backgroundColor = [self getCurrentTheme].verticalDivider;
    
    self.userAgreementView.backgroundColor = [self getCurrentTheme].surface;
    self.userAgreementLabel.textColor = [self getCurrentTheme].primaryOnSurface;
    self.userAgreementRightImageView.tintColor = [self getCurrentTheme].primaryOnSurface;
    
    self.privacyPolicyView.backgroundColor = [self getCurrentTheme].surface;
    self.privacyPolicyLabel.textColor = [self getCurrentTheme].primaryOnSurface;
    self.privacyPolicyRightImageView.tintColor = [self getCurrentTheme].primaryOnSurface;
    
    self.customerServiceView.backgroundColor = [self getCurrentTheme].surface;
    self.customerServiceLabel.textColor = [self getCurrentTheme].primaryOnSurface;
    self.customerServiceRightImageView.tintColor = [self getCurrentTheme].primaryOnSurface;
}

#pragma mark - Actions

- (IBAction)userAgreementPressed:(id)sender {
    [self.router pushToAgreementPrivacyForEULA];
}

- (IBAction)privaycPolicyPressed:(id)sender {
    [self.router pushToAgreementPrivacyDataPolicy];
}

- (IBAction)contactCustomerServicePressed:(id)sender {
    [self.router pushToSupport];
}

#pragma mark - Version Number

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
