# hpay-iOS

git clone git@10.110.255.117:Himalaya-Exchange/hpay-iOS.git

cd hpay-iOS/Hpay

brew install cocoapods

pod -v

pod install

open .

click Hpay.xcworkspace file

#### :warning: IMPORTANT :warning:

iOS system triggers Sign-In pop up everytime when user triggered to SSO flow (both login and logout). To prevent that popup AppAuth removed from pods and used as source code to be able to update it.

```
OIDExternalUserAgentIOS.m file

.
.
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
      if (@available(iOS 13.0, *)) {
          authenticationVC.presentationContextProvider = self;
          authenticationVC.prefersEphemeralWebBrowserSession = YES; /// This line is added to prevent Signin popup.
      }
#endif
```


Refer to https://github.com/openid/AppAuth-iOS/issues/177 for more details.

Related pull request: https://10.110.255.117/Himalaya-Exchange/hpay-iOS/pull/197/commits/2f94a9d1f265a42121e34aee11f8685bf6a71946#diff-ed1b6eeadd6d1c7836b8198a18bd2d8de1ae052c5e9503def9fd4a00359abbb2R119

If AppAuth library is updated, only that line needs to be considered when copying the code from remote repo or forking.
