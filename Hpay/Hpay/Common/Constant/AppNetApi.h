#ifndef AppNetApi_h
#define AppNetApi_h

#define kSessionExpiryShowingKey @"isShowingSessionExpiryDialog"

#define kShowEnvironmentVariable [[[NSBundle mainBundle] infoDictionary] objectForKey:@"SHOW_ENVIRONMENT_LABEL"]

#define kProductionBaseURL @""

#define kGoogleServiceInfoPlistFileName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"GOOGLESERVICE_INFO_PLIST_FILENAME"]

#define kBaseURL [[[NSBundle mainBundle] infoDictionary] objectForKey:@"HPAY_API_BASE_URL"]
#define kMerchantBaseURL [[[NSBundle mainBundle] infoDictionary] objectForKey:@"MERCHANT_API_BASE_URL"]
#define kSSOBaseURL [[[NSBundle mainBundle] infoDictionary] objectForKey:@"SSO_API_BASE_URL"]
#define kSSOExtraBaseURL [[[NSBundle mainBundle] infoDictionary] objectForKey:@"SSO_API_EXTRA_BASE_URL"]

#define kIssuer [[[NSBundle mainBundle] infoDictionary] objectForKey:@"AUTH_ISSUER"]
#define kClientID [[[NSBundle mainBundle] infoDictionary] objectForKey:@"AUTH_CLIENT_ID"]
#define kRedirectURI [[[NSBundle mainBundle] infoDictionary] objectForKey:@"AUTH_REDIRECT_URI"]

#define kGetQRCodeImageURL [kBaseURL stringByAppendingString:@"api/user/qrimage"]

#define kMerchantPaymentDetailURL [kMerchantBaseURL stringByAppendingString:@"api/v1.0/Payment/Detail"]
#define kMerchantOrderRetrieveURL [kMerchantBaseURL stringByAppendingString:@"api/v1.0/order/retrieve"]
#define kMerchantRefundDetailURL [kMerchantBaseURL stringByAppendingString:@"api/v1.0/refund/detail"]
#define kMerchantPaymentCreateURL [kMerchantBaseURL stringByAppendingString:@"api/v1.0/payment/create"]
#define kMerchantPaymentCancelURL [kMerchantBaseURL stringByAppendingString:@"api/v1.0/payment/cancel"]
#define MerchantProductCategory [kBaseURL stringByAppendingString:@"api/v1.0/product/category"]
#define kAccountBaseURL [kBaseURL stringByAppendingString:@"account/api/"]
#define kFoundationBaseURL kBaseURL
#define kImageUploadBaseURL [kBaseURL stringByAppendingString:@"foundation/api/"]
//钱包相关URL
#define kWalletBaseURL [kBaseURL stringByAppendingString:@"wallet/api/"]
#define kMessageBaseURL [kBaseURL stringByAppendingString;@"message/api/"]
#define kPrivacyBaseURL kBaseURL

#define UserConfig [kBaseURL stringByAppendingString:@"api/User/UserConfig"]
#define SignUserAgreements [kBaseURL stringByAppendingString:@"api/User/SignUserAgreements"]

//set nickname URL -
#define SetNicknameURL [kBaseURL stringByAppendingString:@"api/User/nickname"]


#pragma mark - Push Notifications
#define PushNotificationsRegistrationURL [kBaseURL stringByAppendingString:@"notification/api/EnablePushNotification"]
#define PushNotificationsRegistrationDisableURL [kBaseURL stringByAppendingString:@"notification/api/DisablePushNotification"]

#pragma mark - Statement
#define StatementListAllURL [kWalletBaseURL stringByAppendingString:@"Statement/GetList"]
//#define StatementListSingleURL [kWalletBaseURL stringByAppendingString:@"Statement/ListSingleType"]
#define StatementListSingleURL StatementListAllURL
#define PrintQRURL [kBaseURL stringByAppendingString:@"api/user/printqr"]
//版本号
#define AppVersionVersionURL [kImageUploadBaseURL stringByAppendingString:@"AppVersion/Version"]
#define SOAExportURL [kWalletBaseURL stringByAppendingString:@"Statement/RequestSOA"]
#pragma mark - Home

#define NotificationCenterListSingleURL [kBaseURL stringByAppendingString:@"api/v1.0/user/announcements"]
//#define CountryGetStoreCountryListURL [kFoundationBaseURL stringByAppendingString:@"Country/GetStoreCountryList"]

//获取首页数据，总金额已经由服务端计算
#define HomePageIndexURL [kWalletBaseURL stringByAppendingString:@"Wallet/Info"]

//扫描商家固态二维码
#define OrderScanMerchantQRCodeURL [kAccountBaseURL stringByAppendingString:@"Order/ScanMerchantQRCode"]

//准备调整币种交易顺序
#define HomePagePreReOrderURL [kAccountBaseURL stringByAppendingString:@"HomePage/PreReOrder"]

//切换币种在首页的显示与隐藏
#define HomePageToggleShowInHomePageURL [kAccountBaseURL stringByAppendingString:@"HomePage/ToggleShowInHomePage"]

//排序（功能尚未实现）
#define HomePageReOrderURL [kAccountBaseURL stringByAppendingString:@"HomePage/ReOrder"]

