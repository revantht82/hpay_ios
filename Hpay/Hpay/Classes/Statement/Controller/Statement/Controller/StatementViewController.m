#import "StatementViewController.h"
#import "StatementDetailViewController.h"
#import "StatementTableViewCell.h"
#import "StatementSectionHeaderView.h"
#import "FBCoin.h"
#import "FPRefreshGifHeader.h"
#import "StatementModelHelper.h"
#import "FPUtils.h"
#import "UIViewController+BackButtonHandler.h"
#import "HomeHelperModel.h"
#import "FPYearMonthPickView.h"
#import "StatementRouter.h"
#import "NTMonthYearPicker.h"
#import "NSString+Extension.h"
#import "StatementListKeyItem.h"
#import "ApiError.h"
#import "UIButton+ImageTitleSpacing.h"
#import "NTMonthYearPicker.h"
#import <SafariServices/SafariServices.h>
#import "WebViewController.h"

typedef enum {
    fromDate,
    toDate
} DateType;

@interface StatementViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, StatementDetailDelegate, NTMonthYearPickerViewDelegate>

@property(weak, nonatomic) IBOutlet UIView *altStateView;
@property(weak, nonatomic) IBOutlet UITableView *mTableView;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *tTopSpace;
@property(weak, nonatomic) IBOutlet UIImageView *altStateImageView;
@property(weak, nonatomic) IBOutlet UILabel *altStateTitle;
@property(weak, nonatomic) IBOutlet UILabel *altStateDescription;
@property(weak, nonatomic) IBOutlet UIButton *altStateRetryButton;

@property(weak, nonatomic) IBOutlet UIButton *fromDateBtn;
@property(strong, nonatomic) IBOutlet UIButton *toDateBtn;

@property(strong, nonatomic) StatementRouter<StatementRouterInterface> *router;

@property(assign, nonatomic) NSInteger pageIdx;

@property(strong, nonatomic) NSArray<NSString *> *sections;
@property(strong, nonatomic) NSDictionary *items;

@property(strong, nonatomic) NSString *fromDateString;
@property(strong, nonatomic) NSString *toDateString;

@property(strong, nonatomic) NSDate *fromDateDate;
@property(strong, nonatomic) NSDate *toDateDate;
@property (weak, nonatomic) IBOutlet UILabel *dashLabel;


- (IBAction)networkReloadEvent:(id)sender;

@end

static const CGFloat kTopMargin = 5.0f;



@implementation StatementViewController

