#import "StatementDetailViewController.h"
#import "StatementDetailHeaderView.h"
#import "StatementDetailFooterView.h"
#import "ReceiveRequestFooterView.h"
#import "QRCodeReaderViewController.h"
#import "StatementViewController.h"
#import "StatementDetailTableViewCell.h"
#import "FPStatementDetailOM.h"
#import "StatementModelHelper.h"
#import "FPUtils.h"
#import "AppEnum.h"
#import "FPSecurityAuthManager.h"
#import "UIViewController+BackButtonHandler.h"
#import "StatementDetailRouter.h"
#import "QRView.h"
#import "NSString+Regular.h"
#import "DecimalUtils.h"
#import "ApiError.h"
#import <SafariServices/SafariServices.h>
#import "WebViewController.h"

@interface StatementDetailViewController () <UITableViewDataSource, UITableViewDelegate, QRViewDelegate>

@property(weak, nonatomic) IBOutlet UITableView *mTableView;

@property(copy, nonatomic) NSString *url;
@property(copy, nonatomic) NSString *Id;
@property(strong, nonatomic) NSString *seugeIdentifier;
@property(strong, nonatomic) NSMutableArray *nameArr;
@property(strong, nonatomic) FPStatementDetailOM *detail;
@property(strong, nonatomic) StatementDetailHeaderView *headerView;
@property(strong, nonatomic) StatementDetailFooterView *footerView;
@property(strong, nonatomic) StatementDetailRouter<StatementDetailRouterInterface> *router;
@property(assign, nonatomic) StatementListType detailType;

@end

@implementation StatementDetailViewController

- (StatementDetailRouter<StatementDetailRouterInterface> *)router {
    if (_router == nil) {
        _router = [[StatementDetailRouter alloc] init];
        _router.currentControllerDelegate = self;
        _router.navigationDelegate = self.navigationController;
        _router.tabBarControllerDelegate = self.tabBarController;
    }
    return _router;
}

#pragma mark - Lazy initialization

- (StatementDetailHeaderView *)headerView {
    if (!_headerView) {
        self.headerView = [[NSBundle mainBundle] loadNibNamed:@"StatementDetailHeaderView" owner:nil options:nil].firstObject;
    }
    return _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem.backBarButtonItem setTitle:@""];
    self.navigationItem.title = NSLocalizedDefault(@"transaction_details");
    [self configureViewStateHandlingWithAlignment:kAlignmentFull height:NULL];
    [self initTableConfig];
    [self fetchDetail];
    
    UIButton *rightExportButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [rightExportButton.widthAnchor constraintEqualToConstant:25].active = YES;
    [rightExportButton.heightAnchor constraintEqualToConstant:25].active = YES;
    
    [rightExportButton addTarget:self action:@selector(exportButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [rightExportButton setImage:[UIImage imageNamed:@"statement_icon_export"] forState:UIControlStateNormal];
    UIBarButtonItem * rightButtonItem =[[UIBarButtonItem alloc] initWithCustomView:rightExportButton];
    [self.navigationItem setRightBarButtonItem:rightButtonItem animated:YES];
    self.navigationItem.rightBarButtonItems = @[rightButtonItem];
    
    [self applyTheme];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self applyTheme];
}

- (void)applyTheme {
    self.view.backgroundColor = [self getCurrentTheme].background;
    self.mTableView.backgroundColor = [self getCurrentTheme].background;
}

// Initial setup
- (void)initTableConfig {
    //112 footer
    //200 header
    UIView *hV = [[UIView alloc] init];
    hV.backgroundColor = [UIColor whiteColor];
    hV.frame = CGRectMake(0, 0, SCREEN_WIDTH, kProportionHeight(200));
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kProportionHeight(200));
    [hV addSubview:self.headerView];
    self.mTableView.tableHeaderView = hV;
    self.view.backgroundColor = [UIColor whiteColor];
    self.mTableView.estimatedRowHeight = 54;
    self.mTableView.rowHeight = UITableViewAutomaticDimension;
    self.mTableView.backgroundColor = [UIColor whiteColor];
    // Refund barcode is displayed under payment
    UIView *fV = [[UIView alloc] init];
    fV.frame = CGRectMake(0, 0, SCREEN_WIDTH, kProportionHeight(112));
    self.footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kProportionHeight(112));
    [fV addSubview:self.footerView];
    self.mTableView.tableFooterView = fV;
}