#pragma mark - Wallet

//获取充币以及提币的列表
#define WalletListForDepositAndWithdrawalURL [kWalletBaseURL stringByAppendingString:@"Wallet/GetList"]

//准备调整币种交易顺序
#define WalletPreReOrderURL [kAccountBaseURL stringByAppendingString:@"Wallet/PreReOrder"]

//排序（功能尚未实现）
#define WalletReOrderURL [kAccountBaseURL stringByAppendingString:@"Wallet/ReOrder"]


#define kWalletCryptoAddressURL [kWalletBaseURL stringByAppendingString:@"CryptoAddress/"]

//地址管理，列出所有币种以及地址数量
#define WithdrawListForManageWithdrawalAddressURL [kWalletCryptoAddressURL stringByAppendingString:@"GetManageList"]

//添加提币地址
#define WithdrawAddAddressURL [kWalletCryptoAddressURL stringByAppendingString:@"Add"]

//删除提币地址
#define WithdrawDeleteAddressURL [kWalletCryptoAddressURL stringByAppendingString:@"Delete"]

#define WithdrawAddressListURL [kWalletCryptoAddressURL stringByAppendingString:@"GetList"]

#pragma mark - Security

//设置二级密码，客户端首先根据登录返回的SimpleUserInfo的HasSetPin字段判断是否已经设置过Pin
#define SecuritySetPinURL [kSSOExtraBaseURL stringByAppendingString:@"api/MobileSecurity/FirstSetPin"]

//获取重置密码token-手机号
#define SecurityGetForgotPasswordToken [kAccountBaseURL stringByAppendingString:@"Security/GenerateResetPasswordTokenByCellphone"]

//获取重置密码token-邮箱
#define SecurityGetForgotPasswordTokenByEmail [kAccountBaseURL stringByAppendingString:@"Security/GenerateResetPasswordTokenByEmail"]



//发送忘记密码的短信
#define SecurityGetForgotPasswordCodeURL [kAccountBaseURL stringByAppendingString:@"Security/SendResetPasswordSMSCode"]

//发送忘记密码的短信-邮箱
#define SecurityGetForgotPasswordCodeByEmailURL [kAccountBaseURL stringByAppendingString:@"Security/SendResetPasswordEmailCode"]


//重置密码通过忘记密码的接口
#define SecurityResetPasswordByForgotPasswordCodeURL [kAccountBaseURL stringByAppendingString:@"Security/ResetPasswordByCellphone"]

//重置密码通过忘记密码的接口-邮箱
#define SecurityResetPasswordByEmailCodeURL [kAccountBaseURL stringByAppendingString:@"Security/ResetPasswordByEmail"]

//重置登录密码 当有开启谷歌验证码时候 （手机）
#define ResetPasswordByCellphoneWithGoogleAuthURL [kAccountBaseURL stringByAppendingString:@"Security/ResetPasswordByCellphoneWithGoogleAuth"]

//重置登录密码 当有开启谷歌验证码时候（邮箱）
#define ResetPasswordByEmailWithGoogleAuthURL [kAccountBaseURL stringByAppendingString:@"Security/ResetPasswordByEmailWithGoogleAuth"]


//获取更换手机号时的旧手机号的验证码
//#define SecurityGetUpdateCellphoneOldCodeURL [kAccountBaseURL stringByAppendingString:@"Security/GetUpdateCellphoneOldCode"]

//验证更换手机号的验证码（原手机）
//#define SecurityVerifyUpdateCellphoneOldCodeURL [kAccountBaseURL stringByAppendingString:@"Security/VerifyUpdateCellphoneOldCode"]

//准备验证新的手机号，这个接口会提供用户的国家地区码，以及国家名
#define SecurityPreGetVerifyNewCellphoneCodeURL [kAccountBaseURL stringByAppendingString:@"Security/PreGetVerifyNewCellphoneCode"]

//绑定手机时获取验证码
#define SecurityGetBindCellphoneCodeURL [kAccountBaseURL stringByAppendingString:@"Security/GetBindCellphoneCode"]

//绑定手机号
#define SecurityBindCellphoneURL [kAccountBaseURL stringByAppendingString:@"Security/BindCellphone"]

//获取验证新手机号的验证码(修改手机号)
#define SecurityGetUpdateCellphoneNewCodeURL [kAccountBaseURL stringByAppendingString:@"Security/GetUpdateCellphoneNewCode"]

//验证新手机号的验证码(修改手机时)
#define SecurityVerifyUpdateCellphoneNewCodeURL [kAccountBaseURL stringByAppendingString:@"Security/VerifyUpdateCellphoneNewCode"]

//绑定手机时验证短信验证码
#define SecurityVerifyBindCellphoneCodeURL [kAccountBaseURL stringByAppendingString:@"Security/VerifyBindCellphoneCode"]

//获取用户国家id 国家名称 email cellPhone
#define AccountGetUserInfoURL [kAccountBaseURL stringByAppendingString:@"Account/GetUserInfo"]

//修改手机号时，验证pin码
//#define SecurityVerifyUpdateCellphonePinURL [kAccountBaseURL stringByAppendingString:@"Security/VerifyUpdateCellphonePin"]