- (StatementRouter<StatementRouterInterface> *)router {
    if (_router == nil) {
        _router = [[StatementRouter alloc] init];
        _router.currentControllerDelegate = self;
        _router.navigationDelegate = self.navigationController;
        _router.tabBarControllerDelegate = self.tabBarController;
    }
    return _router;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedDefault(@"transactionHistoryTitle");
    self.altStateRetryButton.layer.cornerRadius = 1;
    self.altStateRetryButton.layer.borderColor = kDarkNightColor.CGColor;
    self.altStateRetryButton.layer.borderWidth = 0.5;
    self.altStateRetryButton.layer.masksToBounds = YES;
    
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.mTableView registerNib:[UINib nibWithNibName:@"StatementTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"StatementTableViewCellId"];
    self.mTableView.tableFooterView = [UIView new];
    
    UIView *hv = [[UIView alloc] init];
    hv.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    hv.backgroundColor = [UIColor clearColor];
    self.mTableView.tableHeaderView = hv;
    FPRefreshGifHeader *gifHeader = [FPRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.mTableView.mj_header = gifHeader;
    self.mTableView.mj_footer = nil;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *today = [NSDate date];
    
    NSDateComponents *comps = [NSDateComponents new];
    comps.year = -1;
    NSDate *fromDate = [calendar dateByAddingComponents:comps toDate:today options:0];
    
    self.fromDateString = [dateFormat stringFromDate:fromDate];
    self.toDateString = [dateFormat stringFromDate:today];
    
    self.fromDateDate = fromDate;
    self.toDateDate = today;
    
    [self.fromDateBtn setTitle:self.fromDateString forState:UIControlStateNormal];
    [self.fromDateBtn addTarget:self action:@selector(fromDateSelection) forControlEvents:UIControlEventTouchUpInside];
    [self.fromDateBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
    
    [self.view bringSubviewToFront:self.fromDateBtn];
    //    self.fromDateBtn.hidden = YES;
    
    //    self.toDateBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.toDateBtn setTitle:self.toDateString forState:UIControlStateNormal];
    [self.toDateBtn addTarget:self action:@selector(toDateSelection) forControlEvents:UIControlEventTouchUpInside];
    [self.toDateBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
    
    [self.view bringSubviewToFront:self.toDateBtn];
    //    self.toDateBtn.hidden = YES;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessEvent) name:kLoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:kNoticeNotification object:nil];
    
    [self applyTheme];
    [self initData];
    
    UIButton *rightExportButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [rightExportButton.widthAnchor constraintEqualToConstant:25].active = YES;
    [rightExportButton.heightAnchor constraintEqualToConstant:25].active = YES;
    
    [rightExportButton addTarget:self action:@selector(exportButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [rightExportButton setImage:[UIImage imageNamed:@"statement_icon_export"] forState:UIControlStateNormal];
    UIBarButtonItem * rightButtonItem =[[UIBarButtonItem alloc] initWithCustomView:rightExportButton];
    [self.navigationItem setRightBarButtonItem:rightButtonItem animated:YES];
    self.navigationItem.rightBarButtonItems = @[rightButtonItem];
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    //[self.fromDateBtn setFrame:CGRectMake(80, 70, 125, 30)];
    //[self.toDateBtn setFrame:CGRectMake(SCREEN_WIDTH - 170, 70, 125, 30)];
}

- (void)applyTheme{
    id<ThemeProtocol> theme = self.getCurrentTheme;
    self.view.backgroundColor = theme.background;
    self.mTableView.separatorColor = theme.verticalDivider;
   
    [self.toDateBtn setTitleColor:theme.primaryOnBackground forState:UIControlStateNormal];
    self.toDateBtn.tintColor = theme.primaryOnBackground;
    self.toDateBtn.borderColor = theme.controlBorder;
    self.toDateBtn.backgroundColor = theme.background;
    self.toDateBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    
    [self.fromDateBtn setTitleColor:theme.primaryOnBackground forState:UIControlStateNormal];
    self.fromDateBtn.tintColor = theme.primaryOnBackground;
    self.fromDateBtn.borderColor = theme.controlBorder;
    self.fromDateBtn.backgroundColor = theme.background;
    self.fromDateBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    
    self.altStateTitle.textColor = theme.primaryOnBackground;
    self.altStateDescription.textColor = theme.secondaryOnBackground;
    [self.altStateRetryButton setBackgroundColor:theme.primaryButton];
    
    self.dashLabel.textColor = theme.primaryOnBackground;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self applyTheme];
}

-(void)moveToExport {
    [self.router pushToExport];
}

- (void)initData{
    self.sections = [[NSMutableArray alloc] init];
    self.items = [[NSMutableDictionary alloc] init];
    self.pageIdx = 0;
    if ([GCUserManager manager].isLogin) {
        [MBHUD showInView:self.view withDetailTitle:nil withType:HUDTypeLoading];
        [self fetchDataByPageIndex:self.pageIdx];
    }
}

- (void)loadNewData {
    if ([GCUserManager manager].isLogin) {
        self.pageIdx = 0;
        [self fetchDataByPageIndex:self.pageIdx];
    } else {
        [self endRefreshing];
    }
}

- (void)loadMoreData {
    if ([GCUserManager manager].isLogin) {
        [self fetchDataByPageIndex:self.pageIdx];
    } else {
        [self endRefreshing];
    }
}

- (void)endRefreshing{
    if (self.mTableView.mj_header.isRefreshing) {
        [self.mTableView.mj_header endRefreshing];
    }
    if (self.mTableView.mj_footer.isRefreshing) {
        [self.mTableView.mj_footer endRefreshing];
    }
}

- (void)fetchDataByPageIndex:(NSInteger)pageIndex {

    [StatementModelHelper fetchStatementListWithPageSize:kPageSize
                                            andPageIndex:pageIndex
                                            andFromDate:self.fromDateString
                                               andToDate: self.toDateString
                                           completeBlock:^(NSArray *statementList, NSInteger errorCode, NSString *errorMessage, NSInteger curPage) {
        [MBHUD hideInView:self.view];
        self.altStateView.hidden = YES;
        [self endRefreshing];
        if (errorCode == kFPNetRequestSuccessCode) {
            self.pageIdx++;
            [self handleSuccessWithItems:statementList];
        } else {
            [self handleErrorWithErrorCode:errorCode errorMessage:errorMessage hideTable:TRUE];
        }
    }];
}

- (void)handleSuccessWithItems:(NSArray<FPStatementOM *> *)items{
    BOOL empty = items.count == 0 && self.items.count == 0;
    
    self.mTableView.hidden = empty;
    self.toDateBtn.hidden = empty && self.fromDateString == nil;
    self.fromDateBtn.hidden = empty && self.fromDateString == nil;
    
    if (empty){
        [self showEmptyState];
        return;
    }
    
    [self handleTableFooterWithItems:items];
    [self prepareListWithItems:items];
    
    [self.mTableView reloadData];
}

- (void)handleTableFooterWithItems:(NSArray<FPStatementOM *> *)items{
    if (items.count == 0 || items.count < kPageSize){
        self.mTableView.mj_footer = nil;
    }else{
        self.mTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
}

- (void)prepareListWithItems:(NSArray<FPStatementOM *> *)items {
    NSMutableArray *keys = [self.sections mutableCopy];
    NSMutableDictionary *itemsDictionary = [self.items mutableCopy];
    
    [items enumerateObjectsUsingBlock:^(FPStatementOM * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = [obj dateGroupTitle];
        
        if ((keys.count == 0) || (keys[keys.count - 1] != key)) {
            [keys addObject:key];
            itemsDictionary[key] = [[NSMutableArray alloc] init];
        }
        
        [itemsDictionary[key] addObject:obj];
    }];
    self.sections = keys;
    self.items = itemsDictionary;
}

- (void)handleErrorWithErrorCode:(NSInteger)errorCode errorMessage:(NSString *)errorMessage hideTable:(BOOL)hideTable{
    [self endRefreshing];
    
    if (hideTable) {
        self.mTableView.hidden = YES;
    }
    //self.toDateBtn.hidden = YES;
    //self.fromDateBtn.hidden = YES;
    
    errorMessage ? [MBHUD showInView:self.view withDetailTitle:errorMessage withType:HUDTypeFailWithoutImage] : nil;
    if (errorCode == kFPNetWorkErrorCode) {
        [self showNetworkError];
    }else{
        ApiError* error = [ApiError errorWithCode:errorCode message:errorMessage];
        [self showApiErrorWithModel:error];
    }
}

- (void)showEmptyState{
    self.altStateImageView.image = [UIImage imageNamed:@"ic_tumbleweed"];
    self.altStateImageView.tintColor = [self getCurrentTheme].primaryOnBackground;
    self.altStateTitle.attributedText = [NSLocalizedString(@"transaction_history.no_data_state.title", comment: @"Transaction History screen title for no data state.") newLineAttributed];
    self.altStateDescription.text = NSLocalizedString(@"transaction_history.no_data_state.description", comment: @"Transaction History screen description for no data state");
    self.altStateRetryButton.hidden = YES;
    self.altStateView.hidden = NO;
    [self.view bringSubviewToFront:self.altStateView];
}

- (void)showNetworkError{
    self.altStateView.hidden = NO;
    self.altStateImageView.image = [UIImage imageNamed:@"ic_no_network"];
    self.altStateImageView.tintColor = [self getCurrentTheme].primaryOnBackground;
    self.altStateTitle.attributedText = [NSLocalizedString(@"pay_merchant_refresh.network_error.title_label", comment: @"") newLineAttributed];
    self.altStateDescription.text = NSLocalizedString(@"pay_merchant_refresh.network_error.description_label", comment: @"Transaction History screen description for no internet state");
    [self.altStateRetryButton setTitle:StateViewModel.retryButtonTitle.uppercaseString forState:UIControlStateNormal];
    [self.view bringSubviewToFront:self.altStateView];
}

- (void)showApiErrorWithModel:(ApiError *)error{
    self.altStateView.hidden = NO;
    self.altStateImageView.image = [UIImage imageNamed:@"icon_error"];
    self.altStateImageView.tintColor = [self getCurrentTheme].primaryOnBackground;
    self.altStateTitle.text = error.prettyTitle;
    self.altStateDescription.text = error.prettyMessage;
    [self.altStateRetryButton setTitle:StateViewModel.retryButtonTitle.uppercaseString forState:UIControlStateNormal];
    [self.view bringSubviewToFront:self.altStateView];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = self.sections[section];
    NSArray *items = self.items[key];
    return items.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    StatementSectionHeaderView *hv = [[StatementSectionHeaderView alloc] initWithReuseIdentifier:@"StatementSectionHeaderViewId"];
    NSString *key = self.sections[section];
    hv.titleLabel.text = [NSString stringWithFormat:@"%@", key];
    hv.backgroundColor = UIColor.orangeColor;
    return hv;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StatementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StatementTableViewCellId" forIndexPath:indexPath];
    NSString *key = self.sections[indexPath.section];
    FPStatementOM *item = self.items[key][indexPath.row];
    [cell setCellInfo:item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *key = self.sections[indexPath.section];
    FPStatementOM *item = self.items[key][indexPath.row];
    [self cellDidSelectWithFPStatementOM:item];
}

- (void)cellDidSelectWithFPStatementOM:(FPStatementOM *)statementOM {
    [self.router pushToStatementDetailWith:statementOM :self];
}

#pragma mark - Date filter filter click events

- (void)exportButtonPressed{
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay
            fromDate:self.fromDateDate toDate:self.toDateDate options: 0];
    NSInteger days = [components day];
    
    if (days > 365) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"transaction_history.too_large_range.title", nil) message:NSLocalizedString(@"transaction_history.too_large_range.desc", nil) preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"okay", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
        }];
        [alertController addAction:cancel];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    BOOL empty = self.items.count == 0;
    if (empty){
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"transaction_history.no_data_state.title", comment: @"Transaction History screen title for no data state.") message:NSLocalizedString(@"transaction_history.no_data_state.description", comment: @"Transaction History screen description for no data state") preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"okay", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
        }];
        [alertController addAction:cancel];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
//ONLY EXPORT AVAILABLE FOR NOW
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"transaction_history.popup.title", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

    }]];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"CSV" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self loadExportDocInFormat:@"csv"];
    }]];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"PDF" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self loadExportDocInFormat:@"pdf"];
    }]];
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
    
    
//SOA DISABLED FOR NOW
//    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"transaction_history.popup.select_type_title", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//
//    [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil]];
//
//    [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"transaction_history.popup.export_type", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"transaction_history.popup.title", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//
//        [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//
//        }]];
//
//        [actionSheet addAction:[UIAlertAction actionWithTitle:@"CSV" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            [self loadExportDocInFormat:@"csv"];
//        }]];
//
//        [actionSheet addAction:[UIAlertAction actionWithTitle:@"PDF" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            [self loadExportDocInFormat:@"pdf"];
//        }]];
//        // Present action sheet.
//        [self presentViewController:actionSheet animated:YES completion:nil];
//    }]];
//
//    [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"transaction_history.popup.soa_type", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"transaction_history.popup.title", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//
//        [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//
//        }]];
//
//        [actionSheet addAction:[UIAlertAction actionWithTitle:@"XLS" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            [self loadSOA:@"xls"];
//        }]];
//
//        [actionSheet addAction:[UIAlertAction actionWithTitle:@"PDF" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            [self loadSOA:@"pdf"];
//        }]];
//        // Present action sheet.
//        [self presentViewController:actionSheet animated:YES completion:nil];
//    }]];
//    // Present action sheet.
//    [self presentViewController:actionSheet animated:YES completion:nil];
    
    return;
}