// Corresponding to the value of the key name on the left side of the details
- (void)configNameData {
    
    switch (self.detailType) {
        case StatementListInvalid:
            NSLog(@"Invalid statement type");
            break;
            
        case StatementListTypePay: // Payment
            self.nameArr = [@[@{@"name": NSLocalizedDefault(@"transaction_status"), @"nkey": @"StatusName", @"spColor": @"black"},
                              @{@"name": NSLocalizedDefault(@"vendor_name"), @"nkey": @"MerchantName", @"Calcula": @"Y"},
                              @{@"name": NSLocalizedDefault(@"paid_amount"), @"nkey": @"FiatAmount", @"unit": @"FiatCurrency"},
                              @{@"name": NSLocalizedDefault(@"premium_rate"), @"nkey": @"MarkUp"},
                              @{@"name": NSLocalizedDefault(@"currency"), @"nkey": @"CryptoCode"},
                              @{@"name": NSLocalizedDefault(@"exchange_rate"), @"nkey": @"ExchangeRate"},
                              @{@"name": NSLocalizedDefault(@"current_exchange_rate"), @"nkey": @"CurrentExchangeRate"},
                              @{@"name": NSLocalizedDefault(@"exchange_rate_growth"), @"nkey": @"IncreaseRate", @"isUplift": @"1"},
                              @{@"name": NSLocalizedDefault(@"paid_amount"), @"nkey": @"CryptoAmount", @"unit": @"CryptoCode"},
                              @{@"name": NSLocalizedDefault(@"transaction_time"), @"nkey": @"oTime"},
                              @{@"name": NSLocalizedDefault(@"transaction_no"), @"nkey": @"OrderNo"}] mutableCopy];
            break;
            
        case StatementListTypeDeposit: // Recharge
            self.nameArr = [@[@{@"name": NSLocalizedDefault(@"transaction_status"), @"nkey": @"StatusName", @"spColor": @"black"},
                              @{@"name": NSLocalizedDefault(@"confirmation_times"), @"nkey": @"CheckTime", @"spColor": @"black", @"tag": @"check"},
                              @{@"name": @"TxID", @"nkey": @"TransactionId", @"Calcula": @"Y", @"tag": @"trid", @"actionCopy": @"1"},
                              @{@"name": NSLocalizedDefault(@"currency"), @"nkey": @"CryptoCode"},
                              @{@"name": NSLocalizedDefault(@"transaction_time"), @"nkey": @"oTime"},
                              @{@"name": NSLocalizedDefault(@"transaction_no"), @"nkey": @"OrderNo"}] mutableCopy];
            break;
            
        case StatementListTypeWithdraw: // Withdraw
            
            self.nameArr = [@[@{@"name": NSLocalizedDefault(@"transaction_status"), @"nkey": @"StatusName", @"spColor": @"black"},
                              @{@"name": NSLocalizedDefault(@"confirmation_times"), @"nkey": @"CheckTime", @"spColor": @"black", @"tag": @"check"},
                              @{@"name": NSLocalizedDefault(@"address"), @"nkey": @"Address", @"Calcula": @"Y", @"actionCopy": @"1"},
                              @{@"name": NSLocalizedStatement(@"tag"), @"nkey": @"Tag"},
                              @{@"name": @"TxID", @"nkey": @"TransactionId", @"Calcula": @"Y", @"tag": @"trid", @"actionCopy": @"1"},
                              @{@"name": NSLocalizedDefault(@"currency"), @"nkey": @"CryptoCode"},
                              @{@"name": NSLocalizedDefault(@"commission"), @"nkey": @"TransactionFee", @"unit": @"CryptoCode"},
                              @{@"name": NSLocalizedDefault(@"transaction_time"), @"nkey": @"oTime"},
                              @{@"name": NSLocalizedDefault(@"transaction_no"), @"nkey": @"OrderNo"},
                              @{@"name": NSLocalizedDefault(@"remark"), @"nkey": @"Remark", @"Calcula": @"Y", @"tag": @"remark"}] mutableCopy];
            break;
            
        case StatementListTypeMerchantPaymentOut:
            self.nameArr = [@[@{@"name": NSLocalizedDefault(@"transaction_status"), @"nkey": @"StatusName", @"spColor": @"black"},
                              @{@"name": NSLocalizedDefault(@"transferDetail.transferOutType.fullName"), @"nkey": @"Fullname"},
                              @{@"name": NSLocalizedDefault(@"transaction_time"), @"nkey": @"oTime"},
                              @{@"name": NSLocalizedDefault(@"transaction_no"), @"nkey": @"OrderNo"},
                            ] mutableCopy];
            [self addNicknameIfNeed:NSLocalizedDefault(@"nickname.receiver")];
            break;
            
        case StatementListTypeMerchantRefund:
            self.nameArr = [@[@{@"name": NSLocalizedDefault(@"transaction_status"), @"nkey": @"StatusName", @"spColor": @"black"},
                              @{@"name": NSLocalizedDefault(@"transaction_time"), @"nkey": @"oTime"},
                              @{@"name": NSLocalizedDefault(@"transaction_no"), @"nkey": @"OrderNo"},
                              @{@"name": NSLocalizedDefault(@"sender_name"), @"nkey": @"Fullname"},
                            ] mutableCopy];
            [self addNicknameIfNeed:NSLocalizedDefault(@"nickname.sender")];
            break;
            
        case StatementListTypeMerchantRefundOut:
            self.nameArr = [@[@{@"name": NSLocalizedDefault(@"transaction_status"), @"nkey": @"StatusName", @"spColor": @"black"},
                              @{@"name": NSLocalizedDefault(@"transaction_time"), @"nkey": @"oTime"},
                              @{@"name": NSLocalizedDefault(@"transaction_no"), @"nkey": @"OrderNo"},
                              @{@"name": NSLocalizedDefault(@"receiver_name"), @"nkey": @"Fullname"},
                            ] mutableCopy];
            [self addNicknameIfNeed:NSLocalizedDefault(@"nickname.receiver")];
            break;
            
        case StatementListTypeMerchantPaymentIn:
            
            self.nameArr = [@[@{@"name": NSLocalizedDefault(@"transaction_status"), @"nkey": @"StatusName", @"spColor": @"black"},
                              @{@"name": NSLocalizedDefault(@"transaction_time"), @"nkey": @"oTime"},
                              @{@"name": NSLocalizedDefault(@"transaction_no"), @"nkey": @"OrderNo"},
                              @{@"name": NSLocalizedDefault(@"transferDetail.transferInType.fullName"), @"nkey": @"Fullname"},
                            ] mutableCopy];
            [self addNicknameIfNeed:NSLocalizedDefault(@"nickname.receiver")];
            break;
            
        case StatementListTypeTransferOut:   // Transfer-out
            
            self.nameArr = [@[@{@"name": NSLocalizedDefault(@"transaction_status"), @"nkey": @"StatusName", @"spColor": @"black"},
                              @{@"name": NSLocalizedDefault(@"transaction_time"), @"nkey": @"oTime"},
                              @{@"name": NSLocalizedDefault(@"transaction_no"), @"nkey": @"OrderNo"},
                              @{@"name": NSLocalizedDefault(@"receiver_account"), @"nkey": @"AccountName"},
                              @{@"name": NSLocalizedDefault(@"transferDetail.transferOutType.fullName"), @"nkey": @"Fullname"},
                            ] mutableCopy];
            [self addNicknameIfNeed:NSLocalizedDefault(@"nickname.receiver")];
            [self addGroupReferenceIfNeed:NSLocalizedDefault(@"GroupReference")];
            [self addNoteIfNeed];
            break;
            
        case StatementListTypeTransferIn: // Transfer-in
            self.nameArr = [@[@{@"name": NSLocalizedDefault(@"transaction_status"), @"nkey": @"StatusName", @"spColor": @"black"},
                              @{@"name": NSLocalizedDefault(@"transaction_time"), @"nkey": @"oTime"},
                              @{@"name": NSLocalizedDefault(@"transaction_no"), @"nkey": @"OrderNo"},
                              @{@"name": NSLocalizedDefault(@"transferDetail.transferInType.accountName"), @"nkey": @"AccountName"},
                              @{@"name": NSLocalizedDefault(@"transferDetail.transferInType.fullName"), @"nkey": @"Fullname"}
                            ] mutableCopy];
            [self addNicknameIfNeed:NSLocalizedDefault(@"nickname.sender")];
            [self addNoteIfNeed];
            break;
            
        case StatementListTypeGatewayOrderOutcome:
            self.nameArr = [@[@{@"name": NSLocalizedDefault(@"transaction_status"), @"nkey": @"StatusName", @"spColor": @"black"},
                              @{@"name": NSLocalizedDefault(@"vendor_name"), @"nkey": @"MerchantName", @"Calcula": @"Y"},
                              @{@"name": NSLocalizedDefault(@"currency"), @"nkey": @"CryptoCode"},
                              @{@"name": NSLocalizedDefault(@"paid_amount"), @"nkey": @"CryptoAmount", @"unit": @"CryptoCode"},
                              @{@"name": NSLocalizedDefault(@"transaction_time"), @"nkey": @"oTime"},
                              @{@"name": NSLocalizedDefault(@"transaction_no"), @"nkey": @"OrderNo"}] mutableCopy];
            break;
            
        case StatementListTypeGatewayOrderRefund:
            self.nameArr = [@[@{@"name": NSLocalizedDefault(@"transaction_status"), @"nkey": @"StatusName", @"spColor": @"red"},
                              @{@"name": NSLocalizedDefault(@"vendor_name"), @"nkey": @"MerchantName", @"Calcula": @"Y"},
                              @{@"name": NSLocalizedDefault(@"currency"), @"nkey": @"CryptoCode"},
                              @{@"name": NSLocalizedDefault(@"paid_amount"), @"nkey": @"CryptoAmount", @"unit": @"CryptoCode"},
                              @{@"name": NSLocalizedDefault(@"transaction_time"), @"nkey": @"oTime"},
                              @{@"name": NSLocalizedDefault(@"refund_time"), @"nkey": @"refundOTime"},
                              @{@"name": NSLocalizedDefault(@"transaction_no"), @"nkey": @"OrderNo"}] mutableCopy];
            break;
            
        case StatementListTypeGateway:
            self.nameArr = [@[@{@"name": NSLocalizedDefault(@"transaction_status"), @"nkey": @"StatusName", @"spColor": @"black"},
                              @{@"name": NSLocalizedDefault(@"vendor_name"), @"nkey": @"MerchantName", @"Calcula": @"Y"},
                              @{@"name": NSLocalizedDefault(@"currency"), @"nkey": @"CryptoCode"},
                              @{@"name": NSLocalizedDefault(@"transaction_amount"), @"nkey": @"CryptoAmount", @"unit": @"CryptoCode"},
                              @{@"name": NSLocalizedDefault(@"platform_commission"), @"nkey": @"TransactionFee", @"unit": @"CryptoCode"},
                              @{@"name": NSLocalizedDefault(@"amount_received"), @"nkey": @"ActualCryptoAmount", @"unit": @"CryptoCode"},
                              @{@"name": NSLocalizedDefault(@"transaction_time"), @"nkey": @"oTime"},
                              @{@"name": NSLocalizedDefault(@"transaction_no"), @"nkey": @"OrderNo"}] mutableCopy];
            break;
            
        case StatementListTypeGatewayBack:
            self.nameArr = [@[@{@"name": NSLocalizedDefault(@"transaction_status"), @"nkey": @"StatusName", @"spColor": @"red"},
                              @{@"name": NSLocalizedDefault(@"vendor_name"), @"nkey": @"MerchantName", @"Calcula": @"Y"},
                              @{@"name": NSLocalizedDefault(@"currency"), @"nkey": @"CryptoCode"},
                              @{@"name": NSLocalizedDefault(@"transaction_amount"), @"nkey": @"CryptoAmount", @"unit": @"CryptoCode"},
                              @{@"name": NSLocalizedDefault(@"platform_commission"), @"nkey": @"TransactionFee", @"unit": @"CryptoCode"},
                              @{@"name": NSLocalizedDefault(@"amount_received"), @"nkey": @"ActualCryptoAmount", @"unit": @"CryptoCode"},
                              @{@"name": NSLocalizedDefault(@"transaction_time"), @"nkey": @"oTime"},
                              @{@"name": NSLocalizedDefault(@"refund_time"), @"nkey": @"refundOTime"},
                              @{@"name": NSLocalizedDefault(@"transaction_no"), @"nkey": @"OrderNo"}] mutableCopy];
            break;
            
        case StatementListTypeGPayExchangeIn:
        case StatementListTypeGPayExchangeOut:
            // GPay flash redemption
            self.nameArr = [@[@{@"name": NSLocalizedDefault(@"type"), @"nkey": @"TransactionTypeName"},
                              @{@"name": NSLocalizedDefault(@"transaction_status"), @"nkey": @"StatusName", @"spColor": @"black"},
                              @{@"name": NSLocalizedDefault(@"original_token/currency"), @"nkey": @"FromCryptoCode"},
                              @{@"name": NSLocalizedDefault(@"exchange_to_token/currency"), @"nkey": @"ToCryptoCode"},
                              @{@"name": NSLocalizedDefault(@"pay"), @"nkey": @"fromAmountStr"},
                              @{@"name": NSLocalizedDefault(@"receive"), @"nkey": @"toAmountStr"},
                              @{@"name": NSLocalizedDefault(@"transaction_time"), @"nkey": @"oCreateTime"},
                              @{@"name": NSLocalizedDefault(@"transaction_no"), @"nkey": @"OrderNo"}] mutableCopy];
            break;
            
        case StatementListTypeGPayBuyCrpytoCode:
            // Buy coin
            self.nameArr = [@[@{@"name": NSLocalizedDefault(@"transaction_status"), @"nkey": @"StatusName", @"spColor": @"black"},
                              @{@"name": NSLocalizedDefault(@"payment_method"), @"nkey": @"PayTypeName"},
                              @{@"name": NSLocalizedDefault(@"purchase_token"), @"nkey": @"CryptoCode"},
                              @{@"name": NSLocalizedDefault(@"purchase_amount"), @"nkey": @"CryptoAmount", @"unit": @"CryptoCode"},
                              @{@"name": NSLocalizedDefault(@"Actual_Purchase"), @"nkey": @"ActualPayAmount", @"unit": @"CryptoCode"},
                              @{@"name": NSLocalizedDefault(@"transaction_no"), @"nkey": @"OrderNo"},
                              @{@"name": NSLocalizedDefault(@"transaction_detail"), @"nVal": NSLocalizedDefault(@"view"), @"spColor": @"lightBlue"}] mutableCopy];
            break;
            
        case StatementListTypeGPaySellCrpytoCode:
            // Sale coin
            self.nameArr = [@[@{@"name": NSLocalizedDefault(@"transaction_status"), @"nkey": @"StatusName", @"spColor": @"black"},
                              @{@"name": NSLocalizedDefault(@"method"), @"nkey": @"TranPayType"},
                              @{@"name": NSLocalizedDefault(@"sell_token"), @"nkey": @"CryptoCode"},
                              @{@"name": NSLocalizedDefault(@"amount"), @"nkey": @"SellingAmount", @"unit": @"CryptoCode"},
                              @{@"name": NSLocalizedDefault(@"receive"), @"nkey": @"GetFiatAmount", @"unit": @"FiatCode"},
                              @{@"name": NSLocalizedDefault(@"transaction_no"), @"nkey": @"OrderNo"},
                              @{@"name": NSLocalizedDefault(@"transaction_detail"), @"nVal": NSLocalizedDefault(@"view"), @"spColor": @"lightBlue"}] mutableCopy];
            break;
            
        case StatementListTypeHuazhuanOut:
        case StatementListTypeHuazhuanIn:
            // HEX transfer transfer out
            self.nameArr = [@[@{@"name": NSLocalizedDefault(@"transaction_status"), @"nkey": @"StatusName", @"spColor": @"black"},
                              @{@"name": NSLocalizedDefault(@"transaction_time"), @"nkey": @"oTime"},
                              @{@"name": NSLocalizedDefault(@"transaction_no"), @"nkey": @"OrderNo"}] mutableCopy];
            break;
            
        case StatementListTypeRequestFundIn:
            
            if ([_seugeIdentifier isEqualToString:@"StatementController"]) {
                self.nameArr = [@[@{@"name": NSLocalizedDefault(@"transaction_status"), @"nkey": @"StatusName", @"spColor": @"yellow"},
                                  @{@"name": NSLocalizedDefault(@"transaction_no"), @"nkey": @"OrderNo"},
                                  @{@"name": NSLocalizedDefault(@"transaction_time"), @"nkey": @"oCreationTimeStamp"}] mutableCopy];
                
                
                
                if (_detail.Status.integerValue == Complete) {
                    [self.nameArr addObject:@{@"name": NSLocalizedDefault(@"sender_account"), @"nkey": @"RelatedAccountName"}];
                    [self.nameArr addObject:@{@"name": NSLocalizedDefault(@"sender_name"), @"nkey": @"RelatedUserName"}];
                }
                [self addNicknameIfNeed:NSLocalizedDefault(@"nickname.sender")];
                
            } else {
                // Scan
                self.nameArr = [@[@{@"name": NSLocalizedDefault(@"transaction_status"), @"nkey": @"oStatusName", @"spColor": @"yellow"},
                                  @{@"name": NSLocalizedDefault(@"transaction_no"), @"nkey": @"TransactionId"},
                                  @{@"name": NSLocalizedDefault(@"request_time"), @"nkey": @"oCreationTimeStamp"},
                                  @{@"name": NSLocalizedDefault(@"Available_Balance"), @"nkey": @"oAvailableBalance"},
                                  @{@"name": NSLocalizedDefault(@"Receiver_name"), @"nkey": @"CorrespondingName"}] mutableCopy];
                [self addNicknameIfNeed:NSLocalizedDefault(@"nickname.receiver")];
            }
            
            if (_detail.Status.integerValue == Pending) {
                [self.nameArr insertObject:@{@"name": NSLocalizedDefault(@"expires_on"), @"nkey": @"oExpiredTimeStamp"} atIndex:3];
            }
            [self addNoteIfNeed];
            break;
            
        case StatementListTypeRequestPaymentIn:
            if ([_seugeIdentifier isEqualToString:@"StatementController"]) {
                self.nameArr = [@[@{@"name": NSLocalizedDefault(@"transaction_status"), @"nkey": @"StatusName", @"spColor": @"yellow"},
                                  @{@"name": NSLocalizedDefault(@"transaction_no"), @"nkey": @"OrderNo"},
                                  @{@"name": NSLocalizedDefault(@"transaction_time"), @"nkey": @"oCreationTimeStamp"},
                                  @{@"name": NSLocalizedDefault(@"product_category"), @"nkey": @"ProductCategory"}] mutableCopy];
                
                
                if (_detail.Status.integerValue == Complete) {
                    [self.nameArr addObject:@{@"name": NSLocalizedDefault(@"sender_account"), @"nkey": @"RelatedAccountName"}];
                    [self.nameArr addObject:@{@"name": NSLocalizedDefault(@"sender_name"), @"nkey": @"RelatedUserName"}];
                }
                [self addNicknameIfNeed:NSLocalizedDefault(@"nickname.sender")];
                
            } else {
                // Scan
                self.nameArr = [@[@{@"name": NSLocalizedDefault(@"transaction_status"), @"nkey": @"oStatusName", @"spColor": @"yellow"},
                                  @{@"name": NSLocalizedDefault(@"transaction_no"), @"nkey": @"TransactionId"},
                                  @{@"name": NSLocalizedDefault(@"request_time"), @"nkey": @"oCreationTimeStamp"},
                                  @{@"name": NSLocalizedDefault(@"Receiver_name"), @"nkey": @"CorrespondingName"},
                                  @{@"name": NSLocalizedDefault(@"product_category"), @"nkey": @"ProductCategory"},
                                  @{@"name": NSLocalizedDefault(@"Available_Balance"), @"nkey": @"oAvailableBalance"}] mutableCopy];
            }
            if (_detail.Status.integerValue == Pending) {
                [self.nameArr insertObject:@{@"name": NSLocalizedDefault(@"expires_on"), @"nkey": @"oExpiredTimeStamp"} atIndex:3];
            }
            
            [self addNoteIfNeed];
            break;
            
        case StatementListTypeRequestFundOut:
            
            self.nameArr = [@[@{@"name": NSLocalizedDefault(@"transaction_status"), @"nkey": @"StatusName", @"spColor": @"yellow"},
                              @{@"name": NSLocalizedDefault(@"transaction_time"), @"nkey": @"oCreationTimeStamp"},
                              @{@"name": NSLocalizedDefault(@"transaction_no"), @"nkey": @"OrderNo"},
                              @{@"name": NSLocalizedDefault(@"Receiver_name"), @"nkey": @"RelatedUserName"},
                              @{@"name": NSLocalizedDefault(@"Receiver_account"), @"nkey": @"RelatedAccountName"}] mutableCopy];
            [self addNicknameIfNeed:NSLocalizedDefault(@"nickname.receiver")];
            [self addNoteIfNeed];
            break;
            
        case StatementListTypeRequestPaymentOut:
            
            self.nameArr = [@[@{@"name": NSLocalizedDefault(@"transaction_status"), @"nkey": @"StatusName", @"spColor": @"yellow"},
                              @{@"name": NSLocalizedDefault(@"transaction_time"), @"nkey": @"oCreationTimeStamp"},
                              @{@"name": NSLocalizedDefault(@"transaction_no"), @"nkey": @"OrderNo"},
                              @{@"name": NSLocalizedDefault(@"product_category"), @"nkey": @"ProductCategory"},
                              @{@"name": NSLocalizedDefault(@"Receiver_name"), @"nkey": @"RelatedUserName"},
                              @{@"name": NSLocalizedDefault(@"Receiver_account"), @"nkey": @"RelatedAccountName"}] mutableCopy];
            [self addNicknameIfNeed:NSLocalizedDefault(@"nickname.receiver")];
            [self addNoteIfNeed];
            break;
            
        default:
            break;
    }
}