//修改手机号时, 综合验证
#define SecurityVerifyUpdateCellphoneCombineURL [kAccountBaseURL stringByAppendingString:@"Security/VerifyUpdateCellphoneCombine"]

//更换手机号
#define SecurityUpdateCellphoneURL [kAccountBaseURL stringByAppendingString:@"Security/UpdateCellphone"]

//获取修改Pin的验证码
#define SecurityGetUpdatePinCodeURL [kAccountBaseURL stringByAppendingString:@"Security/GetUpdatePinCode"]

//验证修改Pin的验证码
#define SecurityVerifyUpdatePinCodeURL [kAccountBaseURL stringByAppendingString:@"Security/VerifyUpdatePinCode"]

//验证证件号码
//#define SecurityVerifyFindPinBackIdNoURL [kAccountBaseURL stringByAppendingString:@"Security/VerifyFindPinBackIdNo"]

//修改Pin时，验证旧的PIN码
#define SecurityVerifyUpdatePinPinURL [kAccountBaseURL stringByAppendingString:@"Security/VerifyUpdatePinPin"]
//修改Pin时，综合验证
#define SecurityVerifyUpdatePinCombineURL [kAccountBaseURL stringByAppendingString:@"Security/VerifyUpdatePinCombine"]
//修改Pin
#define SecurityUpdatePinURL [kAccountBaseURL stringByAppendingString:@"Security/UpdatePin"]

//找回Pin前使用此接口查看用户是否已认证身份LV1
#define SecurityPreFindPinBackURL [kAccountBaseURL stringByAppendingString:@"Security/PreFindPinBack"]

//获取找回Pin的验证码
//#define SecurityGetFindPinBackCodeURL [kAccountBaseURL stringByAppendingString:@"Security/GetFindPinBackCode"]

//验证找回Pin的验证码
//#define SecurityVerifyFindPinBackCodeURL [kAccountBaseURL stringByAppendingString:@"Security/VerifyFindPinBackCode"]

//找回Pin
//#define SecurityFindPinBackURL [kAccountBaseURL stringByAppendingString:@"Security/FindPinBack"]
#define SecurityResetPINURL [kSSOExtraBaseURL stringByAppendingString:@"api/MobileSecurity/ResetPIN"]

//重置PIN码时，综合验证
#define SecurityVerifyResetPinCombineURL [kAccountBaseURL stringByAppendingString:@"Security/VerifyResetPinCombine"]

//获取修改Password的验证码
//#define SecurityGetUpdatePasswordCodeURL [kAccountBaseURL stringByAppendingString:@"Security/GetUpdatePasswordCode"]

//验证注册验证码
#define AccountCheckRegisterSMSCodeURL [kAccountBaseURL stringByAppendingString:@"Account/CheckRegisterSMSCode"]

//验证注册验证码 - 邮箱
#define AccountCheckRegisterEmailCodeURL [kAccountBaseURL stringByAppendingString:@"Account/CheckRegisterEmailCode"]

//验证忘记密码的验证码
#define SecurityVerifyForgotPasswordCodeURL [kAccountBaseURL stringByAppendingString:@"Security/VerifyForgotPasswordCode"]

//验证修改密码的验证码
//#define SecurityVerifyUpdatePasswordCodeURL [kAccountBaseURL stringByAppendingString:@"Security/VerifyUpdatePasswordCode"]

//修改密码，验证PIN
#define SecurityVerifyUpdatePasswordPinURL [kAccountBaseURL stringByAppendingString:@"Security/VerifyUpdatePasswordPin"]

//修改Password
#define SecurityUpdatePasswordURL [kAccountBaseURL stringByAppendingString:@"Security/UpdatePassword"]

//手势密码修改验证登录密码
#define SecurityVerifyLoginPasswordURL [kAccountBaseURL stringByAppendingString:@"Security/VerifyPassword"]

#pragma mark - UserDevice

//获取设备列表
#define UserDeviceGetDeviceListURL [kAccountBaseURL stringByAppendingString:@"UserDevice/GetDeviceList"]

//删除设备信息
#define UserDeviceDeleteDeviceURL [kAccountBaseURL stringByAppendingString:@"UserDevice/DeleteDevice"]

//更新设备
#define UserDeviceUpdateDeviceInfoURL [kAccountBaseURL stringByAppendingString:@"UserDevice/UpdateDeviceInfo"]

#pragma mark - Country


//获取国家列表，已经根据客户端语言排序
#define  CountryGetListURL [kImageUploadBaseURL stringByAppendingString:@"Country/GetList"]

//获取国家详情
#define  CountryGetByIdURL [kAccountBaseURL stringByAppendingString:@"Country/GetById"]
//#define  CountryGetByIdURL [kFoundationBaseURL stringByAppendingString:@"Country/GetById"]

#pragma mark - Image
//上传图片
#define UploadURL [kImageUploadBaseURL stringByAppendingString:@"Images/Upload"]

//获取图片
#define  ImageDownloadURL [kImageUploadBaseURL stringByAppendingString:@"Images/Download"]
#define  ImageDownloadCoinURL [kImageUploadBaseURL stringByAppendingString:@"Images/DownloadAnonymous"]