- (void) loadSOA:(NSString*)format{
    [MBHUD showInView:self.view withDetailTitle:nil withType:HUDTypeLoading];
    
    [StatementModelHelper fetchSOAExportFromDate:self.fromDateString
                                       andToDate:self.toDateString
                                       andFormat:format
                                    completeBlock:^(NSString *URL, NSInteger errorCode, NSString *errorMessage) {
        [MBHUD hideInView:self.view];
        
        NSString *alert_title, *alert_desc;
        
        switch (errorCode) {
            case kErrorCode_SOAREQUEST_INPROCESS:{
                alert_title = NSLocalizedString(@"transaction_history.soa.request_in_progress.title", nil);
                alert_desc = NSLocalizedString(@"transaction_history.soa.request_in_progress.desc", nil);
                break;
            }
            case kErrorCode_SOA_DAILYREQUEST_THRESHOLD_REACHED:{
                alert_title = NSLocalizedString(@"transaction_history.soa.threshold.title", nil);
                alert_desc = NSLocalizedString(@"transaction_history.soa.threshold.desc", nil);
                break;
            }
            case kErrorCodeTooLongDateRangeToExport:{
                alert_title = NSLocalizedString(@"transaction_history.too_large_range.title", nil);
                alert_desc = NSLocalizedString(@"transaction_history.too_large_range.desc", nil);
                break;
            }
            case kFPNetRequestSuccessCode:{
                alert_title = NSLocalizedString(@"transaction_history.soa.success_title", nil);
                alert_desc = NSLocalizedString(@"transaction_history.soa.success_desc", nil);
                break;
            }
            default: {
                alert_title = NSLocalizedString(@"transaction_history.soa.error_title", nil);
                alert_desc = NSLocalizedString(@"transaction_history.soa.error_desc", nil);
            }
        }
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alert_title  message:alert_desc  preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okay = [UIAlertAction actionWithTitle:NSLocalizedString(@"okay", nil) style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okay];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    }];
    
}

