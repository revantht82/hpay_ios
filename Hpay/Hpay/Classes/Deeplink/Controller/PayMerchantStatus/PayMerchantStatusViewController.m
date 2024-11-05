#import "PayMerchantStatusViewController.h"
#import "HCPaymentCreateResponseModel.h"
#import "NSString+UTCTimeStamp.h"
#import "HCPayMerchantRouter.h"
#import "DecimalUtils.h"

@interface PayMerchantStatusViewController ()

@property(weak, nonatomic) IBOutlet UILabel *successLabel;
@property(weak, nonatomic) IBOutlet UILabel *amountLabel;

@property(weak, nonatomic) IBOutlet UILabel *transactionIdLabel;
@property(weak, nonatomic) IBOutlet UILabel *transactionIdValueLabel;

@property(weak, nonatomic) IBOutlet UILabel *transactionTimeLabel;
@property(weak, nonatomic) IBOutlet UILabel *transactionTimeValueLabel;

@property(weak, nonatomic) IBOutlet UIButton *doneButton;
@property(weak, nonatomic) IBOutlet UIButton *viewDetailsButton;

@property (weak, nonatomic) IBOutlet UIStackView *detailsStackView;

@property (weak, nonatomic) IBOutlet UIView *dividerView1;
@property (weak, nonatomic) IBOutlet UIView *dividerView2;
@property (weak, nonatomic) IBOutlet UIView *dividerView3;

@property(strong, nonatomic) HCPayMerchantRouter<HPPaymentMerchantRouterInterface> *router;

@end

@implementation PayMerchantStatusViewController

- (HCPayMerchantRouter<HPPaymentMerchantRouterInterface> *)router {
    if (_router == nil) {
        _router = [[HCPayMerchantRouter alloc] init];
        _router.currentControllerDelegate = self;
        _router.navigationDelegate = self.navigationController;
        _router.tabBarControllerDelegate = self.tabBarController;
    }
    return _router;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.paymentResponse) {
        // TODO: handle no payment response status just in case (even if It's nonnull)
        return;
    }
    
    [self configureUI];
}

- (void)configureUI {
    [self configureDismissBarButtonItem];
    
    NSString *cryptoCode = self.paymentResponse.coinName;
    NSString *amountString = [NSString stringWithFormat:@"%@",
                              [DecimalUtils.shared stringInLocalisedFormatWithInput:self.paymentResponse.amount preferredFractionDigits:2]];
    NSString *finalString = [NSString stringWithFormat:@"%@ %@", amountString, cryptoCode];
    NSMutableAttributedString *attri1 = [[NSMutableAttributedString alloc] initWithString:finalString];

    [attri1 setAttributes:@{NSFontAttributeName: UIFontMake(18), NSForegroundColorAttributeName: kDarkNightColor} range:[finalString rangeOfString:NSLocalizedHome(@"paid")]];
    [attri1 setAttributes:@{NSFontAttributeName: UIFontMake(12), NSForegroundColorAttributeName: 
kBlackColor} range:[finalString rangeOfString:cryptoCode]];
    [attri1 setAttributes:@{NSFontAttributeName: UIFontMake(30), NSForegroundColorAttributeName: kDarkNightColor} range:[finalString rangeOfString:amountString]];
    self.amountLabel.attributedText = attri1;

    self.transactionIdValueLabel.text = self.paymentResponse.orderNo;
    self.transactionTimeValueLabel.text = [NSString timespToSystemTimeZoneFormatSecond:[NSString stringWithFormat:@"%ld", (long)self.paymentResponse.timestamp]];
    
    self.transactionIdLabel.text = NSLocalizedString(@"pay_merchant_status.transaction_id_label", comment: @"Transaction id (title) label on Pay Merchant Status screen");
    self.transactionTimeLabel.text = NSLocalizedString(@"pay_merchant_status.transaction_time_label", comment: @"Transaction time (title) label on Pay Merchant Status screen");
    [self.doneButton setTitle:NSLocalizedString(@"done", comment: @"").uppercaseString forState:UIControlStateNormal];
    [self.viewDetailsButton setTitle:NSLocalizedString(@"view", comment: @"").uppercaseString forState:UIControlStateNormal];
    
    
    [self applyTheme];
}

-(void)applyTheme {
    
    id<ThemeProtocol> theme = [self getCurrentTheme];
    
    self.view.backgroundColor = theme.background;
    self.successLabel.textColor = theme.primaryOnBackground;
    self.amountLabel.textColor = theme.primaryOnBackground;
        
    self.transactionTimeValueLabel.textColor = theme.primaryOnBackground;
    self.transactionTimeLabel.textColor = theme.secondaryOnBackground;
    
    self.transactionIdValueLabel.textColor = theme.primaryOnBackground;
    self.transactionIdLabel.textColor = theme.secondaryOnBackground;
    
    self.dividerView1.backgroundColor = theme.verticalDivider;
    self.dividerView2.backgroundColor = theme.verticalDivider;
    self.dividerView3.backgroundColor = theme.verticalDivider;
    
    [self.doneButton setBackgroundColor:theme.primaryButton];
    [self.viewDetailsButton setBackgroundColor:theme.secondaryButton];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Dismiss Buttons

- (void)configureDismissBarButtonItem {
    self.navigationItem.hidesBackButton = NO;
    UIImage *dismissImage = [UIImage systemImageNamed:@"xmark"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:dismissImage style:UIBarButtonItemStylePlain target:self action:@selector(dismissButtonPressed)];
}

- (void)dismissButtonPressed {
    [self dismiss];
}

#pragma mark - Actions

- (IBAction)doneButtonDidTap:(id)sender {
    [self dismiss];
}

- (IBAction)viewDetailsButtonDidTap:(id)sender {
    [self.router pushToStatementDetailWithOrderId:self.paymentResponse.orderID replaceBackButtonWithDismiss:NO];
}

@end
