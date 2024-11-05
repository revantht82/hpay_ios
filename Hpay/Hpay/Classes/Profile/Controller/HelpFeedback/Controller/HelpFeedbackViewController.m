//
//  HelpFeedbackViewController.m
//  FiiiPay
//
//  Created by Singer on 2018/3/27.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "HelpFeedbackViewController.h"
#import "FPWKWebViewController.h"
#import <WebKit/WebKit.h>

@interface HelpFeedbackViewController () <WKNavigationDelegate>
@property(nonatomic, strong) FPWKWebViewController *ctrl;
@end

@implementation HelpFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedDefault(@"contact");

    FPWKWebViewController *webVC = [FPWKWebViewController new];
    NSString *url = @"";
    if ([[FPLanguageTool sharedInstance].language isEqualToString:@"en"]) {
        url = @"https://hamilton-ch.zendesk.com/hc/en-gb";
    } else {
        url = @"https://hamilton-ch.zendesk.com/hc/zh-cn";
    }
    webVC.urlStr = url;
    webVC.view.frame = self.view.bounds;
    webVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:webVC.view];
    [self addChildViewController:webVC];
}


@end
