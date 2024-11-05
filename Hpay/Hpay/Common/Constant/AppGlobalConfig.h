#ifndef AppGlobalConfig_h
#define AppGlobalConfig_h

#define MBHUD MBProgressHUD

#define SB_HOME [UIStoryboard storyboardWithName:@"Home" bundle:[NSBundle mainBundle]]
#define SB_WALLET [UIStoryboard storyboardWithName:@"Wallet" bundle:[NSBundle mainBundle]]
#define SB_PROFILE [UIStoryboard storyboardWithName:@"Profile" bundle:[NSBundle mainBundle]]
#define SB_PROFILE_ACCOUNT [UIStoryboard storyboardWithName:@"ProfileAccount" bundle:[NSBundle mainBundle]]
#define SB_HELP_FEEDBACK_LIST [UIStoryboard storyboardWithName:@"HelpFeedbackList" bundle:[NSBundle mainBundle]]
#define SB_STATEMENT [UIStoryboard storyboardWithName:@"Statement" bundle:[NSBundle mainBundle]]
#define SB_NOTIFICATION_CENTER [UIStoryboard storyboardWithName:@"NotificationCenter" bundle:[NSBundle mainBundle]]
#define SB_DEEPLINK [UIStoryboard storyboardWithName:@"Deeplink" bundle:[NSBundle mainBundle]]
#define SB_TsCs [UIStoryboard storyboardWithName:@"TermsConditions" bundle:[NSBundle mainBundle]]
#define SB_NICKNAME [UIStoryboard storyboardWithName:@"Home" bundle:[NSBundle mainBundle]]

#define SB_PROFILE_QR_CODE [UIStoryboard storyboardWithName:@"MyQRCode" bundle:[NSBundle mainBundle]]

#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kDevice_Is_iPhoneX (kStatusBarHeight == 44 ? YES : NO)
#define kAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define kAppBulidNumber [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
//iOS版本
#define iOSVersion [[UIDevice currentDevice].systemVersion floatValue]

//屏幕宽度和高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define kProportionHeight(height) SCREEN_WIDTH/(375.0/height)

//弱引用
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//适配函数5，6，6p，7,7p在iphone 6和7 的基础上等比例放大缩小
#define layoutHeight() \
({ \
    BOOL is_iphone_5 =  (fabs((double)[[UIScreen mainScreen ] bounds ].size.height - ( double )568 )== 0); \
    BOOL is_iphone_6p =  (fabs((double)[[UIScreen mainScreen ] bounds ].size.height - ( double )736 )== 0); \
    BOOL is_iphone_4 =  (fabs((double)[[UIScreen mainScreen ] bounds ].size.height - ( double )480 )== 0); \
    double dlayout = 1.0; \
    if(is_iphone_5 || is_iphone_4) \
    { \
        dlayout = (double)320/375; \
    } \
    else if(is_iphone_6p) \
    { \
        dlayout = (double)414/375; \
    } \
    (dlayout); \
})\

#define kPageSize 20

#define kIsZhLanguageCode [[FPLanguageTool sharedInstance].language hasPrefix:@"zh-"]

#define kLocaleLanguageCode kIsZhLanguageCode?@"zh":@"en"

#define kPlaceholderForMarketPriceNotAvailable @"--"

#define kFPNetWorkErrorCode 123456
#define kFPUnknownErrorCode 999999
#define kFPNetRequestSuccessCode 0
#define kFPNetRequestServerErrorCode 10000
#define kFPLackofBalanceCode 10030
#define kFPUserExistCode 10011
#define kFPUserNotExistCode 10012
#define kErrorCodeReceiverUserCountryNotAllowedHPay 10094
#define kErrorCodeMarketPriceNotAvailable 10100
#define kErrorCodePaymentExpired 20001
#define kErrorCodePaymentCompleted 20002
#define kErrorCodePaymentCancelled 20003
#define kErrorCodePaymentInsufficientBalance 20004
#define kErrorCodePaymentInsufficientBalanceMerchant 10030
#define kErrorCodePaymentOrderNotFound 20005
#define kErrorCodeReceiverAccountNotValid 10086
#define kErrorCodeTransferToSelf 10123
#define kErrorCodeSenderUserCountryNotAllowedHPay 10093
#define kErrorCodeInvalidKYC 10084
#define kErrorCodeInvalidKYCReceiver 10047
#define kErrorCodeInvalidCoin 10087
#define kErrorCodeUserNotAllowed 10097
#define kErrorCodeUserNotAuthorized 401
#define kErrorCodeDecimalPointFormatError 10176
#define kErrorCodeInputAmountFlowLimit 10144
#define kErrorCodeUserWalletDoesNotExist 10175
#define kErrorCodeSenderAccountIsNotValid 10085
#define kErrorCodeFirstSetPinAlreadySet 30001
#define kErrorCodeVerifyPinCheck 30002
#define kErrorCodeResetPinCodeMatch 30003
#define kErrorCodeResetPinCodeExpired 30004
#define kErrorCodeMaxPinAttemptExceeded 30005
#define kErrorCodeInvalidCellPhone 10090
#define kErrorCodeUserAccountSuspended 10098
#define kErrorCodeReceiverAccountSuspended 10099

