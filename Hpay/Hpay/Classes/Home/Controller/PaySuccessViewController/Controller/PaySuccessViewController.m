#import "PaySuccessViewController.h"
#import "NSString+UTCTimeStamp.h"
#import "PaySuccessRouter.h"
#import "HomeViewController.h"
#import "DecimalUtils.h"

@interface PaySuccessViewController ()
@property(weak, nonatomic) IBOutlet UILabel *topLabel;
@property(weak, nonatomic) IBOutlet UIView *contentView;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *contentView_H; /// 151
@property(weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property(weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *adaptive_H; /// Adapt to iphone4 125: 34
@property(weak, nonatomic) IBOutlet UIView *accountView;
@property(weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UIView *nicknameView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

@property(weak, nonatomic) IBOutlet UILabel *transactionNoLabel;
@property(weak, nonatomic) IBOutlet UILabel *transactionTimeLabel;
@property(weak, nonatomic) IBOutlet UILabel *receiverAccountLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property(weak, nonatomic) IBOutlet UIView *divider1;
@property(weak, nonatomic) IBOutlet UIView *divider2;
@property(weak, nonatomic) IBOutlet UIView *divider3;
@property(weak, nonatomic) IBOutlet UIView *divider4;

@property(strong, nonatomic) PaySuccessRouter<PaySuccessRouterInterface> *router;

@end

@implementation PaySuccessViewController

- (PaySuccessRouter<PaySuccessRouterInterface> *)router {
    if (_router == nil) {
        _router = [[PaySuccessRouter alloc] init];
        _router.currentControllerDelegate = self;
        _router.navigationDelegate = self.navigationController;
        _router.tabBarControllerDelegate = self.tabBarController;
    }
    return _router;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurePageUI];
    [self configurePage];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoticeNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kCoinBalanceChangedNotification object:nil];
    [self applyTheme];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self applyTheme];
}

- (void)applyTheme{
    self.view.backgroundColor = [self getCurrentTheme].background;
    self.topLabel.textColor = [self getCurrentTheme].primaryOnBackground;
    self.transactionNoLabel.textColor = [self getCurrentTheme].secondaryOnBackground;
    self.transactionTimeLabel.textColor = [self getCurrentTheme].secondaryOnBackground;
    self.receiverAccountLabel.textColor = [self getCurrentTheme].secondaryOnBackground;
    self.orderNumLabel.textColor = [self getCurrentTheme].primaryOnBackground;
    self.orderTimeLabel.textColor = [self getCurrentTheme].primaryOnBackground;
    self.accountLabel.textColor = [self getCurrentTheme].primaryOnBackground;
    self.nicknameLabel.textColor = [self getCurrentTheme].primaryOnBackground;
    self.doneButton.backgroundColor = [self getCurrentTheme].primaryButton;
    self.divider1.backgroundColor = [self getCurrentTheme].verticalDivider;
    self.divider2.backgroundColor = [self getCurrentTheme].verticalDivider;
    self.divider3.backgroundColor = [self getCurrentTheme].verticalDivider;
    self.divider4.backgroundColor = [self getCurrentTheme].verticalDivider;
}

#pragma mark - Carry out

- (IBAction)completAction:(id)sender {
    [self dismiss];
}

- (nullable HomeViewController *)homeController {
    return (HomeViewController *)[(UINavigationController *)((UITabBarController *)self.presentingViewController).viewControllers.firstObject topViewController];
}

#pragma mark - See details

- (IBAction)detailAction:(id)sender {
    [self.router pushToStatementDetailWith:self.pageType
                          withWithdrawDict:self.withdrawDict
                          withTransferDict:self.transferDict
                              withDataDict:self.dataDict
                           withOrderDetail:self.orderDetailModel];
}

#pragma mark - Private Helpers

- (void)dismiss {
    if (self.pageType == PageSuccessWithdrawalApply) {
        [self.router popToRoot];
    } else {
        [self.router dismiss];
    }
}

- (void)configureDismissBarButtonItem {
    self.navigationItem.hidesBackButton = NO;
    UIImage *dismissImage = [UIImage systemImageNamed:@"xmark"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:dismissImage style:UIBarButtonItemStylePlain target:self action:@selector(dismissButtonPressed)];
}

- (void)dismissButtonPressed {
    [self dismiss];
}

- (void)configurePageUI {
    self.navigationItem.title = @"";
    self.navigationItem.hidesBackButton = YES;
    if (SCREEN_HEIGHT == 480) {
        self.adaptive_H.constant = 350;
        self.contentView_H.constant = 100;
    }
    if (SCREEN_HEIGHT == 568) {
        self.contentView_H.constant = 100;
    }
    [self.view layoutIfNeeded];
}

