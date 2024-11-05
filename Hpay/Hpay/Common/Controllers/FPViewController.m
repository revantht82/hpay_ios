#import "FPViewController.h"
#import "HimalayaAuthNotificationKeys.h"
#import "HomeViewController.h"
#import "HimalayaAuthManager.h"
#import "ApiError.h"

@interface FPViewController () <HimalayaAuthManagerStateDelegate>
@property(nonatomic, strong) UIButton *scanBtn;
@end

@implementation FPViewController

+ (NSString *)className {
    return NSStringFromClass([self class]);
}

#pragma mark - Lifecycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (iOSVersion < 11.0) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setRestorationIdentifier:NSStringFromClass([self class])];
    
    self.navigationController.view.backgroundColor = kCloudColor;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];

    CGFloat defSize = 18;
    if (SCREEN_WIDTH == 320) {
        defSize = 15;
    } else if (SCREEN_WIDTH == 375) {
        defSize = 17;
    }
    [self cfy_setNavigationBarBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]]];
    [self cfy_setNavigationBarShadowImage:[UIImage createImageWithColor:kCloudColor]];
    [self cfy_setNavigationBarAlpha:1];
    self.fd_prefersNavigationBarHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureUserObserver];
    [self applyNavBarTheme];
}

- (void)applyNavBarTheme{
    UIImage *image = [UIImage createImageWithColor:[self getCurrentTheme].toolbarLine];
    [self cfy_setNavigationBarShadowImage:image];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // The line above (where notifications are removed) _could_ be important.
    // Removing it may cause crashes and there is no easy way to tell.
    // Registering for kCoinBalanceChangedNotification notification so that the
    // previous functionality won't get broken.
    if ([self isKindOfClass:[HomeViewController class]]) {
        HomeViewController *homeVC = (HomeViewController*)self;
        [[NSNotificationCenter defaultCenter] addObserver:homeVC selector:@selector(coinBalanceDidChange) name:kCoinBalanceChangedNotification object:nil];
    }
}

#pragma mark - Controller Helpers

- (void)hideKeyboard {
    [self.view endEditing:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark - 扫码右边按钮

- (void)setUpRightBarButtonItem {
    [self setUpRightBarButtonItemWithImageName:@""];
}

- (void)setUpRightBarButtonItemWithImageName:(NSString *)imageName {
    self.scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.scanBtn setFrame:CGRectMake(0, 0, 24, 24)];
    [self.scanBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    //    [self.scanBtn setImage:[UIImage imageNamed:@"topbar_news_p"] forState:UIControlStateHighlighted];
    [self.scanBtn addTarget:self action:@selector(navToVC:) forControlEvents:UIControlEventTouchUpInside];


    UIBarButtonItem *scanItem = [[UIBarButtonItem alloc] initWithCustomView:self.scanBtn];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -6;

    self.navigationItem.rightBarButtonItems = @[spaceItem, scanItem];
}

#pragma mark = 去扫码页面

- (void)navToVC:(UIButton *)sender {

}

- (UIImage *)colorImageWithRect:(CGRect)rect {
    CGRect imgRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
    UIGraphicsBeginImageContextWithOptions(imgRect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, kSurfaceColor.CGColor);
    CGContextFillRect(context, imgRect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return img;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Login utilities

- (BOOL)isAuthorized{
    return [[HimalayaAuthManager sharedManager] isAuthorized];
}

- (void)loginAction {
    [HimalayaAuthManager sharedManager].stateDelegate = self;
    [[HimalayaAuthManager sharedManager] authorizeWithPresenter:self];
}

#pragma mark - Navigation Helpers

- (void)pop:(BOOL)isAnimated {
    [self.navigationController popViewControllerAnimated:isAnimated];
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - User observation

- (void)configureUserObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeUserState:) name:AuthStateUserDidUpdateNotificationKey object:nil];
}

#pragma mark - HimalayaAuthManagerStateDelegate

- (void)didLoginSucceed{
    [[[HPNavigationRouter alloc] init] showSplashViewControllerAsRoot];
}

- (void)didLoginFailedWithErrorCode:(NSInteger)errorCode{
    AlertActionItem *dismissItem = [AlertActionItem defaultDismissItem];
    
    ApiError* error = [ApiError errorWithCode:errorCode message:NULL];
    
    [self showAlertWithTitle:error.prettyTitle
                     message:error.prettyMessage
                     actions:[NSArray arrayWithObject:dismissItem]];
}

@end