//根据币种Code下载币种icon
#define  CryptoImageDownloadURL [kImageUploadBaseURL stringByAppendingString:@"CryptoCurrency/GetIcon"]

#pragma mark - Account

#define UserInfoURL [kSSOExtraBaseURL stringByAppendingString:@"connect/userinfo"]

//退出登录接口，此接口将解除设备的推送服务绑定
#define AccountLogoutURL [kAccountBaseURL stringByAppendingString:@"Account/SignOut"]

//验证Pin码，超过五次错误会锁定30分钟
#define AccountVerifyPinURL [kSSOExtraBaseURL stringByAppendingString:@"api/MobileSecurity/VerifyPin"]

//获取支付码
#define OrderGetPaymentCodeURL [kWalletBaseURL stringByAppendingString:@"ConsumeOrder/GetQRCode"]

//主动支付（蓝牙、二维码、NFC都走这个流程） - 准备支付，将会传递溢价等参数
#define OrderPrePayURL [kAccountBaseURL stringByAppendingString:@"Order/PrePay"]

//主动支付（蓝牙、二维码、NFC都走这个流程）
#define OrderPayURL [kAccountBaseURL stringByAppendingString:@"Order/Pay"]

//准备支付推送过来的订单，通过订单Id获取订单金额等信息
#define OrderPrePayExistedOrderURL [kWalletBaseURL stringByAppendingString:@"ConsumeOrder/Scan"]

//根据orderId获取待支付的订单信息（pos机扫HPay付款码后 推送过来的queryId查询）
#define OrderToBePaidExistedOrderURL [kWalletBaseURL stringByAppendingString:@"ConsumeOrder/GetToPaidOrder"]

//支付已经存在的订单
#define OrderPayExistedOrderURL [kWalletBaseURL stringByAppendingString:@"ConsumeOrder/Pay"]

//订单详情
#define OrderDetailURL [kWalletBaseURL stringByAppendingString:@"ConsumeOrder/Detail"]

#define InternalAnalyticsEndPoint [kBaseURL stringByAppendingString:@"api/v1.0/user/events"]

#pragma mark - Request fund
#define RequestFundDetailURL [kBaseURL stringByAppendingString:@"wallet/api/v1.0/requestfund/getdetail"]
#define CancelRequestFundURL [kBaseURL stringByAppendingString:@"wallet/api/v1.0/requestfund/cancel"]
#define RequestFundQRURL [kMerchantBaseURL stringByAppendingString:@"pay/fund"]
#define RequestFundRetriveURL [kBaseURL stringByAppendingString:@"wallet/api/v1.0/requestfund/retrieve"]
#define ApproveFundRequestURL [kBaseURL stringByAppendingString:@"wallet/api/v1.0/requestfund/pay"]


#define CreateRequestFund [kBaseURL stringByAppendingString:@"wallet/api/v1.0/requestfund/init"]

#pragma mark - Withdraw
#define kWalletWithdrawURL [kWalletBaseURL stringByAppendingString:@"Withdrawal/"]

//准备提币
#define WithdrawPreWithdrawURL [kWalletWithdrawURL stringByAppendingString:@"PageInit"]

//提币
#define WithdrawWithdrawURL [kWalletWithdrawURL stringByAppendingString:@"Create"]

//提现详情
#define WithdrawDetailURL [kWalletWithdrawURL stringByAppendingString:@"Detail"]

//手续费率
#define WithdrawTransactionFeeRateURL [kAccountBaseURL stringByAppendingString:@"Withdraw/TransactionFeeRate"]

//提币时，验证PIN码
#define WithdrawVerifyWithdrawPINURL [kAccountBaseURL stringByAppendingString:@"Withdraw/VerifyWithdrawPIN"]

//提币时，综合验证
#define WithdrawVerifyWithdrawIMCombineURL [kAccountBaseURL stringByAppendingString:@"Withdraw/VerifyWithdrawIMCombine"]

#pragma mark - Deposit

#define kWalletDepositURL [kWalletBaseURL stringByAppendingString:@"Deposit/"]

//充币详情
#define DepositDetailURL [kWalletDepositURL stringByAppendingString:@"Detail"]

//充币地址
#define DepositPreDepositURL [kWalletDepositURL stringByAppendingString:@"PageInit"]

#pragma mark - Profile

#define ProfileInfoURL [kAccountBaseURL stringByAppendingString:@"Profile/Info"]
#define HashedUser [kWalletBaseURL stringByAppendingString:@"Transfer/PreTransferByUserHash"]


//修改生日
#define ProfileUpdateBirthdayURL [kAccountBaseURL stringByAppendingString:@"Profile/UpdateBirthday"]

//修改昵称
#define ProfileUpdateNicknameURL [kAccountBaseURL stringByAppendingString:@"Account/UpdateNickname"]

#define ProfilePreVerifyLv1URL [kAccountBaseURL stringByAppendingString:@"Profile/PreVerifyLv1"]

//修改Lv1信息
#define ProfileUpdateLv1InfoURL [kAccountBaseURL stringByAppendingString:@"Profile/UpdateLv1Info"]

