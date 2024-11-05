#import "FPTabBarController.h"
#import "FPTabBar.h"
#import "FPNavigationController.h"
#import "AppDelegate.h"
#import "StatementViewController.h"
#import "HomeViewController.h"
#import "ProfileViewController.h"
#import "StatementDetailViewController.h"
#import "FPUtils.h"
#import "ProfileHelperModel.h"
#import "FPWKWebViewController.h"
#import "HimalayaAuthManager.h"
#import "HPDeeplinkData.h"
#import "HPDeeplinkNavigator.h"
#import "VerifyPinViewController.h"
#import "HimalayaAuthKeychainManager.h"
#import "UIViewController+CurrentViewController.h"
#import "PINSetViewController.h"
#import "ProfileRouter.h"
#import "HPNavigationRouter.h"
#import "FPNavigationController.h"
#import "HimalayaAuthManager.h"
#import "HimalayaPayAPIManager.h"
#import "FPViewController.h"
#import "HimalayaAuthKeychainManager.h"
#import "UserConfigResponse.h"
#import "UIViewController+ThemeManager.h"
#import "HPAYAnalytics.h"

@interface FPTabBarController () <FPTabBarDelegate>

@property(nonatomic, strong) FPTabBar *wcTabBar;
@property(nonatomic, strong) UIView *wcTabBarBottomView;
@property(strong, nonatomic) ProfileRouter<ProfileRouterInterface> *router;
@end

@implementation FPTabBarController

- (ProfileRouter<ProfileRouterInterface> *)router {
    if (_router == nil) {
        _router = [[ProfileRouter alloc] init];
        _router.currentControllerDelegate = self;
        _router.navigationDelegate = self.navigationController;
        _router.tabBarControllerDelegate = self.tabBarController;
    }
    return _router;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewControllers];
    self.wcTabBar.delegate = self;
    self.selectedIndex = 0;
    [self setupObservers];
    [self applyTheme];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self handleDeeplinkIfExists];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (kDevice_Is_iPhoneX) {
        CGRect frame = self.tabBar.frame;
        self.tabBar.frame = CGRectMake(frame.origin.x, SCREEN_HEIGHT - frame.size.height, frame.size.width, frame.size.height);
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self applyTheme];
}

-(void)applyTheme{
    id<ThemeProtocol> theme = [self getCurrentTheme];
   
    self.tabBar.translucent = NO;
    self.tabBar.shadowImage = [UIImage new];
    self.wcTabBar.backgroundColor = theme.surface;
    self.wcTabBarBottomView.backgroundColor = theme.surface;
    [UITabBar appearance].translucent = NO;
}

- (void)setupObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenshotDetected:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeeplinkIfExists) name:kOpenDeeplink object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
            selector:@selector(loadStatementViewController:)
            name:@"LoadStatementsNotification"
            object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languagePressed) name:@"ShowLanguageChangeMenu" object:nil];
}

- (IBAction)languagePressed {
    UIAlertController *alertController = [UIAlertController
      alertControllerWithTitle:NSLocalizedString(@"profile.change_language.alert.title", @"")
      message:nil
      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"biometric.turnedoff.alert.cancel", @"") style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *engAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"profile.change_language.restart.alert.en", @"") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        [self changeLanguage:@"en"];
        
    }];
    
    UIAlertAction *sCNAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"profile.change_language.restart.alert.zh-Hans", @"") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        [self changeLanguage:@"zh-Hans"];
        
    }];
  
    [alertController addAction:dismissAction];
    [alertController addAction:engAction];
    [alertController addAction:sCNAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void) changeLanguage:(NSString*)new_lang {
    NSArray *languages = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
    if ([languages count] == 0) {
        return;
    }
    
    if ([new_lang isEqualToString:languages[0]]){
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:new_lang, nil] forKey:@"AppleLanguages"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"languageChanged" object:nil];
    
    [self showAlertAboutRestartRequired];
}

- (void)showAlertAboutRestartRequired {
    UIAlertController *alertController = [UIAlertController
      alertControllerWithTitle:NSLocalizedString(@"profile.change_language.restart.alert.title", @"")
      message:NSLocalizedString(@"profile.change_language.restart.alert.desc", @"")
      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *restart = [UIAlertAction actionWithTitle:NSLocalizedString(@"profile.change_language.restart.alert.restart", @"") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        exit(0);
        
    }];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"profile.change_language.restart.alert.later", @"") style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:restart];
    [alertController addAction:dismissAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)handleDeeplinkIfExists{
    if ([self shouldHandleDeeplink]){
        HPDeeplinkData *deeplink = [HPDeeplinkData retrieveFromLocal];
        if (deeplink){
            [deeplink clearLocal];
            [[HPDeeplinkNavigator sharedInstance] proceedToDeeplinkWithData:deeplink];
        }
    }
}

- (BOOL)shouldHandleDeeplink{
    UIViewController *vc = [UIViewController getCurrentViewController];
    return [self isAuthorized] && !([vc isKindOfClass:[VerifyPinViewController class]] || [vc isKindOfClass:[PINSetViewController class]]);
}

- (BOOL)isAuthorized{
    return [[HimalayaAuthManager sharedManager] isAuthorized];
}

- (HCIdentityUser *)userInfo{
    NSError *error;
    return [HimalayaAuthKeychainManager loadUserDataWithError:&error];
}

- (BOOL)isUserPinSet{
    HCIdentityUser *response = [self userInfo];
    return response.isPinSet.boolValue;
}