-(void)addNoteIfNeed {
    
    if (_detail.Reference && ![_detail.Reference isEqualToString:@""]) {
        [self.nameArr addObject:@{@"name": NSLocalizedDefault(@"Note"), @"nkey": @"Reference"}];
    }
    
    if (_detail.Notes && ![_detail.Notes isEqualToString:@""]) {
        [self.nameArr addObject:@{@"name": NSLocalizedDefault(@"Note"), @"nkey": @"Notes"}];
    }
    
    if (_detail.Note && ![_detail.Note isEqualToString:@""]) {
        [self.nameArr addObject:@{@"name": NSLocalizedDefault(@"Note"), @"nkey": @"Note"}];
    }
}

-(void)addNicknameIfNeed:(NSString*)title {
    if (_detail.NickName && ![_detail.NickName isEqualToString:@""]) {
        [self.nameArr addObject:@{@"name": title, @"nkey": @"NickName"}];
    }
}

-(void)addGroupReferenceIfNeed:(NSString*)title {
    if (_detail.GroupReference && ![_detail.GroupReference isEqualToString:@""]) {
        [self.nameArr addObject:@{@"name": title, @"nkey": @"GroupReference"}];
    }
}

- (void)exportButtonPressed{
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Please, select a format" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"CSV" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self loadExportDocInFormat:@"csv"];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"PDF" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self loadExportDocInFormat:@"pdf"];
    }]];
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
    
    return;
}