#define ProfilePreVerifyLv2URL [kAccountBaseURL stringByAppendingString:@"Profile/PreVerifyLv2"]

//修改Lv2信息
#define ProfileUpdateLv2InfoURL [kAccountBaseURL stringByAppendingString:@"Profile/UpdateLv2Info"]

//修改头像
#define ProfileUpdateAvatarURL [kAccountBaseURL stringByAppendingString:@"Account/UpdateAvatar"]

//发送设置邮箱的验证码（绑定邮箱时）
#define SecurityGetBindEmailCodeURL [kAccountBaseURL stringByAppendingString:@"Security/GetBindEmailCode"]
//发送邮箱验证码（修改邮箱时）
#define SecurityGetUpdateEmailCodeURL [kAccountBaseURL stringByAppendingString:@"Security/GetUpdateEmailNewCode"]
//首次设置邮箱，验证PIN
//#define ProfileVerifySetEmailPinURL [kAccountBaseURL stringByAppendingString:@"Profile/VerifySetEmailPin"]

//绑定邮箱，验证邮箱验证码
#define SecurityVerifyBindEmailCodeURL [kAccountBaseURL stringByAppendingString:@"Security/VerifyBindEmailCode"]

//绑定邮箱（首次设置）
#define SecurityBindEmailURL [kAccountBaseURL stringByAppendingString:@"Security/BindEmail"]

////发送修改邮箱[原邮箱]的验证码
//#define ProfileSendUpdateOriginalEmailCodeURL [kAccountBaseURL stringByAppendingString:@"Profile/SendUpdateOriginalEmailCode"]

//验证原邮箱
//#define ProfileVerifyOriginalEmaileURL [kAccountBaseURL stringByAppendingString:@"Profile/VerifyOriginalEmail"]

//发送修改邮箱的验证码
//#define ProfileSendUpdateNewEmailCodeURL [kAccountBaseURL stringByAppendingString:@"Profile/SendUpdateNewEmailCode"]

//修改邮箱，验证新邮箱的验证码
//#define ProfileVerifyNewEmailCodeURL [kAccountBaseURL stringByAppendingString:@"Profile/VerifyNewEmailCode"]

#define VerifyBindEmailCodeURL [kAccountBaseURL stringByAppendingString:@"Security/VerifyBindEmailCode"]
#define VerifyUpdateEmailCodeURL [kAccountBaseURL stringByAppendingString:@"Security/VerifyUpdateEmailNewCode"]

//综合验证获取邮箱验证码
#define SecurityGetSecurityEmailCodeURL [kAccountBaseURL stringByAppendingString:@"Security/GetSecurityEmailCode"]


//修改邮箱，验证PIN
//#define ProfileVerifyUpdateEmailPinURL [kAccountBaseURL stringByAppendingString:@"Profile/VerifyUpdateEmailPin"]

//修改邮箱
#define SecurityUpdateEmailURL [kAccountBaseURL stringByAppendingString:@"Security/UpdateEmail"]

//修改性别
#define ProfileUpdateGenderURL [kAccountBaseURL stringByAppendingString:@"Profile/UpdateGender"]

//系统通知（新闻公告）列表
#define ArticleListURL [kMessageBaseURL stringByAppendingString:@"Article/GetList"]

//将新闻状态设置为已读
#define ArticleReadURL [kMessageBaseURL stringByAppendingString:@"Article/Read"]

//获取第一条文章的Title以及未读条数
#define ArticleGetFirstTitleAndNotReadCountURL [kMessageBaseURL stringByAppendingString:@"Article/GetFirstTitleAndUnReadCount"]

//删除消息
#define MessagesDeleteMessageURL  [kMessageBaseURL stringByAppendingString:@"Message/DeleteMessage"]

//标记为已读
#define MessagesReadMessageURL  [kMessageBaseURL stringByAppendingString:@"Message/ReadMessage"]

//获取消息列表
#define MessagesGetMessageListURL  [kMessageBaseURL stringByAppendingString:@"Message/GetMessageList"]

//获取客服账号列表
#define CountryCustomerServiceURL [kFoundationBaseURL stringByAppendingString:@"Country/CustomerService"]

//意见反馈
#define FeedbackFeedbackURL [kMessageBaseURL stringByAppendingString:@"Feedback/Create"]

//绑定验证谷歌验证码到用户,验证PIN
#define AuthenticatorVerifyBindPinURL [kAccountBaseURL stringByAppendingString:@"Authenticator/VerifyBindPin"]

//解绑谷歌验证,验证PIN
#define AuthenticatorVerifyUnBindPinURL [kAccountBaseURL stringByAppendingString:@"Authenticator/VerifyUnBindPin"]

//解绑谷歌验证,综合验证
#define AuthenticatorVerifyUnBindCombineURL [kAccountBaseURL stringByAppendingString:@"Authenticator/VerifyUnBindCombine"]


//关闭谷歌验证,验证PIN
#define AuthenticatorVerifyClosePinURL [kAccountBaseURL stringByAppendingString:@"Authenticator/VerifyClosePin"]

//googel认证 生成密钥
#define AuthenticatorGenerateSecretKeyURL [kAccountBaseURL stringByAppendingString:@"Authenticator/GenerateSecretKey"]