- (void)loadExportDocInFormat:(NSString*)format{
    [MBHUD showInView:self.view withDetailTitle:nil withType:HUDTypeLoading];
    
    [StatementModelHelper fetchStatementExportFromDate:self.fromDateString
                                               andToDate:self.toDateString
                                             andFormat:format
                                           completeBlock:^(NSString *URL, NSString *filename, NSInteger errorCode, NSString *errorMessage) {
        [MBHUD hideInView:self.view];
        //self.altStateView.hidden = YES;
        //[self endRefreshing];
        
        if (errorCode == kErrorCodeTooLongDateRangeToExport) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"transaction_history.too_large_range.title", nil) message:NSLocalizedString(@"transaction_history.too_large_range.desc", nil) preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"okay", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
            }];
            [alertController addAction:cancel];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else if (URL == nil ) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"transaction_history.no_data.title", nil)  message:NSLocalizedString(@"transaction_history.no_data.desc", nil)  preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"okay", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
            }];
            [alertController addAction:cancel];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else if (errorCode == kFPNetRequestSuccessCode) {
//            NSURL *exportURL = [NSURL URLWithString:URL];
//            SFSafariViewController *safariController = [[SFSafariViewController alloc] initWithURL:exportURL];
//            [self.router present:safariController];
            WebViewController *webView = [[WebViewController alloc] init];
            webView.title = NSLocalizedString(@"transactionHistoryTitle", nil);
            webView.file = URL;
            webView.filename2save = filename;
            [self.navigationController pushViewController:webView animated:YES];
        } else {
            [self handleErrorWithErrorCode:errorCode errorMessage:errorMessage hideTable:FALSE];
        }
    }];
}

