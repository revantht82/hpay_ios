//
//  FPWKWebViewController.m
//  FiiiPay
//
//  Created by Singer on 2018/4/24.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "FPWKWebViewController.h"
#import "ProfileHelperModel.h"
#import "WebViewRouter.h"

@interface FPWKWebViewController () <WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>
@property(nonatomic, strong) WKWebView *webView;
@property(nonatomic, strong) WKWebViewConfiguration *configuration;
@property(nonatomic, strong) NSURL *url;

@property(nonatomic, strong) WebViewRouter<WebViewRouterInterface> *router;

@end

@implementation FPWKWebViewController

- (WebViewRouter<WebViewRouterInterface> *)router {
    if (_router == nil) {
        _router = [[WebViewRouter alloc] init];
        _router.currentControllerDelegate = self;
        _router.navigationDelegate = self.navigationController;
        _router.tabBarControllerDelegate = self.tabBarController;
    }
    return _router;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.isWebPage) {
        self.navigationItem.title = NSLocalizedProfile(@"message_details");
    }

    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = [[WKUserContentController alloc] init];

    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];

    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    if (self.isWebPage) {
        self.view.backgroundColor = [UIColor whiteColor];
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        backBtn.frame = CGRectMake(0, 0, 30, 30);
        [backBtn setImage:[UIImage imageNamed:@"login_Back"] forState:UIControlStateNormal];
        backBtn.tintColor = [UIColor blackColor];
        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [closeBtn setImage:[UIImage imageNamed:@"pic_coin_close"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        closeBtn.tintColor = [UIColor blackColor];
        closeBtn.frame = CGRectMake(0, 0, 30, 30);
        self.navigationItem.title = nil;

        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:closeBtn];
        self.navigationItem.leftBarButtonItems = @[backButton, closeButton];
        NSCharacterSet *allowedCharacters = [NSCharacterSet URLQueryAllowedCharacterSet];
        NSString *urlStr = [self.urlStr stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
        NSURL *url = [NSURL URLWithString:urlStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];

    } else {
        [self setupData];
    }
}

- (void)back {

    [self.webView evaluateJavaScript:@"window.devieceUtil.transferBackFunc()" completionHandler:^(id _Nullable obj, NSError *_Nullable error) {
        NSString *result = obj;
        if ([result isEqualToString:@"close"]) {
            if ([self.webView canGoBack]) {
                [self.webView goBack];
            } else {
                [self.router dismissOrClose];
            }
        }

        if (error) {
            if ([self.webView canGoBack]) {
                [self.webView goBack];
            } else {
                [self.router dismissOrClose];
            }
        }
    }];
}

- (void)close {
    [self.router dismissOrClose];
}

- (void)setupData {
    [ProfileHelperModel GET:self.urlStr parameters:self.param successBlock:^(NSObject * _Nullable data, NSObject * _Nullable extension, NSString * _Nullable message) {
        if ([data isKindOfClass:[NSString class]]) {
            NSString *htmlStr = (NSString *) data;
            [self.webView loadHTMLString:htmlStr baseURL:nil];
        }
    }          failureBlock:^(NSInteger code, NSString *_Nullable message) {

    }];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    [MBHUD showInView:self.view withTitle:nil withType:HUDTypeLoading];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [MBHUD hideInView:self.view];
    if (webView.title.length > 0) {
        self.navigationItem.title = webView.title;
    }

}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    [self.router presentAlertWith:message completionHandler:completionHandler];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    [self.router presentConfirmedAlertWith:message completionHandler:completionHandler];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *_Nullable))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:NSLocalizedCommon(@"complete") style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        completionHandler(alertController.textFields.firstObject.text ?: @"");
    }])];


    [self presentViewController:alertController animated:YES completion:nil];
}

- (NSURL *)url {
    return [NSURL URLWithString:self.urlStr];
}
@end