//绑定验证谷歌验证码到用户,综合验证
#define AuthenticatorVerifyBindCombineURL [kAccountBaseURL stringByAppendingString:@"Authenticator/VerifyBindCombine"]


//绑定验证谷歌验证码到用户
#define AuthenticatorBindURL [kAccountBaseURL stringByAppendingString:@"Authenticator/Bind"]

//解绑用户的验证谷歌验证码
#define AuthenticatorUnBindURL [kAccountBaseURL stringByAppendingString:@"Authenticator/UnBind"]

//验证谷歌验证码
#define AuthenticatorValidateURL [kAccountBaseURL stringByAppendingString:@"Authenticator/Validate"]

//通过SecretKey验证谷歌验证码（绑定的时候用）
#define AuthenticatorVerifyBindGoogleAuthURL [kAccountBaseURL stringByAppendingString:@"Authenticator/VerifyBindGoogleAuth"]

//获取用户开启的密保方式
#define AuthenticatorGetOpenedSecuritiesURL [kAccountBaseURL stringByAppendingString:@"Security/GetOpenedSecurities"]

//获取安全中的手机验证码
#define SecurityGetSecurityCellphoneCodeURL [kAccountBaseURL stringByAppendingString:@"Security/GetSecurityCellphoneCode"]

//验证综合
#define AuthenticatorSecurityValidateURL [kAccountBaseURL stringByAppendingString:@"Authenticator/SecurityValidate"]

//开启谷歌认证
#define AuthenticatorOpenURL [kAccountBaseURL stringByAppendingString:@"Authenticator/Open"]

//关闭谷歌验证,综合验证
#define AuthenticatorVerifyCloseCombineURL [kAccountBaseURL stringByAppendingString:@"Authenticator/VerifyCloseCombine"]


//开启谷歌验证,综合验证只验证谷歌验证码
#define AuthenticatorVerifyOpenGoogleAuthURL [kAccountBaseURL stringByAppendingString:@"Authenticator/VerifyOpenGoogleAuth"]

//关闭谷歌认证
#define AuthenticatorCloseURL [kAccountBaseURL stringByAppendingString:@"Authenticator/Close"]

//获取密保状态
#define AuthenticatorGetStatusOfSecurityURL [kAccountBaseURL stringByAppendingString:@"Security/GetStatus"]


//是否存在 Ex 帐号
#define FiiiEXHasExAccountURL [kAccountBaseURL stringByAppendingString:@"FiiiEX/HasExAccount"]

//获取FiiiEx划转条件
#define FiiiEXTransferFiiiExConditionURL [kAccountBaseURL stringByAppendingString:@"FiiiEX/TransferFiiiExCondition"]

//划转到 Ex
#define FiiiEXTransferToExURL [kAccountBaseURL stringByAppendingString:@"FiiiEX/TransferToEx"]

//从 Ex 划转
#define FiiiEXTransferFromExURL [kAccountBaseURL stringByAppendingString:@"FiiiEX/TransferFromEx"]

//划转详情详情
#define FiiiEXDetailURL [kAccountBaseURL stringByAppendingString:@"FiiiEX/Detail"]

//奖励-收入详情
#define InviteSingleBonusDetailURL [kAccountBaseURL stringByAppendingString:@"Invite/SingleBonusDetail"]
//扫描网关订单二维码
#define GatewayOrderScanURL [kWalletBaseURL stringByAppendingString:@"GatewayOrder/Scan"]
//支付网关订单二维码
#define GatewayOrderPayURL [kWalletBaseURL stringByAppendingString:@"GatewayOrder/Pay"]

//线上消费详情
#define GatewayOrderOutcomeDetailURL [kWalletBaseURL stringByAppendingString:@"GatewayOrder/GetOutcomeDetail"]

//网关入账
#define GatewayOrderIncomeDetailURL [kWalletBaseURL stringByAppendingString:@"GatewayOrder/GetIncomeDetail"]

//获取法币列表
#define GetFiatCurrencyListURL [kAccountBaseURL stringByAppendingString:@"Account/GetFiatCurrencies"]

//设置法币
#define SettingFiatCurrencyURL [kAccountBaseURL stringByAppendingString:@"Account/SetFiatCurrency"]

//一键已读消息
#define MessagesOnekeyReadMessageURL [kMessageBaseURL stringByAppendingString:@"Message/OnekeyReadMessage"]

//Fiiipay 扫码登录FiiiShop
#define FiiiShopScanLoginURL [kAccountBaseURL stringByAppendingString:@"FiiiShop/ScanLogin"]

//语言切换
#define AccountChangeLanguageURL [kAccountBaseURL stringByAppendingString:@"Account/ChangeLanguage"]

//获取Service服务器状态
#define GetServiceStatusURL [kFoundationBaseURL stringByAppendingString:@"api/Service/GetServiceStatus"]
// 验证新设备
#define AccountNewDeviceLoginURL [kAccountBaseURL stringByAppendingString:@"Account/NewDeviceLogin"]
#define NewDeviceLoginBySMSCodeURL [kAccountBaseURL stringByAppendingString:@"Account/NewDeviceLoginBySMSCode"]