- (void)appWillEnterForeground{
    NSLog(@"WILL ENTER FOREGROUND");
    if ([self isAuthorized] && [self isUserPinSet] && [self shouldShowPinVerification]){
        UIViewController *currentVC = [UIViewController getCurrentViewController];
        [currentVC showVerifyPinVC];
    }
}

/*
    This method is to check the time difference b/w
    background and foreground
*/

-(BOOL)shouldShowPinVerification {
    return true;
    
    NSDate *backgroundTime = [[NSUserDefaults standardUserDefaults] objectForKey:KPinVerifyTime];
    if (backgroundTime) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:KPinVerifyTime];
        NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:backgroundTime];
        
        if (secondsBetween > 20 && ![[[NSUserDefaults standardUserDefaults] objectForKey:@"Disable_Pinverification"] isEqualToString:@"YES"] ) {
            return true;
        }
    }
    return false;
}

- (void)setupViewControllers {
    HomeViewController *homeVC = (HomeViewController *) [SB_HOME instantiateViewControllerWithIdentifier:@"HomeViewController"];
    homeVC.title = @"";
    FPNavigationController *navHome = [[FPNavigationController alloc] initWithRootViewController:homeVC];
    ProfileViewController *profileVC = (ProfileViewController *) [SB_PROFILE instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    profileVC.title = @"";
    FPNavigationController *navProfile = [[FPNavigationController alloc] initWithRootViewController:profileVC];
    StatementViewController *statementVC = (StatementViewController *) [SB_STATEMENT instantiateViewControllerWithIdentifier:@"StatementViewController"];
    statementVC.title = @"";
    FPNavigationController *navStatement = [[FPNavigationController alloc] initWithRootViewController:statementVC];
    self.viewControllers = @[navHome, navStatement, navProfile];
}

- (FPTabBar *)wcTabBar {
    if (_wcTabBar == nil) {
        self.wcTabBar = [[FPTabBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tabBar.frame), (self.tabBar.frame.size.height))];
        _wcTabBarBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.wcTabBar.frame),  CGRectGetWidth(self.tabBar.frame), (self.tabBar.frame.size.height + 40))];
        [self.tabBar addSubview:self.wcTabBar];
        [self.tabBar addSubview:self.wcTabBarBottomView];
    }
    return _wcTabBar;
}

#pragma mark - WCTabBarDelegate

- (void)changeTabByIndex:(NSInteger)fromTabIndex toTabByIndex:(NSInteger)toTabIndex {
    self.selectedIndex = toTabIndex;
    
    if (fromTabIndex == toTabIndex) return;
    
    if (toTabIndex == 0){
        [[HPAYAnalytics sharedInstance] track:@"tabbar_home_tap"];
    }
    else if (toTabIndex == 1){
        [[HPAYAnalytics sharedInstance] track:@"tabbar_transactions_tap"];
    }else if (toTabIndex == 2){
        [[HPAYAnalytics sharedInstance] track:@"tabbar_profile_tap"];
    }
}

#pragma mark - Change selected tab programmatically

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if(selectedIndex == 1) {
        [self loadStatementViewController:nil];
    }
    else{
        [super setSelectedIndex:selectedIndex];
    }
}

#pragma mark - Login utilities

- (void)loginAction {
    [HimalayaAuthManager sharedManager].stateDelegate = self;
    [[HimalayaAuthManager sharedManager] authorizeWithPresenter:self];
}

- (BOOL)shouldContinueClickWithKycStatus:(BOOL)requireKyc {
    if (![self isAuthorized]){
        [self loginAction];
        return NO;
    }
    
    if (requireKyc){
        return [self isKycVerified];
    }else{
        return YES;
    }
}

- (UserConfigResponse *)userConfig{
    NSError *error;
    return [HimalayaAuthKeychainManager loadUserConfigToKeychain:&error];
}

-(void) loadStatementViewController:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"LoadStatementsNotification"]){
        NSString *LOADED_FROM_NOTIFICATION = @"loaded_fromnotification";
        [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:LOADED_FROM_NOTIFICATION];
    }
    if ([self shouldContinueClickWithKycStatus:YES]) {
        StatementViewController *statementVC = (StatementViewController *) [SB_STATEMENT instantiateViewControllerWithIdentifier:@"StatementViewController"];
        statementVC.title = NSLocalizedDefault(@"transactionHistoryTitle");
        FPNavigationController *navStatement = [[FPNavigationController alloc] initWithRootViewController:statementVC];
        [super presentViewController:navStatement animated:YES completion:nil];
    }
}

- (BOOL)isKycVerified{
    if (![self userConfig].isKYCVerified.boolValue) {
        [self showKycAlert];
        return NO;
    }else{
        return YES;
    }
}

#pragma mark - Status bar appearance

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Detect Screenshot target

- (void)screenshotDetected:(NSNotification *)notification {
    NSSet<UIScene *> *connectedScenes = [[UIApplication sharedApplication] connectedScenes];
    UIWindowScene *windowScene = (UIWindowScene*)[connectedScenes allObjects].firstObject;
    if (windowScene && windowScene.windows.count > 0) {
        UIWindow *window = windowScene.windows[0];
        MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:window animated:YES];
        hud.label.text = NSLocalizedDefault(@"screenshotTakenWarningMessage");
        hud.label.numberOfLines = 0;
        hud.label.adjustsFontSizeToFitWidth = NO;
        hud.mode = MBProgressHUDModeText;
        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        [hud showAnimated:YES];
        [hud hideAnimated:YES afterDelay:3.0];
    }
}

@end