- (void)configurePage {
    
    if (self.pageType == PageSuccessPay || self.pageType == PageSuccessWithStore || self.pageType == PageSuccessWithGatewayOrder) {
        NSString *totalString = [NSString stringWithFormat:@"%@\n\n%@ %@", NSLocalizedHome(@"paid"), self.orderDetailModel.CryptoCode, self.orderDetailModel.Amount];
        NSMutableAttributedString *attri1 = [[NSMutableAttributedString alloc] initWithString:totalString];
        
        [attri1 setAttributes:@{NSFontAttributeName: UIFontMake(18), NSForegroundColorAttributeName: kDarkNightColor} range:[totalString rangeOfString:NSLocalizedHome(@"paid")]];
        [attri1 setAttributes:@{NSFontAttributeName: UIFontMake(12), NSForegroundColorAttributeName: kBlackColor} range:[totalString rangeOfString:self.orderDetailModel.CryptoCode]];
        [attri1 setAttributes:@{NSFontAttributeName: UIFontMake(30), NSForegroundColorAttributeName: kDarkNightColor} range:[totalString rangeOfString:self.orderDetailModel.Amount]];
        self.topLabel.attributedText = attri1;
        
        self.orderNumLabel.text = self.orderDetailModel.OrderNo;
        self.orderTimeLabel.text = [NSString timespToSystemTimeZoneFormatSecond:self.orderDetailModel.Timestamp];
        
    } else if (self.pageType == PageSuccessWithdrawalApply) {
        // Withdraw
        
        self.topLabel.text = NSLocalizedWallet(@"withdrawal_request_submitted");
        self.topLabel.font = UIFontMake(16);
        self.contentView_H.constant = kProportionHeight(141);
        if (self.withdrawDict && self.withdrawDict.count > 0) {
            NSString *time = [NSString stringWithFormat:@"%@", self.withdrawDict[@"Timestamp"]];
            self.orderNumLabel.text = [NSString stringWithFormat:@"%@", self.withdrawDict[@"OrderNo"]];
            self.orderTimeLabel.text = [NSString timespToSystemTimeZoneFormatSecond:time];
        }
    } else if (self.pageType == PageSuccessWithTransfer) {
        
        NSString *transactionCompletedString = NSLocalizedString(@"paymentCompletedSuccesfullDescription", @"Transfer transaction completed succesfully description text");

        NSString *cryptoCode = self.transferDict[@"CoinName"];
        NSNumber *amount = self.transferDict[@"Amount"];
        NSUInteger decimalPlaceUInt = [((NSNumber*)self.transferDict[@"DecimalPlace"]) unsignedIntValue];
        
        NSString *formattedAmount = [DecimalUtils.shared stringInLocalisedFormatWithInput:amount.stringValue preferredFractionDigits:decimalPlaceUInt];
        NSString *totalString = [NSString stringWithFormat:@"%@\n\n%@ %@", transactionCompletedString, formattedAmount, cryptoCode];

        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:totalString];
        [attributedString setAttributes:@{NSFontAttributeName: kFontMediumWeight(24), NSForegroundColorAttributeName: kDarkNightColor} range:[totalString rangeOfString:transactionCompletedString]];
        [attributedString setAttributes:@{NSFontAttributeName: UIFontMake(12), NSForegroundColorAttributeName: kBlackColor} range:[totalString rangeOfString:cryptoCode]];
        [attributedString setAttributes:@{NSFontAttributeName: UIFontMake(30), NSForegroundColorAttributeName: kDarkNightColor} range:[totalString rangeOfString:formattedAmount]];
        self.topLabel.attributedText = attributedString;
        
        self.accountView.hidden = NO;
        self.nicknameView.hidden = YES;
        self.receiverAccountLabel.text = NSLocalizedDefault(@"receiver_account");
        if (SCREEN_HEIGHT == 480 || SCREEN_HEIGHT == 568) {
            self.contentView_H.constant = kProportionHeight(70);
        }
        if (self.transferDict &&
            [self.transferDict valueForKey:@"OrderNo"] && [self.transferDict valueForKey:@"Timestamp"] && [self.transferDict valueForKey:@"AccountName"]) {
            self.orderNumLabel.text = [NSString stringWithFormat:@"%@", [self.transferDict valueForKey:@"OrderNo"]];
            self.orderTimeLabel.text = [NSString timespToSystemTimeZoneFormatSecond:[self.transferDict valueForKey:@"Timestamp"]];
            self.accountLabel.text = [NSString stringWithFormat:@"%@", [self.transferDict valueForKey:@"AccountName"]];
            
            if ([self.transferDict valueForKey:@"NickName"] && ![[self.transferDict valueForKey:@"NickName"] isEqualToString:@""]){
                self.nicknameLabel.text = [self.transferDict valueForKey:@"NickName"];
                self.nicknameView.hidden = NO;
            }
        }
        [self configureDismissBarButtonItem];
    } else if (self.pageType == PageSuccessWithExchange) {
        // Transfer
        NSString *cryptoCode = self.dataDict[@"CryptoCode"];
        NSUInteger decimalPlace = [((NSNumber*)self.dataDict[@"DecimalPlace"]) unsignedIntValue];
        NSString *amount = [DecimalUtils.shared stringInLocalisedFormatWithInput:self.dataDict[@"Amount"] preferredFractionDigits:decimalPlace];
        
        NSString *transactionCompletedString = NSLocalizedString(@"paymentCompletedSuccesfullDescription", @"Transfer transaction completed succesfully description text");
        
        NSString *totalString = [NSString stringWithFormat:@"%@\n\n%@ %@", transactionCompletedString, amount, cryptoCode];
        NSMutableAttributedString *attri1 = [[NSMutableAttributedString alloc] initWithString:totalString];
        
        [attri1 setAttributes:@{NSFontAttributeName: kFontMediumWeight(24), NSForegroundColorAttributeName: kDarkNightColor} range:[totalString rangeOfString:transactionCompletedString]];
        [attri1 setAttributes:@{NSFontAttributeName: UIFontMake(12), NSForegroundColorAttributeName: kDarkNightColor} range:[totalString rangeOfString:cryptoCode]];
        [attri1 setAttributes:@{NSFontAttributeName: UIFontMake(30), NSForegroundColorAttributeName: kDarkNightColor} range:[totalString rangeOfString:amount]];
        self.topLabel.attributedText = attri1;
        
        self.orderNumLabel.text = self.dataDict[@"OrderNo"];
        self.orderTimeLabel.text = self.dataDict[@"Time"];
        [self configureDismissBarButtonItem];

    } else if (self.pageType == PageSuccessWithGPayExchange) {
        NSString *totalString = NSLocalizedDefault(@"exchange_completed");
        NSMutableAttributedString *attri1 = [[NSMutableAttributedString alloc] initWithString:totalString];
        
        [attri1 setAttributes:@{NSFontAttributeName: UIFontMake(18), NSForegroundColorAttributeName: kDarkNightColor} range:[totalString rangeOfString:totalString]];
        self.topLabel.attributedText = attri1;
        self.orderNumLabel.text = self.dataDict[@"OrderNo"];
        self.orderTimeLabel.text = self.dataDict[@"Time"];
    } else if (self.pageType == PageSuccessWithRequestFund) {
        [self configureDismissBarButtonItem];
        
        NSString *cryptoCode = self.dataDict[@"CoinName"];
        NSNumber *amount = self.dataDict[@"Amount"];
        NSUInteger decimalPlaceUInt = [((NSNumber*)self.dataDict[@"DecimalPlace"]) unsignedIntValue];
        
        NSString *formattedAmount = [DecimalUtils.shared stringInLocalisedFormatWithInput:amount.stringValue preferredFractionDigits:decimalPlaceUInt];
        NSString *transactionCompletedString = NSLocalizedString(@"paymentCompletedSuccesfullDescription", @"Transfer transaction completed succesfully description text");

        NSString *totalString = [NSString stringWithFormat:@"%@\n\n%@ %@", transactionCompletedString, formattedAmount, cryptoCode];

        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:totalString];
        [attributedString setAttributes:@{NSFontAttributeName: kFontMediumWeight(24), NSForegroundColorAttributeName: kDarkNightColor} range:[totalString rangeOfString:transactionCompletedString]];
        [attributedString setAttributes:@{NSFontAttributeName: UIFontMake(12), NSForegroundColorAttributeName: kBlackColor} range:[totalString rangeOfString:cryptoCode]];
        [attributedString setAttributes:@{NSFontAttributeName: UIFontMake(30), NSForegroundColorAttributeName: kDarkNightColor} range:[totalString rangeOfString:formattedAmount]];
        self.topLabel.attributedText = attributedString;
        
        self.orderTimeLabel.text = [NSString timespToSystemTimeZoneFormatSecond:[self.dataDict valueForKey:@"Timestamp"]];
        self.orderNumLabel.text = self.dataDict[@"OrderNo"];
//        self.receiverAccountLabel.isHidden = true;
//        self.accountLabel.text = self.dataDict[@"TransactionTypeName"];
        self.accountView.hidden = true;
        self.nicknameView.hidden = true;

    }
}

@end
