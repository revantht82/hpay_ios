#import "TermsConditionsViewController.h"
#import "FetchUserConfigAndInfoUseCase.h"
#import "UserConfigResponse.h"
#import "HimalayaAuthKeychainManager.h"
#import "HimalayaPayAPIManager.h"

@interface TermsConditionsViewController ()

@property(weak, nonatomic) IBOutlet UIView *viewContainer;
@property(weak, nonatomic) IBOutlet UITextView *tscsTextView;
@property(weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (nonatomic) FetchUserConfigAndInfoUseCase *fetchUserConfigAndInfoUseCase;

@end

@implementation TermsConditionsViewController


// MARK: - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self configureUI];
}

- (UserConfigResponse *)userConfig{
    NSError *error;
    return [HimalayaAuthKeychainManager loadUserConfigToKeychain:&error];
}

- (void)configureUI {
    _fetchUserConfigAndInfoUseCase = [[FetchUserConfigAndInfoUseCase alloc] init];
    NSString *acceptTitle = NSLocalizedString(@"terms_conditions.accept_button.title", @"Terms and conditions popup accept button title");
    NSString *terms = NSLocalizedString(@"terms_conditions.text", @"");
    NSURL *termsLink =  [self userConfig].termsUrl;
    NSString *privacy = NSLocalizedString(@"privacy_policy", @"");
    NSURL *privacyLink = [self userConfig].privacyUrl;
    
    NSMutableString *fullText;
    
    if ( ([self userConfig].termsRequireAccepting.boolValue) && ([self userConfig].privacyRequireAccepting.boolValue)) {
        fullText = [NSMutableString stringWithFormat: NSLocalizedString(@"terms_conditions.description", @"Terms and conditions description (html supported - include the link)"), acceptTitle, terms, privacy];
    }
    else if([self userConfig].termsRequireAccepting.boolValue){
        fullText = [NSMutableString stringWithFormat: NSLocalizedString(@"terms_only.description", @"Terms and conditions description (html supported - include the link)"), terms, acceptTitle];
    }
    else if([self userConfig].privacyRequireAccepting.boolValue){
        fullText = [NSMutableString stringWithFormat: NSLocalizedString(@"privacy_only.description", @"Terms and conditions description (html supported - include the link)"), privacy, acceptTitle];
    }
    
    
    
    UIFont *boldFont = [UIFont boldSystemFontOfSize:14];
    UIFont *normalFont = [UIFont systemFontOfSize:14];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:fullText];
    [attributedString addAttribute:NSFontAttributeName value:normalFont range:[[attributedString string] rangeOfString:fullText]];
    [attributedString addAttribute:NSFontAttributeName value:boldFont range:[[attributedString string] rangeOfString:acceptTitle]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[self getCurrentTheme].primaryOnBackground range:[[attributedString string] rangeOfString:fullText]];
    [attributedString addAttribute:NSLinkAttributeName value:termsLink range:[[attributedString string] rangeOfString:terms]];
    [attributedString addAttribute:NSLinkAttributeName value:privacyLink range:[[attributedString string] rangeOfString:privacy]];
    self.tscsTextView.attributedText = attributedString;
    [self.acceptButton setTitle: acceptTitle forState: UIControlStateNormal];
    self.viewContainer.cornerRadius = 5.0f;
}

// MARK: - Actions

- (IBAction)acceptButtonDidTap:(UIButton *)sender {
    //call service if success
    NSMutableDictionary *param = @{}.mutableCopy;
    NSNumber *termsVersion = [self userConfig].termsVersion;
    NSNumber *privacyVersion = [self userConfig].privacyVersion;
    param[@"AgreedTermsVersion"] = termsVersion;
    param[@"AgreedPrivacyVersion"] = privacyVersion;
    [HimalayaPayAPIManager POST:SignUserAgreements parameters:param successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        NSLog(@"\\Success terms and conditions acceptance update to hpay api");
        if ([self.delegate respondsToSelector:@selector(conditionsAccepted)]) {
            [self dismissViewControllerAnimated:NO completion:nil];
            [self.delegate conditionsAccepted];
        }
    } failureBlock:^(NSInteger code, NSString *_Nullable message) {
        NSLog(@"\\Failure on acceptance update to hpay API. With message");
        [self.acceptButton setTitle: @"Retry" forState: UIControlStateNormal];
    }];
    //else update the ui with retry button
}

@end