-(void)fromDateSelection {
    [self dateFilterEventWithDate:fromDate];
}

-(void)toDateSelection {
    [self dateFilterEventWithDate:toDate];
}

- (void)dateFilterEventWithDate:(DateType)dateType {
    MJWeakSelf
    FPYearMonthPickView *pickView = [[FPYearMonthPickView alloc] init];
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *minimumDate;
    if(dateType == fromDate) {
        [pickView.pickerView setMaximumDate:now];
        pickView.pickerView.date = [dateFormatter dateFromString: self.fromDateString];
        minimumDate = [calendar dateByAddingUnit:NSCalendarUnitYear value:-1 toDate:now options:NSCalendarWrapComponents];
    } else {
        pickView.currentDate = [dateFormatter dateFromString:self.toDateString];
        pickView.pickerView.date = [dateFormatter dateFromString: self.toDateString];
        minimumDate = [dateFormatter dateFromString:self.fromDateString];
    }
    pickView.pickerView.minimumDate = minimumDate;
    pickView.pickerView.maximumDate = now;
    
    pickView.doneBlock = ^(NSString *_Nonnull year, NSString *_Nonnull month, NSString *_Nonnull day) {
        NSString *selectedDate = [NSString stringWithFormat:@"%@-%@-%@", year, month, day];
        if (dateType == fromDate) {
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@-%@-%@", year, month, day]];
            
            NSComparisonResult result = [date compare:weakSelf.toDateDate];
            if(result == NSOrderedDescending) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"transaction_history.invalid_range.title", nil) message:NSLocalizedString(@"transaction_history.invalid_range.desc", nil) preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"okay", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
                }];
                [alertController addAction:cancel];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else {
                weakSelf.fromDateDate = date;
                weakSelf.fromDateString = selectedDate;
                [self.fromDateBtn setTitle:selectedDate forState:UIControlStateNormal];
            }
        } else {
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@-%@-%@", year, month, day]];
            
            NSDate *now = [NSDate now];
            NSInteger year_now = [calendar component:NSCalendarUnitYear fromDate:now];
            NSInteger month_now = [calendar component:NSCalendarUnitMonth fromDate:now];
            NSInteger day_now = [calendar component:NSCalendarUnitDay fromDate:now];
            
            now = [dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%ld-%ld", year_now, month_now, day_now]];
            
            NSComparisonResult result = [date compare:now];
            if(result == NSOrderedDescending) {
                year = [@(year_now) stringValue];
                month = [@(month_now) stringValue];
                day = [@(day_now) stringValue];
                date = now;
                selectedDate = [dateFormatter stringFromDate:date];
            }
            
            result = [weakSelf.fromDateDate compare:date];
            if(result == NSOrderedDescending) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"transaction_history.invalid_range.title", nil) message:NSLocalizedString(@"transaction_history.invalid_range.desc2", nil) preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"okay", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
                }];
                [alertController addAction:cancel];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else {
                weakSelf.toDateDate = date;
                weakSelf.toDateString = selectedDate;
                [self.toDateBtn setTitle:selectedDate forState:UIControlStateNormal];
            }
        }
        [self applySelectedDate:nil];
    };
//    pickView.pickerView.
    [pickView show];
    

}

-(IBAction)applySelectedDate:(id)sender {
    [self initData];

}

#pragma mark - Reset filter

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.mTableView) {
        [self updateHeaderItemsFrame];
    }
}

- (void)updateHeaderItemsFrame{
    //UIScrollView *scrollView = self.mTableView;
    //CGRect tableFrame = scrollView.frame;
    //CGFloat topY = CGRectGetMinY(tableFrame) + kTopMargin ;
//    CGFloat minY = MAX(topY, topY - scrollView.contentOffset.y);
}

#pragma mark - Login event

- (void)loginSuccessEvent {
    self.pageIdx = 0;
    [self fetchDataByPageIndex:self.pageIdx];
}

- (void)notification:(NSNotification *)notification {
    self.pageIdx = 0;
    [self fetchDataByPageIndex:self.pageIdx];
}

- (IBAction)networkReloadEvent:(id)sender {
    [MBHUD showInView:self.view withDetailTitle:nil withType:HUDTypeLoading];
    [self loadMoreData];
}

- (void)requestFundDidCanceled {
    [self initData];
}

- (void)didSelectDate {
    //NSLog(@"");
}


@end