#pragma mark - 门店订单

//支付门店订单
#define StoreOrderPayURL [kAccountBaseURL stringByAppendingString:@"StoreOrder/Pay"]

//门店收入详情
#define StoreOrderIncomeDetailURL [kAccountBaseURL stringByAppendingString:@"StoreOrder/IncomeDetail"]

//门店消费详情
#define StoreOrderConsumeDetailURL [kAccountBaseURL stringByAppendingString:@"StoreOrder/ConsumeDetail"]

#pragma mark - 银行卡信用卡购买加密币
//法币钱包详情
#define FiatCurrencyWalletDetailURL [kAccountBaseURL stringByAppendingString:@"FiatCurrencyWallet/Detail"]
//充值初始化
#define FiatCurrencyWalletDepositInitURL [kAccountBaseURL stringByAppendingString:@"FiatCurrencyWallet/DepositInit"]
//法币充值
#define FiatCurrencyWalletDepositURL [kAccountBaseURL stringByAppendingString:@"FiatCurrencyWallet/Deposit"]
//提币初始化
#define FiatCurrencyWalletWithdrawInitURL [kAccountBaseURL stringByAppendingString:@"FiatCurrencyWallet/WithdrawInit"]
//法币提现
#define FiatCurrencyWalletWithdrawURL [kAccountBaseURL stringByAppendingString:@"FiatCurrencyWallet/Withdraw"]
//法币购买加密币初始化
#define FiatCurrencyOrderBuyInitURL [kAccountBaseURL stringByAppendingString:@"FiatCurrencyOrder/BuyInit"]
//法币购买加密币
#define FiatCurrencyOrderBuyURL [kAccountBaseURL stringByAppendingString:@"FiatCurrencyOrder/Buy"]
//添加银行卡
#define BankCardCreateURL [kAccountBaseURL stringByAppendingString:@"BankCard/Create"]
//获取用户绑定的银行卡列表
#define BankCardListURL [kAccountBaseURL stringByAppendingString:@"BankCard/List"]
//法币钱包信息，包含充值记录列表
#define FiatCurrencyWalletInfoURL [kAccountBaseURL stringByAppendingString:@"FiatCurrencyWallet/Info"]

//KYC sdk  提交失败或者取消
#define ProfileSubmitLv1FailedURL [kAccountBaseURL stringByAppendingString:@"Profile/SubmitLv1Failed"]


#pragma mark - GPay钱包加密币相关URL

//CryptoCurrency
#define kWalletCryptoCurrencyURL [kWalletBaseURL stringByAppendingString:@"CryptoCurrency/"]
//获取加密币兑法币价格
#define CryptoCurrencyGetCryptoCurrencyPriceURL [kWalletCryptoCurrencyURL stringByAppendingString:@"GetCryptoCurrencyPrice"]

//获取加密币兑换率
#define CryptoCurrencyGetExchangeRateURL [kWalletCryptoCurrencyURL stringByAppendingString:@"GetExchangeRate"]

//获取可以被用于购买的加密币种列表
#define CryptoCurrencyGetBuyableListURL [kWalletCryptoCurrencyURL stringByAppendingString:@"GetBuyableList"]


//CurrencyPurchase
#define kWalletCurrencyPurchaseURL [kWalletBaseURL stringByAppendingString:@"CurrencyPurchase/"]

#define kWalletStripeCustomerURL [kWalletBaseURL stringByAppendingString:@"StripeCustomer/"]

//购买页面数据加初始化
#define CurrencyPurchasePageInitURL [kWalletCurrencyPurchaseURL stringByAppendingString:@"PageInit"]

//获取切换货币后的数据
#define CurrencyPurchaseCurrencyChangeURL [kWalletCurrencyPurchaseURL stringByAppendingString:@"CurrencyChange"]

//获取用户未支付购买订单
#define CurrencyPurchaseGetUnpaidOrderURL [kWalletCurrencyPurchaseURL stringByAppendingString:@"GetUnpaidOrder"]

//获取购买订单详情
#define CurrencyPurchaseDetailURL [kWalletCurrencyPurchaseURL stringByAppendingString:@"Detail"]

//获取购买账单详情
#define CurrencyPurchaseStatementDetailURL [kWalletCurrencyPurchaseURL stringByAppendingString:@"StatementDetail"]


//检查购买订单是否支付成功
#define CurrencyPurchaseCheckOrderPaidURL [kWalletCurrencyPurchaseURL stringByAppendingString:@"CheckOrderPaid"]

//获取用户的购买订单列表
#define CurrencyPurchaseGetOrderListURL [kWalletCurrencyPurchaseURL stringByAppendingString:@"GetOrderList"]


//获取用户的购买订单列表-详情
#define CurrencyPurchaseGetOrderDetailURL [kWalletCurrencyPurchaseURL stringByAppendingString:@"Detail"]

//获取收款银行卡信息
#define CurrencyPurchaseGetReceiptBankURL [kWalletCurrencyPurchaseURL stringByAppendingString:@"GetReceiptBank"]

#define CurrencyPurchasePaidConfirmURL [kWalletCurrencyPurchaseURL stringByAppendingString:@"PaidConfirm"]

