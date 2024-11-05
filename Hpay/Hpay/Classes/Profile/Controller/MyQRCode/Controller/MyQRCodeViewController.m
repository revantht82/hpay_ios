#import "MyQRCodeViewController.h"
#import "SettingsRouter.h"
#import "ProfileRouter.h"
#import "FetchUserConfigAndInfoUseCase.h"
#import "UserConfigResponse.h"
#import "HimalayaAuthKeychainManager.h"
#import "QRView.h"
#import <SafariServices/SafariServices.h>
#import "WebViewController.h"

@interface MyQRCodeViewController ()

@property(strong, nonatomic) SettingsRouter<SettingsRouterInterface> *router;

@property (nonatomic) FetchUserConfigAndInfoUseCase *fetchUserConfigAndInfoUseCase;
@end

@implementation MyQRCodeViewController

- (SettingsRouter<SettingsRouterInterface> *)router {
    if (_router == nil) {
        _router = [[SettingsRouter alloc] init];
        _router.currentControllerDelegate = self;
        _router.navigationDelegate = self.navigationController;
        _router.tabBarControllerDelegate = self.tabBarController;
    }
    return _router;
}

- (UserConfigResponse *)userConfig{
    NSError *error;
    return [HimalayaAuthKeychainManager loadUserConfigToKeychain:&error];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"my_qr.title", nil);
    self.navigationItem.backButtonTitle = @" ";
    
    _fetchUserConfigAndInfoUseCase = [[FetchUserConfigAndInfoUseCase alloc] init];
    NSString *termsurl = [self userConfig].termsUrl;
        
    if(![GCUserManager manager].isLogin){
        
    }

    if([termsurl length]==0)
   {
       
   }
    
    [self applyTheme];
    
    QRView *qrView = [[[NSBundle mainBundle] loadNibNamed:@"QRView" owner:self options:nil] lastObject];
    
    if (qrView) {
        UserConfigResponse *userConfig = [GCUserManager manager].userConfig;
        
        NSDictionary *responseModel = @{
            @"CoinName": @"",
            @"Amount":@"0",
            @"DeepLink":userConfig.MyQR
        };
        
        qrView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [qrView configurViewWithItem:responseModel];
        qrView.delegate = self;
        
        [qrView hideFiledsForMyQrCode];
        [self.view addSubview:qrView];
    }
}


- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self applyTheme];
}

- (void)applyTheme{
    self.view.backgroundColor = [self getCurrentTheme].background;
    
}

#pragma mark - QR delegate methods

- (void)doneButtonPressed:(nonnull UIButton *)sender {
    [self.router dismissOrClose];
}

- (void)shareButtonPressed:(NSString *)linkString :(NSString *)amount :(UIImage *)QRCodeImage {
    NSString *greatingString = NSLocalizedString(@"my_qr_share_text", nil);

    if (!QRCodeImage) {
        NSData *stringData = [linkString dataUsingEncoding: NSISOLatin1StringEncoding];
        CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        [qrFilter setValue:stringData forKey:@"inputMessage"];
        CIImage *ciImage = qrFilter.outputImage;
        QRCodeImage = [UIImage imageWithCIImage:ciImage];
    }
    NSArray* sharedObjects = [NSArray arrayWithObjects:greatingString, QRCodeImage,  nil];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:sharedObjects applicationActivities:nil];
    activityViewController.popoverPresentationController.sourceView = self.view;
    [self presentViewController:activityViewController animated:YES completion:nil];
}

-(void)openURLSafari: (NSURL*)URL{
    SFSafariViewController *safariController = [[SFSafariViewController alloc] initWithURL:URL];
    [self.router present:safariController];
}

-(void)openFileInCustomWebView:(NSString*)filePath withName:(NSString*)fileName andType:(NSString*)fileType{  
    WebViewController *webView = [[WebViewController alloc] init];
    webView.title = self.title;
    webView.file = filePath;
    webView.filename2save = [NSString stringWithFormat:@"%@.%@", fileName, fileType];
    [self.router pushTo:webView];
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

@end