- (void)loadExportDocInFormat:(NSString*)format{
    [self showLoadingState];
    [StatementModelHelper fetchDetailById:self.Id withUrl:self.url andType:self.detailType andExport:format completeBlock:^(FPStatementDetailOM *detailModel, NSInteger errorCode, NSString *errorMessage) {
        [self hideStatefulViewController];
        
        if (errorCode == kFPNetRequestSuccessCode) {
//            NSURL *exportURL = [NSURL URLWithString:detailModel.filePath];
//            SFSafariViewController *safariController = [[SFSafariViewController alloc] initWithURL:exportURL];
//            [self.router present:safariController];
            //NSLog(@"%@", detailModel.filePath);
            WebViewController *webView = [[WebViewController alloc] init];
            webView.title = NSLocalizedString(@"transactionHistoryTitle", nil);
            webView.file = detailModel.filePath;
            webView.filename2save = [NSString stringWithFormat:@"%@.%@", detailModel.fileName, detailModel.fileType];
            [self.navigationController pushViewController:webView animated:YES];
        }else{
            UIAlertController *alertController = [UIAlertController
                alertControllerWithTitle:NSLocalizedString(@"pay_merchant_refresh.backend_error.title_label", comment:nil)
                message:NSLocalizedString(@"unexpected_error", comment:nil)
                preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"okay", comment:nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
            }];
            [alertController addAction:cancel];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

///Get details
- (void)fetchDetail {
    [self showLoadingState];
    [StatementModelHelper fetchDetailById:self.Id withUrl:self.url andType:self.detailType andExport:nil completeBlock:^(FPStatementDetailOM *detailModel, NSInteger errorCode, NSString *errorMessage) {
        if (errorCode == kFPNetRequestSuccessCode) {
            [self hideStatefulViewController];
            self.detail = detailModel;
            if (self.detailType == StatementListTypeWithdraw) {
                // Withdraw
                if (!self.detail.CheckTime) {
                    NSDictionary *dict = self.nameArr[2];
                    if (dict[@"tag"]) {
                        [self.nameArr removeObjectAtIndex:2];
                    }
                    // Determine whether there is an address label
                    BOOL hasTag = self.detail.NeedTag;
                    NSInteger i = 3;
                    if (hasTag && self.detail.Tag) {
                        // Tag
                        i = 4;
                    } else {
                        // No tag, remove tag
                        [self.nameArr removeObjectAtIndex:i];
                        
                    }
                    if (self.detail.SelfPlatform) {
                        NSDictionary *dict1 = self.nameArr[i];
                        if (dict1[@"tag"]) {
                            [self.nameArr removeObjectAtIndex:i];
                        }
                    }
                } else {
                    // Determine whether there is an address label
                    BOOL hasTag = self.detail.NeedTag;
                    NSInteger i = 4;
                    if (hasTag && self.detail.Tag) {
                        // Tag
                        i = 5;
                    } else {
                        // No tag, remove tag
                        [self.nameArr removeObjectAtIndex:i];
                    }
                    if (self.detail.SelfPlatform) {
                        NSDictionary *dict = self.nameArr[i];
                        if (dict[@"tag"]) {
                            [self.nameArr removeObjectAtIndex:i];
                        }
                    }
                }
                // Remove confirmations
                if ([self.detail.Status integerValue] == Pending) {
                    [self.nameArr removeObjectAtIndex:2];
                }
                if ([self.detail.Status integerValue] != 3) {
                    
                    NSDictionary *dict = self.nameArr.lastObject;
                    if (dict[@"tag"]) {
                        [self.nameArr removeLastObject];
                    }
                }
            } else if (self.detailType == StatementListTypeDeposit) {
                // Recharge
                if (self.detail.SelfPlatform) {
                    // Remove confirmations
                    NSDictionary *dict = self.nameArr[2];
                    if (dict[@"tag"]) {
                        [self.nameArr removeObjectAtIndex:2];
                    }
                    // Remove transaction ID
                    NSDictionary *dict1 = self.nameArr[2];
                    if (dict1[@"tag"]) {
                        [self.nameArr removeObjectAtIndex:2];
                    }
                } else {
                    // Judge whether it is completed outside the platform
                    if (self.detail.Status.integerValue == Pending) {
                        // Remove confirmations
                        NSDictionary *dict = self.nameArr[2];
                        if (dict[@"tag"]) {
                            [self.nameArr removeObjectAtIndex:2];
                        }
                    }
                }
            } else if (self.detailType == StatementListTypeTransferOut) {
                if ([NSString textIsEmpty:detailModel.Reference]) {
                    [self.nameArr removeLastObject];
                }
            } else if (self.detailType == StatementListTypeTransferIn) {
                if ([NSString textIsEmpty:detailModel.Reference]) {
                    [self.nameArr removeLastObject];
                }
            }
            if (self.detailType == StatementListInvalid) {
                StatementListType cType = [self.detail.TransactionTypeId integerValue];
                self.detailType = cType;
            }
            
            [self updateHeaderOrFooterDataUI];
            [self configNameData];
            [self.mTableView reloadData];
        }else{
            [self handleErrorWithErrorCode:errorCode message:errorMessage];
        }
    }];
}

- (void)handleErrorWithErrorCode:(NSInteger)code message:(NSString *)message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    alert.title = @"";
    UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedDefault(@"okay") style:UIAlertActionStyleDefault handler: ^(UIAlertAction * _Nonnull action) {
        [self.navigationController popToRootViewControllerAnimated:true];
    }];
    
    [alert addAction:ok];
    
    switch (code) {
        case kFPNetWorkErrorCode:{
            [self showNetworkErrorWithPrimaryButtonTitle:StateViewModel.retryButtonTitle
                                    secondaryButtonTitle:NULL
                                     didTapPrimaryButton:^(id  _Nonnull sender) {
                [self didTapRefresh:sender];
            } didTapSecondaryButton:NULL];
            break;
        }
            
        case kErrorCodePaymentOrderNotFound: {
            [self showOrderNotFoundErrorWithPrimaryButtonTitle:StateViewModel.okayButtonTitle
                                          secondaryButtonTitle:NULL
                                           didTapPrimaryButton:^(id  _Nonnull sender) {
                [self.navigationController popToRootViewControllerAnimated:true];
            } didTapSecondaryButton:NULL];
            return;
        }
            
        case kErrorCodePaymentCancelled: {
            alert.message = NSLocalizedDefault(@"request_cancel");;
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
            
        case kErrorCodePaymentExpired: {
            alert.message = NSLocalizedDefault(@"request_expired");
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
            
        case kErrorCodePaymentCompleted: {
            alert.message = NSLocalizedDefault(@"request_complete");
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
            
        case kErrorCodeTransferToSelf: {
            alert.message = NSLocalizedDefault(@"request_self_transfer");
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
            
        case kErrorCodePaymentInsufficientBalanceMerchant: {
            alert.message = NSLocalizedDefault(@"insufficient_balance");
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
            
        case kErrorCodePaymentInsufficientBalance: {
            alert.message = NSLocalizedDefault(@"insufficient_balance");
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
            
        case kErrorCodeMerchantRestricted: {
            alert.message = NSLocalizedDefault(@"merchant_is_restricted");
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
            
        case kErrorCodeRestrictedCountry: {
            alert.message = NSLocalizedDefault(@"your_account_is_not_located");
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        case kErrorCodeAccountRestrictedToRecieve: {
            alert.message = NSLocalizedDefault(@"the_account_you_are_trying");
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        case kErrorCodeReciverAccountInRestrictedCoutry: {
            alert.message = NSLocalizedDefault(@"the_account_you_are_trying_restricted_country");
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        case kErrorCodeUserAccountSuspended: {
            alert.message = NSLocalizedDefault(@"user_account_suspended_message");
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        default:{
            [self showGenericApiErrorWithPrimaryButtonTitle:StateViewModel.retryButtonTitle
                                       secondaryButtonTitle:NULL
                                        didTapPrimaryButton:^(id  _Nonnull sender) {
                [self didTapRefresh:sender];
            } didTapSecondaryButton:NULL];
            break;
        }
    }
}

- (void)updateHeaderOrFooterDataUI {
    if (self.detail) {
        self.headerView.amountLabel.text = @"";
        NSString *typeIcon = @"";
        
        switch (self.detailType) {
            case StatementListTypePay:
                // Payment
            {
                typeIcon = @"statement_details_icon_pay";
                self.headerView.typeName.text = self.detail.Type;
            }
                break;
                
            case StatementListTypeDeposit:
                // Recharge
                typeIcon = @"statement_details_icon_deposit";
                self.headerView.typeName.text = self.detail.Type;
                break;
            case StatementListTypeWithdraw:
                // Withdraw
                typeIcon = @"statement_details_icon_withdrawal";
                self.headerView.typeName.text = self.detail.Type;
                break;
            case StatementListTypeTransferOut:
            case StatementListTypeTransferIn:
                // Transfer
                typeIcon = @"statement_details_icon_transfer";
                self.headerView.typeName.text = self.detail.TradeType;
                break;
            case StatementListTypeGatewayOrderOutcome:
            case StatementListTypeGatewayOrderRefund:
                self.headerView.typeName.text = self.detail.Type;
                break;
            case StatementListTypeGateway:
            case StatementListTypeGatewayBack:
                // Gateway credit and refund
                self.headerView.typeName.text = self.detail.Type;
                break;
            case StatementListTypeGPayExchangeOut:
            case StatementListTypeGPayExchangeIn:
                self.headerView.typeName.text = NSLocalizedDefault(@"exchange");
                break;
            case StatementListTypeGPayBuyCrpytoCode:
                self.headerView.typeName.text = NSLocalizedDefault(@"purchase_token");
                break;
            case StatementListTypeGPaySellCrpytoCode:
                self.headerView.typeName.text = NSLocalizedDefault(@"sell_token");
                break;
            case StatementListTypeHuazhuanOut:
            case StatementListTypeHuazhuanIn:
                self.headerView.typeName.text = self.detail.TradeType;
                break;
            case StatementListTypeMerchantPaymentOut:
            case StatementListTypeMerchantPaymentIn:
                typeIcon = @"statement_details_icon_pay";
                self.headerView.typeName.text = self.detail.TradeType;
                break;
            case StatementListTypeMerchantRefund:
                self.headerView.typeName.text = self.detail.TradeType;
                break;
            case StatementListTypeMerchantRefundOut:
                self.headerView.typeName.text = self.detail.TradeType;
                break;
            case StatementListTypeRequestFundIn:
                self.headerView.typeName.text = self.detail.RequestType;
                break;
            case StatementListTypeRequestPaymentIn:
                self.headerView.typeName.text = NSLocalizedDefault(@"request");
                break;
            case StatementListTypeRequestFundOut:
                self.headerView.typeName.text = self.detail.RequestType;
                break;
            case StatementListTypeRequestPaymentOut:
                self.headerView.typeName.text = NSLocalizedDefault(@"request");
                break;
            default:
                break;
        }
        
        self.headerView.typeIcon.image = [UIImage imageNamed:typeIcon];
        
        BOOL showAttributedAmountText = StatementListTypeTransferOut == self.detailType
        || StatementListTypeTransferIn == self.detailType
        || StatementListTypeMerchantPaymentOut == self.detailType
        || StatementListTypeMerchantPaymentIn == self.detailType
        || StatementListTypeMerchantRefund == self.detailType
        || StatementListTypeMerchantRefundOut == self.detailType;
        
        if (showAttributedAmountText) {
            NSString* amountStr = [DecimalUtils.shared stringInLocalisedFormatWithInput:self.detail.Amount preferredFractionDigits:self.detail.DecimalPlace];
            NSString *coinStr = [NSString stringWithFormat:@"%@ %@",
                                 amountStr,
                                 self.detail.CoinCode];
            NSMutableAttributedString *coinAttrStr = [[NSMutableAttributedString alloc] initWithString:coinStr];
            [coinAttrStr addAttribute:NSFontAttributeName value:UIFontBoldMake(32) range:NSMakeRange(0, amountStr.length)];
            [coinAttrStr addAttribute:NSFontAttributeName value:UIFontMake(12) range:NSMakeRange(amountStr.length, coinStr.length - amountStr.length)];
            [coinAttrStr addAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} range:NSMakeRange(0, coinAttrStr.length)];
            self.headerView.amountLabel.attributedText = coinAttrStr;
        } else if (self.detailType == StatementListTypeRequestFundIn || self.detailType == StatementListTypeRequestPaymentIn || self.detailType == StatementListTypeRequestFundOut || self.detailType == StatementListTypeRequestPaymentOut) {
            NSString* amountStr = [DecimalUtils.shared stringInLocalisedFormatWithInput:self.detail.Amount preferredFractionDigits:self.detail.DecimalPlace];
            NSString *coinStr = [NSString stringWithFormat:@"%@ %@",
                                 amountStr,
                                 self.detail.CoinName];
            NSMutableAttributedString *coinAttrStr = [[NSMutableAttributedString alloc] initWithString:coinStr];
            [coinAttrStr addAttribute:NSFontAttributeName value:UIFontBoldMake(32) range:NSMakeRange(0, amountStr.length)];
            [coinAttrStr addAttribute:NSFontAttributeName value:UIFontMake(12) range:NSMakeRange(amountStr.length, coinStr.length - amountStr.length)];
            [coinAttrStr addAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} range:NSMakeRange(0, coinAttrStr.length)];
            self.headerView.amountLabel.attributedText = coinAttrStr;
            
            if (_seugeIdentifier == nil) {
                if(self.detail.Status.intValue == Expired) {
                    [self.headerView.expirationView setHidden:true];
                }
            }
            
        } else if (self.detailType == StatementListTypeGPayExchangeIn || self.detailType == StatementListTypeGPayExchangeOut) {
            NSString *fromStr = [NSString stringWithFormat:@"- %@  %@", self.detail.FromAmount, self.detail.FromCryptoCode];
            NSMutableAttributedString *fromAttrStr = [[NSMutableAttributedString alloc] initWithString:fromStr];
            [fromAttrStr addAttribute:NSFontAttributeName value:UIFontBoldMake(32) range:NSMakeRange(0, fromStr.length)];
            [fromAttrStr addAttribute:NSFontAttributeName value:UIFontMake(12) range:[fromStr rangeOfString:self.detail.FromCryptoCode]];
            NSString *toStr = [NSString stringWithFormat:@"\n+ %@  %@", self.detail.ToAmount, self.detail.ToCryptoCode];
            NSMutableAttributedString *toAttrStr = [[NSMutableAttributedString alloc] initWithString:toStr];
            [toAttrStr addAttribute:NSFontAttributeName value:UIFontBoldMake(32) range:NSMakeRange(0, toStr.length)];
            [toAttrStr addAttribute:NSFontAttributeName value:UIFontMake(12) range:[toStr rangeOfString:self.detail.ToCryptoCode]];
            NSMutableAttributedString *attar = [[NSMutableAttributedString alloc] initWithAttributedString:fromAttrStr];
            [attar appendAttributedString:toAttrStr];
            [attar addAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} range:NSMakeRange(0, attar.length)];
            self.headerView.amountLabel.attributedText = attar;
            
        } else {
            NSString *cryptoCode = self.detail.Code;
            if (cryptoCode.length == 0) {
                cryptoCode = self.detail.CryptoCode;
            }
            NSString *amount = self.detail.CryptoAmount;
            if (amount.length == 0) {
                amount = [DecimalUtils.shared stringInLocalisedFormatWithInput:self.detail.Amount preferredFractionDigits:self.detail.DecimalPlace];
            }
            if (amount.length == 0) {
                amount = self.detail.SellingAmount;
            }
            NSString *coinStr = [NSString stringWithFormat:@"%@  %@", amount, cryptoCode];
            NSMutableAttributedString *coinAttrStr = [[NSMutableAttributedString alloc] initWithString:coinStr];
            [coinAttrStr addAttribute:NSFontAttributeName value:UIFontBoldMake(32) range:NSMakeRange(0, amount.length)];
            [coinAttrStr addAttribute:NSFontAttributeName value:UIFontMake(12) range:NSMakeRange(amount.length, coinStr.length - amount.length)];
            [coinAttrStr addAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} range:NSMakeRange(0, coinAttrStr.length)];
            self.headerView.amountLabel.attributedText = coinAttrStr;
        }
    }
}

// Initial pass value
- (void)configWithType:(StatementListType)detailType andId:(NSString *)ID andUrl:(NSString *)url {
    self.detailType = detailType;
    self.url = url;
    self.Id = ID;
}

// Initial pass value
- (void)configForFundRequestWithType:(StatementListType)detailType andId:(NSString *)ID andUrl:(NSString *)url {
    self.detailType = detailType;
    self.url = url;
    self.Id = ID;
}

- (void)configForFundRequestWithType:(StatementListType)detailType andId:(NSString *)ID andUrl:(NSString *)url andSeuge:(NSString*)seugeIdentifier {
    self.seugeIdentifier = seugeIdentifier;
    self.detailType = detailType;
    self.url = url;
    self.Id = ID;
}

#pragma mark - Dismiss Buttons

- (void)configureDismissBarButtonItem {
    self.navigationItem.hidesBackButton = NO;
    UIImage *dismissImage = [UIImage systemImageNamed:@"xmark"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:dismissImage style:UIBarButtonItemStylePlain target:self action:@selector(dismissButtonPressed)];
}

- (void)dismissButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.nameArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StatementDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StatementDetailTableViewCellId" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.nameArr && self.nameArr.count > indexPath.section) {
        //Green rise: 03C087 Orange drop: E76D42
        NSDictionary *dict = self.nameArr[indexPath.section];
        if (dict[@"actionCopy"] && [dict[@"actionCopy"] isEqualToString:@"1"]) {
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        NSString *nkey = dict[@"nkey"];
        NSString *nVal = dict[@"nVal"];
        NSString *unit = dict[@"unit"];
        NSString *spColor = dict[@"spColor"];
        NSString *isUplift = dict[@"isUplift"];
        NSString *hasNullVal = dict[@"nullVal"];
        
        if (spColor) {
            if ([spColor isEqualToString:@"black"]) {
                cell.valLabel.textColor = [self getCurrentTheme].primaryOnBackground;
                cell.valLabel.font = UIFontBoldMake(cell.valLabel.font.pointSize);
            } else if ([spColor isEqualToString:@"red"]) {
                cell.valLabel.textColor = kCranberryColor;
            } else if ([spColor isEqualToString:@"pink"]) {
                cell.valLabel.textColor = kCranberryColor;
            } else if ([spColor isEqualToString:@"lightBlue"]) {
                cell.valLabel.userInteractionEnabled = YES;
                cell.valLabel.tag = indexPath.section;
                cell.valLabel.textColor = UIColorFromRGB(0x6D87A8);
            } else if ([spColor isEqualToString:@"yellow"]) {
                if (self.detail.Status.integerValue == Pending) {
                    cell.valLabel.textColor = [self getCurrentTheme].pendingStatus;
                } else {
                    cell.valLabel.textColor = [self getCurrentTheme].secondaryOnBackground;
                }
            }
        } else {
            cell.valLabel.textColor = kDustyColor;
        }
        cell.nameLabel.text = dict[@"name"];
        if (self.detail) {
            if (nVal) {
                cell.valLabel.text = nVal;
            } else {
                if (nkey) {
                    NSString *str = [self.detail valueForKey:nkey];
                    if (unit) {
                        cell.valLabel.text = [NSString stringWithFormat:@"%@ %@", str, [self.detail valueForKey:unit]];
                    } else {
                        BOOL hasCharCode = NO;
                        if (isUplift) {
                            hasCharCode = YES;
                            NSString *uplift = [self.detail valueForKey:@"IncreaseRate"];
                            // Judge whether it is up or down, up green, down red
                            if ([uplift rangeOfString:@"+"].location != NSNotFound) {
                                // Green rise: 03C087
                                cell.valLabel.textColor = UIColorFromRGB(0x03C087);
                            } else if ([uplift rangeOfString:@"-"].location != NSNotFound) {
                                // Orange drop: E76D42
                                cell.valLabel.textColor = kCranberryColor;
                            }
                        }
                        if (hasCharCode) {
                            if ([str isEqualToString:@"--"]) {
                                cell.valLabel.text = str;
                            } else {
                                cell.valLabel.text = [NSString stringWithFormat:@"%@%%", str];
                            }
                            
                        } else {
                            if ((!str || str.length == 0) && hasNullVal && hasNullVal.length > 0) {
                                cell.valLabel.text = hasNullVal;
                            } else {
                                cell.valLabel.text = str;
                            }
                        }
                    }
                }
            }
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.nameArr && self.nameArr.count > indexPath.section) {
        NSDictionary *dict = self.nameArr[indexPath.section];
        if (dict[@"actionCopy"] && [dict[@"actionCopy"] isEqualToString:@"1"]) {
            NSString *nkey = dict[@"nkey"];
            if (self.detail) {
                if (nkey) {
                    NSString *str = [self.detail valueForKey:nkey];
                    AlertActionItem *cancelItem = [AlertActionItem defaultCancelItem];
                    AlertActionItem *copyItem = [AlertActionItem actionWithTitle:NSLocalizedDefault(@"copy")
                                                                           style:AlertActionStyleDefault
                                                                         handler:^{
                        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                        pasteboard.string = str;
                        [MBHUD showInView:self.view withDetailTitle:NSLocalizedDefault(@"copy_success") withType:HUDTypeFailWithoutImage];
                    }];
                    
                    [self showAlertWithTitle:@""
                                     message:@""
                                     actions:[NSArray arrayWithObjects:cancelItem, copyItem, nil]];
                }
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.nameArr && self.nameArr.count > section) {
        NSDictionary *dict = self.nameArr[section];
        if (dict[@"sectionHeaderSep"] && [dict[@"sectionHeaderSep"] isEqualToString:@"1"]) {
            return 10;
        }
    }
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor whiteColor];
    if (self.nameArr && self.nameArr.count > section) {
        NSDictionary *dict = self.nameArr[section];
        if (dict[@"sectionHeaderSep"] && [dict[@"sectionHeaderSep"] isEqualToString:@"1"]) {
            v.frame = CGRectMake(0, 0, SCREEN_WIDTH, 10);
            v.backgroundColor = kCloudColor;
        }
    }
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == tableView.numberOfSections - 1) {
        return 150.00;
    }
    return 0.00;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    StatementListType statementListType = self.detailType;
    NSString  *statusCode = self.detail.Status;
    
    if (section == tableView.numberOfSections - 1) {
        if (statementListType == StatementListTypeRequestFundIn || statementListType == StatementListTypeRequestPaymentIn) {
            
            if ([_seugeIdentifier isEqualToString:@"StatementController"]) {
                StatementDetailFooterView *footerView = [[NSBundle mainBundle] loadNibNamed:@"StatementDetailFooterView" owner:nil options:nil].firstObject;
                if (statusCode.integerValue == Pending) {
                    [footerView.viewQRButton addTarget:self action:@selector(viewQR) forControlEvents:UIControlEventTouchUpInside];
                    [footerView.cancelButton addTarget:self action:@selector(cancelConfirmation) forControlEvents:UIControlEventTouchUpInside];
                    return footerView;
                }
            } else {
                ReceiveRequestFooterView *receiveRequestFooterView = (ReceiveRequestFooterView*)[[NSBundle mainBundle] loadNibNamed:@"ReceiveRequestFooterView" owner:nil options:nil].firstObject;
                if (statusCode.integerValue == Pending) {
                    [receiveRequestFooterView.rejectButton addTarget:self action:@selector(rejectRequest) forControlEvents:UIControlEventTouchUpInside];
                    [receiveRequestFooterView.approveButton addTarget:self action:@selector(approveRequest) forControlEvents:UIControlEventTouchUpInside];
                    return receiveRequestFooterView;
                } else {
                    return  nil;
                }
            }
        }
    }
    return nil;
}


#pragma mark - Fund request methods

-(void) viewQR {
    
    QRView *qrView = [[[NSBundle mainBundle] loadNibNamed:@"QRView" owner:self options:nil] lastObject];
    if (qrView) {
        qrView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [qrView configurViewWithItem:@{@"DeepLink":_detail.DeepLink, @"CoinName": _detail.CoinName, @"Amount": _detail.Amount}];
        qrView.delegate = self;
        
        [UIView animateWithDuration:3.2 animations:^{
            qrView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:qrView];
            
        } completion:^(BOOL finished){
        }];
        
    }
}

-(void) cancelConfirmation {
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@""
                                 message:NSLocalizedDefault(@"RequestFund.Receive.Reject")
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* confirmButton = [UIAlertAction
                                    actionWithTitle:NSLocalizedDefault(@"confirm")
                                    style:UIAlertActionStyleCancel
                                    handler:^(UIAlertAction * action) {
        [self cancelFundRequest];
    }];
    
    UIAlertAction* cancelButton = [UIAlertAction
                                   actionWithTitle:NSLocalizedDefault(@"Cancel")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
    }];
    
    
    [alert addAction:cancelButton];
    [alert addAction:confirmButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) cancelFundRequest {
    
    [StatementModelHelper cancelFundRequest:self.Id withUrl:CancelRequestFundURL  completionBlock:^(NSInteger errorCode, NSString *errorMessage) {
        if (errorCode == kFPNetRequestSuccessCode) {
            [self.navigationController popViewControllerAnimated:true];
            [self->_delegate requestFundDidCanceled];
        } else {
            [self handleErrorWithErrorCode:errorCode message:errorMessage];
            
        }
    }];
}

-(void) doneFundRequest:(id)sender {
    
    [self.navigationController popViewControllerAnimated:true];
}

-(void)approveRequest {
    FPSecurityAuthManager *authManager = nil;
    authManager = [[FPSecurityAuthManager alloc] init];
    authManager.isOnlyVerifyPin = YES;
    [authManager securityAuth];
    [authManager setSecurityAuthSuccessBlock:^(NSString *securityPssaword) {
        [StatementModelHelper approveFundRequest:self.Id withUrl:ApproveFundRequestURL  completionBlock:^(NSDictionary *dict, NSInteger errorCode, NSString *errorMessage) {
            if (errorCode == kFPNetRequestSuccessCode) {
                [self.router pushToPaymentSuccessfulWith: dict];
            } else {
                [self handleErrorWithErrorCode:errorCode message:errorMessage];
            }
        }];
    }];
}
-(void)rejectRequest {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedDefault(@"RequestFund.Receive.Reject") preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedDefault(@"Cancel") style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *reject = [UIAlertAction actionWithTitle:NSLocalizedDefault(@"confirm") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self rejectNotification];
    }];
    [alert addAction:cancel];
    [alert addAction:reject];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)rejectNotification {
    
    UIAlertController *rejectNotif = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedDefault(@"Request.Receive.Reject.Ack") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedDefault(@"got_it") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popToRootViewControllerAnimated:true];
    }];
    [rejectNotif addAction:ok];
    [self presentViewController:rejectNotif animated:YES completion:nil];
}


#pragma mark - QR delegate methods

- (void)doneButtonPressed:(UIButton*)sender {
    [UIView animateWithDuration:0.2 animations:^{
        sender.superview.frame = CGRectMake(0, self.view.frame.size.height, self.view.size.width, 0) ;
    } completion:^(BOOL finished){
        [sender.superview removeFromSuperview];
    }];
    
}

- (void)shareButtonPressed:(NSString *)linkString :(NSString *)amount :(UIImage *)QRCodeImage {
    HCIdentityUser *user = [GCUserManager manager].user;
    
    NSString *greatingString = [NSString stringWithFormat: NSLocalizedDefault(@"Dear_Sir"), user.name, amount, linkString];
    
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
    webView.title = NSLocalizedDefault(@"transaction_details");
    webView.file = filePath;
    webView.filename2save = [NSString stringWithFormat:@"%@.%@", fileName, fileType];
    [self.router pushTo:webView];
}


#pragma mark - StatefulViewController actions

- (void)didTapRefresh:(id)sender{
    [self fetchDetail];
}

@end