//创建购买订单请求
#define CurrencyPurchaseCreateURL [kWalletCurrencyPurchaseURL stringByAppendingString:@"Create"]

#define CurrencyPurchaseSubmitURL [kWalletCurrencyPurchaseURL stringByAppendingString:@"Submit"]

#define CurrencyPurchaseRePayURL [kWalletCurrencyPurchaseURL stringByAppendingString:@"RePayPageInit"]

#define CurrencyPurchaseCancelURL [kWalletCurrencyPurchaseURL stringByAppendingString:@"Cancel"]

#define GetStripeEphemeralKeyURL [kWalletStripeCustomerURL stringByAppendingString:@"GetStripeEphemeralKey"]

#define CurrencyPurchaseCreateCustomerURL [kWalletStripeCustomerURL stringByAppendingString:@"CreateCustomer"]

//CurrencyPurchase
#define kWalletFastExchangeURL [kWalletBaseURL stringByAppendingString:@"FastExchange/"]

//购买页面数据加初始化
#define FastExchangePageInitURL [kWalletFastExchangeURL stringByAppendingString:@"PageInit"]
//执行闪兑操作
#define FastExchangCreateURL [kWalletFastExchangeURL stringByAppendingString:@"Create"]
//获取闪兑详情
#define FastExchangDetailURL [kWalletFastExchangeURL stringByAppendingString:@"Detail"]


//划转
#define kWalletHuaZhuanURL [kWalletBaseURL stringByAppendingString:@"CapitalTransfers/"]
//购买页面数据加初始化-划转
#define HuaZhuanPageInitURL [kWalletHuaZhuanURL stringByAppendingString:@"GetCapitalTransferInitData"]
//执行划转操作
#define HuaZhuanCreateURL [kWalletHuaZhuanURL stringByAppendingString:@"CapitalTransferHPayToExg"]
//获取划转详情
#define HuaZhuanDetailURL [kWalletHuaZhuanURL stringByAppendingString:@"Detail"]

//FiatCurrency
#define kWalletFiatCurrencyURL [kWalletBaseURL stringByAppendingString:@"FiatCurrency/"]

//获取可以用于购买加密币的法币列表
#define FiatCurrencyGetSupportBuyListURL [kWalletFiatCurrencyURL stringByAppendingString:@"GetSupportBuyList"]



//Transfer
#define kWalletTransferURL [kWalletBaseURL stringByAppendingString:@"Transfer/"]
//验证用户是否可以转账
#define TransferCheckTransferAbleURL [kWalletTransferURL stringByAppendingString:@"CheckTransferAble"]

// 准备转账-手机
#define TransferPreMobileTransferURL [kWalletTransferURL stringByAppendingString:@"PreTransferByCellphone"]
// 准备转账-邮箱
#define TransferPreEmailTransferURL [kWalletTransferURL stringByAppendingString:@"PreTransferByEmail"]

#define TransferPreHashTransferURL [kWalletTransferURL stringByAppendingString:@"PreTransferByUserHash"]

//获取转账详情
#define TransferDetailURL [kWalletTransferURL stringByAppendingString:@"Detail"]

//创建转账请求
#define TransferCreateURL [kWalletTransferURL stringByAppendingString:@"Create"]
#define GroupTransferCreateURL [kWalletTransferURL stringByAppendingString:@"SendToGroup"]

//Wallet
#define kWalletURL [kWalletBaseURL stringByAppendingString:@"Wallet/"]
//获取加密币可用余额
#define WalletGetBalanceURL [kWalletURL stringByAppendingString:@"GetBalance"]

//调用Jumio 移动端通知服务接口
#define ProfileNoticeUpdateKyc1StateURL [kAccountBaseURL stringByAppendingString:@"Profile/NoticeUpdateKyc1State"]

//用户银行卡列表 出售币的银行卡列表
#define UserBankCardGetListURL [kWalletBaseURL stringByAppendingString:@"UserBankCard/GetList"]

//添加用户银行卡 出售币
#define UserBankCardAddURL [kWalletBaseURL stringByAppendingString:@"UserBankCard/Add"]

//删除银行卡 出售币
#define UserBankCardDeleteURL [kWalletBaseURL stringByAppendingString:@"UserBankCard/Delete"]

//获取出售币业务初始化数据
#define CurrencySellingGetPageInitDataURL [kWalletBaseURL stringByAppendingString:@"CurrencySelling/GetPageInitData"]
//查询出售币详情
#define CurrencySellingGetDeatilURL [kWalletBaseURL stringByAppendingString:@"CurrencySelling/GetDeatil"]
//获取用户的售币订单列表
#define CurrencyPurchaseGetOrderSellListURL [kWalletBaseURL stringByAppendingString:@"CurrencySelling/GetOrderlist"]
//提交出售币申请
#define CurrencySellingSubmitSellingOrderURL [kWalletBaseURL stringByAppendingString:@"CurrencySelling/SubmitSellingOrder"]
//查询出售币账单详情
#define CurrencySellingStatementDetailURL [kWalletBaseURL stringByAppendingString:@"CurrencySelling/GetStatementDetail"]

#endif /* AppNetApi_h */
