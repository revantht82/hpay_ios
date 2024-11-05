#import "ProfileViewController.h"
#import "ProfileTableViewCell.h"
#import "ProfileTableViewHeader.h"
#import "ProfileRouter.h"
#import "HimalayaAuthKeychainManager.h"
#import "UserConfigResponse.h"
#import "ProfileListItem.h"
#import "UIViewController+ThemeManager.h"
#import "MyQRCodeViewController.h"
#import "ProfileTableViewFooter.h"

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic) NSArray *dataArray;
@property(strong, nonatomic) NSMutableArray<ProfileListItem *> *listItems;
@property(strong, nonatomic) ProfileRouter<ProfileRouterInterface> *router;

@end

@implementation ProfileViewController

- (ProfileRouter<ProfileRouterInterface> *)router {
    if (_router == nil) {
        _router = [[ProfileRouter alloc] init];
        _router.currentControllerDelegate = self;
        _router.navigationDelegate = self.navigationController;
        _router.tabBarControllerDelegate = self.tabBarController;
    }
    return _router;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadItems];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadItems) name:@"languageChanged" object:nil];
}

- (void)loadItems{
    self.listItems = [[NSMutableArray alloc] init];
    [self.listItems addObject:[ProfileListItem itemWithTitle:NSLocalizedDefault(@"profile.table_view.account.title")
                                                    leftIcon:[UIImage imageNamed:@"setting-line-icon"]
                                                clickHandler:^(NSIndexPath * _Nonnull indexPath) {
        if ([self shouldContinueClickWithKycStatus:NO]) {
            [self.router pushWithIdentifierWith:SB_PROFILE_ACCOUNT withIdentifier:@"ProfileAccountViewController" withTitle:self.listItems[indexPath.row].title];
        }
    }]];
    [self.listItems addObject:[ProfileListItem itemWithTitle:NSLocalizedDefault(@"Theme")
                                                    leftIcon:[UIImage imageNamed:@"color-contrast-icon"]
                                                   rightText:[self getSelectedThemeName]
                                                clickHandler:^(NSIndexPath * _Nonnull indexPath) {
        [self selectThemeAction];
    }]];
    [self.listItems addObject:[ProfileListItem itemWithTitle:NSLocalizedDefault(@"profile.interface_language")
                                                    leftIcon:[UIImage imageNamed:@"world-globe-line"]
                                                   rightText:[self setCurrentLanguage]
                                                clickHandler:^(NSIndexPath * _Nonnull indexPath) {
        [self languagePressed];
    }]];
    [self.listItems addObject:[ProfileListItem itemWithTitle:NSLocalizedDefault(@"help_and_feedback")
                                                    leftIcon:[UIImage imageNamed:@"help-line-icon"]
                                                clickHandler:^(NSIndexPath * _Nonnull indexPath) {
        [self.router pushWithIdentifierWith:SB_HELP_FEEDBACK_LIST withIdentifier:@"HelpFeedbackListViewController" withTitle:self.listItems[indexPath.row].title];
    }]];
    
    [self.tableView reloadData];
}

- (void)selectThemeAction {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:NULL message:NULL preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *systemAction = [UIAlertAction actionWithTitle:NSLocalizedDefault(@"System") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self changeThemeWithStyle:UIUserInterfaceStyleUnspecified];
    }];
    UIAlertAction *lightAction = [UIAlertAction actionWithTitle:NSLocalizedDefault(@"Light") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self changeThemeWithStyle:UIUserInterfaceStyleLight];
    }];
    UIAlertAction *darkAction = [UIAlertAction actionWithTitle:NSLocalizedDefault(@"Dark") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self changeThemeWithStyle:UIUserInterfaceStyleDark];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedDefault(@"Cancel") style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {

    }];
    [alertVC addAction:systemAction];
    [alertVC addAction:lightAction];
    [alertVC addAction:darkAction];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:NULL];
}

- (void)changeThemeWithStyle:(UIUserInterfaceStyle)style{
    [self.view setUserInterfaceStyle:style];
    [self applyTheme];
    [self loadItems];
}

- (NSString *)getSelectedThemeName{
    UIUserInterfaceStyle style = [NSUserDefaults.standardUserDefaults integerForKey:kUserInterfaceStyle];
    switch (style) {
        case UIUserInterfaceStyleLight:
            return NSLocalizedDefault(@"Light");
        case UIUserInterfaceStyleDark:
            return NSLocalizedDefault(@"Dark");
        default:
            return NSLocalizedDefault(@"System");
    }
}

- (IBAction)languagePressed {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLanguageChangeMenu" object:nil];
}

-(NSString*)setCurrentLanguage {
    NSArray *languages = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
    
    //NSLog(@"%@", languages);
    
    NSString *languageName = NSLocalizedString(@"profile.change_language.restart.alert.en", @"");
    if ([languages isKindOfClass:[NSArray class]] && languages.count > 0 &&
        [[languages[0] lowercaseString] rangeOfString:@"zh-hans"].location != NSNotFound ){
        languageName = NSLocalizedString(@"profile.change_language.restart.alert.zh-Hans", @"");
    }
    
    return languageName;
}

