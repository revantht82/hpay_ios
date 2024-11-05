#import "SettingsRouter.h"
#import <SafariServices/SafariServices.h>
#import "UserConfigResponse.h"
#import "HimalayaAuthKeychainManager.h"

@implementation SettingsRouter

- (UserConfigResponse *)userConfig{
    NSError *error;
    return [HimalayaAuthKeychainManager loadUserConfigToKeychain:&error];
}

- (void)pushToAgreementPrivacyForEULA {
    NSString *termsLink =  [self userConfig].termsUrl;
    if([termsLink length] == 0){
        termsLink = NSLocalizedString(@"terms_conditions.link", @"");
    }
    [self pushToSafariWith:termsLink];
}

- (void)pushToAgreementPrivacyDataPolicy {
    NSString *privacyLink =  [self userConfig].privacyUrl;
    if([privacyLink length] == 0 ) {
        privacyLink = NSLocalizedString(@"privacy_policy.link", @"");
    }
    [self pushToSafariWith:privacyLink];
}

- (void)pushToSupport {
    NSString *customerServiceUrl = NSLocalizedString(@"customer_service_url", @"");
    [self pushToSafariWith:customerServiceUrl];
}

- (BOOL)isTheLanguageEng {
    return [[FPLanguageTool sharedInstance].language isEqualToString:@"en"];
}

- (void)pushToSafariWith:(NSString *)urlString {
    NSURL *zendeskURL = [NSURL URLWithString:urlString];
    SFSafariViewController *safariController = [[SFSafariViewController alloc] initWithURL:zendeskURL];
    [self present:safariController];
}

@end