#define kErrorCodeMerchantRestricted 30007
#define kErrorCodeRestrictedCountry 10097
#define kErrorCodeAccountRestrictedToRecieve 30006
#define kErrorCodeReciverAccountInRestrictedCoutry 10094

#define kErrorCodeTooLongDateRangeToExport 30008

#define kErrorCode_FROMDATE_SHLDLBFR_TODATE 30015
#define kErrorCode_FUTUREDATE_NOT_ALLOWED 30017
#define kErrorCode_SOAREQUEST_INPROCESS 30018
#define kErrorCode_SOA_DAILYREQUEST_THRESHOLD_REACHED 30019

#define kErrorCodeINVALID_NICKNAME 30011
#define kErrorCodeNICKNAME_ALREADY_EXIST 30012
#define kErrorCodeNICKNAME_REQUIRED 30010

#define HIDE_SENSITIVE_INFORMATION_BLUR_VIEW_TAG 1000001

#define kErrorCodeAMOUNT_EXCEEDS_MAX_LIMIT 11008
#define kErrorCodeNOTES_VALUE_TOO_LONG 11004

#import "FPLanguageTool.h"
#import "NSBundle+FPLanguage.h"

#define NSLocalizedCommon(key) FPGetStringWithKeyFromTable(key, @"Localizable") //FPGetStringWithKeyFromTable(key, @"CommonStrings")
#define NSLocalizedHome(key) FPGetStringWithKeyFromTable(key, @"Localizable") //FPGetStringWithKeyFromTable(key, @"HomeStrings")
#define NSLocalizedStatement(key) FPGetStringWithKeyFromTable(key, @"Localizable") //FPGetStringWithKeyFromTable(key, @"StatementStrings")
#define NSLocalizedProfile(key) FPGetStringWithKeyFromTable(key, @"Localizable") //FPGetStringWithKeyFromTable(key, @"ProfileStrings")
#define NSLocalizedLogin(key) FPGetStringWithKeyFromTable(key, @"Localizable") //FPGetStringWithKeyFromTable(key, @"LoginStrings")
#define NSLocalizedWallet(key) FPGetStringWithKeyFromTable(key, @"Localizable") //FPGetStringWithKeyFromTable(key, @"WalletStrings")
#define NSLocalizedMerchant(key) FPGetStringWithKeyFromTable(key, @"Localizable") //FPGetStringWithKeyFromTable(key, @"MerchantStrings")
#define NSLocalizedDefault(key) FPGetStringWithKeyFromTable(key, @"Localizable")

#define kAppBundleId [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]
#define kPasswordUnlockScreenService [NSString stringWithFormat:@"%@.passwordUnlockScreen",kAppBundleId]
#define kisOpenPasswordUnlockKey [NSString stringWithFormat:@"IsOpenPasswordUnlock.%@",[GCUserManager manager].user.sub]

#define IdentityServerAuthStateAttributesData [NSString stringWithFormat:@"%@.identityUser",kAppBundleId]
#define IdentityServerAuthStateAttributesAccount [NSString stringWithFormat:@"%@.identityCurrentUser",kAppBundleId]

#define IdentityUserAttributesData [NSString stringWithFormat:@"%@.user",kAppBundleId]
#define IdentityAuthUserAttributesAccount [NSString stringWithFormat:@"%@.currentUser",kAppBundleId]

#define IdentityUserConfigAttributesData [NSString stringWithFormat:@"%@.user.config",kAppBundleId]
#define IdentityUserConfigAttributesAccount [NSString stringWithFormat:@"%@.currentUser.config",kAppBundleId]

#define kLastLoginCountryModel @"kLastLoginCountryModel"
#define kLastLoginAccount @"kLastLoginAccount"
#define KPinVerifyTime @"kPinVerifyTime"

#define kUserInterfaceStyle @"kUserInterfaceStyle"

#endif /* AppGlobalConfig_h */