- (void)setupUI {
    self.fd_prefersNavigationBarHidden = YES;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = nil;
    [self.tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    ProfileTableViewHeader *header = [[NSBundle mainBundle] loadNibNamed:@"ProfileTableViewHeader" owner:nil options:nil].lastObject;
    header.nameBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    WS(weakSelf);
    [header.nameBtn setClickAction:^(UIButton *btn) {
        [weakSelf loginAction];
    }];
    [header.QRCodeBtn setClickAction:^(UIButton *btn) {
        MyQRCodeViewController *statementVC = (MyQRCodeViewController *) [SB_PROFILE_QR_CODE instantiateViewControllerWithIdentifier:@"MyQRCodeViewController"];
        statementVC.title = @"My QR Code";
        FPNavigationController *navStatement = [[FPNavigationController alloc] initWithRootViewController:statementVC];
        [self.router present:navStatement animated:YES completion:nil];
    }];
    self.tableView.tableHeaderView = header;
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tableView);
        make.top.equalTo( self.tableView.mas_top);
        make.height.mas_equalTo(120);
        make.width.equalTo(self.tableView);
    }];
    
    
//    ProfileTableViewFooter *footer = [[NSBundle mainBundle] loadNibNamed:@"ProfileTableViewFooter" owner:nil options:nil].lastObject;
//    footer.HIDLabel.text = @"";
//
//    NSError *error;
//    UserConfigResponse *userConfig = [HimalayaAuthKeychainManager loadUserConfigToKeychain:&error];
//
//    if (!error && ![userConfig.HID isEqualToString:@""] ) {
//        footer.HIDLabel.text = [NSString stringWithFormat:@"HID: %@", userConfig.HID];
//    }
//
//    self.tableView.tableFooterView = footer;
    
    [self applyTheme];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self applyTheme];
}

- (void)applyTheme{
    NSLog(@"%@", [self getCurrentTheme]);
    self.tableView.separatorColor = [self getCurrentTheme].verticalDivider;
    self.tableView.backgroundColor = [self getCurrentTheme].background;
    self.view.backgroundColor = [self getCurrentTheme].toolbar;
    self.tableView.tableFooterView.backgroundColor = [self getCurrentTheme].background;
    
    ProfileTableViewHeader *header = (ProfileTableViewHeader *) self.tableView.tableHeaderView;
    header.QRCodeBtn.tintColor = [self getCurrentTheme].onToolbar;
}

- (void)updateUIWithUserLoggedInStatusWithLoggedInStatus:(BOOL)isLoggedIn {
    ProfileTableViewHeader *header = (ProfileTableViewHeader *) self.tableView.tableHeaderView;
    header.hid.text = @"";
    
    if (isLoggedIn) {
        HCIdentityUser *user = [GCUserManager manager].user;
        header.phoneLabel.hidden = NO;
        header.nameLabel.hidden = NO;
        [header.nameBtn setTitle:@"" forState:UIControlStateNormal];
        header.phoneLabel.text = user.email;
        header.nameLabel.text = user.name;
        if ([user.email isEqualToString:user.name]){
            header.phoneLabel.hidden = YES;
        }
        else if (!user.name || [user.name isEqualToString:@""]){
            header.nameLabel.text = user.email;
            header.phoneLabel.hidden = YES;
        }
        [header.profileImageView setupWithUserName:user.givenName lastName:user.familyName];
        
        NSError *error;
        UserConfigResponse *userConfig = [HimalayaAuthKeychainManager loadUserConfigToKeychain:&error];
        
        if (!error && userConfig.nickname && ![userConfig.nickname isEqualToString:@""] ) {
            header.nameLabel.text = userConfig.nickname;
        }
        
        if (userConfig && userConfig.MyQR && ![userConfig.MyQR isEqualToString:@""]) {
            header.QRCodeBtn.hidden = NO;
        }
        else {
            header.QRCodeBtn.hidden = YES;
        }
        
        if (!error && ![userConfig.HID isEqualToString:@""] ) {
            header.hid.text = [NSString stringWithFormat:@"Himalaya ID: %@", userConfig.HID];
            header.hid.hidden = NO;
        }
        
    } else {
        [header.nameBtn setTitle:NSLocalizedDefault(@"register_login") forState:UIControlStateNormal];
        header.phoneLabel.hidden = YES;
        header.nameLabel.hidden = YES;
        header.QRCodeBtn.hidden = YES;
        header.hid.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.fd_prefersNavigationBarHidden = YES;

    [self updateUIWithUserLoggedInStatusWithLoggedInStatus:[self isAuthorized]];
}

#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.listItems[indexPath.item] configureCellWithTableView:tableView indexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.listItems[indexPath.row].clickHandler(indexPath);
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

- (BOOL)isKycVerified{
    if (![self userConfig].isKYCVerified.boolValue) {
        [self showKycAlert];
        return NO;
    }else{
        return YES;
    }
}

@end
