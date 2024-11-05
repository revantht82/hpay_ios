#import "NotificationCenterViewController.h"
#import "NotificationCenterTableViewCell.h"
#import "NotificationCenterSectionHeaderView.h"
#import "FBCoin.h"
#import "FPRefreshGifHeader.h"
#import "NotificationCenterModelHelper.h"
#import "FPUtils.h"
#import "UIViewController+BackButtonHandler.h"
#import "HomeHelperModel.h"
#import "FPYearMonthPickView.h"
#import "NTMonthYearPicker.h"
#import "NSString+Extension.h"
#import "NotificationCenterListKeyItem.h"
#import "ApiError.h"
#import "FPNotificationCenterOM.h"
#import "UserConfigResponse.h"
#import "HimalayaAuthKeychainManager.h"
#import "WebViewController.h"

@interface NotificationCenterViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property(weak, nonatomic) IBOutlet UIView *altStateView;
@property(weak, nonatomic) IBOutlet UITableView *mTableView;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *tTopSpace;
@property(weak, nonatomic) IBOutlet UIImageView *altStateImageView;
@property(weak, nonatomic) IBOutlet UILabel *altStateTitle;
@property(weak, nonatomic) IBOutlet UILabel *altStateDescription;
@property(weak, nonatomic) IBOutlet UIButton *altStateRetryButton;

@property(strong, nonatomic) UIButton *dateFilterBtn;
@property(strong, nonatomic) UIButton *resetConditionBtn;

@property(assign, nonatomic) NSInteger pageIdx;
@property(assign, nonatomic) NSInteger userHasNewMessages;

@property(strong, nonatomic) NSArray<NSString *> *sections;
@property(strong, nonatomic) NSDictionary *items;

@property(copy, nonatomic) NSString *selectedDateString;

- (IBAction)networkReloadEvent:(id)sender;

@end

static const CGFloat kTopMargin = 5.0f;

@implementation NotificationCenterViewController


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"notification_center.screen_title", comment: @"");
    
    self.altStateRetryButton.layer.cornerRadius = 1;
    self.altStateRetryButton.layer.borderColor = kDarkNightColor.CGColor;
    self.altStateRetryButton.layer.borderWidth = 0.5;
    self.altStateRetryButton.layer.masksToBounds = YES;
    
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.mTableView registerNib:[UINib nibWithNibName:@"NotificationCenterTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"NotificationCenterTableViewCellId"];
    self.mTableView.tableFooterView = [UIView new];
    
    CGFloat barH = 0;
    
    UIView *hv = [[UIView alloc] init];
    hv.frame = CGRectMake(0, 0, SCREEN_WIDTH, barH);
    hv.backgroundColor = [UIColor clearColor];
    self.mTableView.tableHeaderView = hv;
    FPRefreshGifHeader *gifHeader = [FPRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.mTableView.mj_header = gifHeader;
    self.mTableView.mj_footer = nil;
    
    self.dateFilterBtn = [UIButton systemButtonWithImage:[UIImage imageNamed:@"NotificationCenter_icon_calendar"] target:self action:@selector(dateFilterEvent)];
    [self.view addSubview:self.dateFilterBtn];
    [self.view bringSubviewToFront:self.dateFilterBtn];
    self.dateFilterBtn.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessEvent) name:kLoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:kNoticeNotification object:nil];
    
    [self applyTheme];
    [self initData];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    CGRect tableFrame = self.mTableView.frame;
    self.dateFilterBtn.frame = CGRectMake(SCREEN_WIDTH - 45, CGRectGetMinY(tableFrame) + kTopMargin, 30, 30);
    self.resetConditionBtn.frame = CGRectMake(SCREEN_WIDTH - 45 - 70, CGRectGetMinY(tableFrame) + kTopMargin, 60, 30);
}

- (void)applyTheme{
    id<ThemeProtocol> theme = self.getCurrentTheme;
    self.view.backgroundColor = theme.background;
    self.mTableView.separatorColor = theme.verticalDivider;
    self.dateFilterBtn.tintColor = theme.primaryOnBackground;
    [self.resetConditionBtn setTitleColor:theme.primaryOnBackground forState:UIControlStateNormal];
    
    self.altStateTitle.textColor = theme.primaryOnBackground;
    self.altStateDescription.textColor = theme.secondaryOnBackground;
    [self.altStateRetryButton setBackgroundColor:theme.primaryButton];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self applyTheme];
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
        self.sections = [[NSMutableArray alloc] init];
        self.items = [[NSMutableDictionary alloc] init];
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

    [NotificationCenterModelHelper fetchNotificationCenterListWithPageSize:kPageSize
                                            andPageIndex:pageIndex
                                           completeBlock:^(NSArray *NotificationCenterList, NSInteger errorCode, NSString *errorMessage, NSInteger curPage) {
        [MBHUD hideInView:self.view];
        self.altStateView.hidden = YES;
        [self endRefreshing];
        if (errorCode == kFPNetRequestSuccessCode) {
            self.pageIdx++;
            [self handleSuccessWithItems:NotificationCenterList];
        } else {
            [self handleErrorWithErrorCode:errorCode errorMessage:errorMessage];
        }
    }];
}

- (void)handleSuccessWithItems:(NSArray<FPNotificationCenterOM *> *)items{
    BOOL empty = items.count == 0 && self.items.count == 0;
    
    self.mTableView.hidden = empty;
    self.dateFilterBtn.hidden = empty && self.selectedDateString == nil;
    self.resetConditionBtn.hidden = self.selectedDateString == nil;
    
    if (empty){
        [self showEmptyState];
        return;
    }
    
    [self handleTableFooterWithItems:items];
    [self prepareListWithItems:items];
    
    [self.mTableView reloadData];
}

- (void)handleTableFooterWithItems:(NSArray<FPNotificationCenterOM *> *)items{
    if (items.count == 0 || items.count < kPageSize){
        self.mTableView.mj_footer = nil;
    }else{
        self.mTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
}

- (void)prepareListWithItems:(NSArray<FPNotificationCenterOM *> *)items {
    NSMutableArray *keys = [self.sections mutableCopy];
    NSMutableDictionary *itemsDictionary = [self.items mutableCopy];
    
    [items enumerateObjectsUsingBlock:^(FPNotificationCenterOM * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = [obj dateGroupTitle];
        
        if (obj && [obj.IsRead isEqualToString:@"0"]) {
            _userHasNewMessages = _userHasNewMessages + 1;
        }
        
        if ((keys.count == 0) || (keys[keys.count - 1] != key)) {
            [keys addObject:key];
            itemsDictionary[key] = [[NSMutableArray alloc] init];
        }
        
        [itemsDictionary[key] addObject:obj];
    }];
    
    NSError *error;
    if (!error) {
        UserConfigResponse *userConfig = [HimalayaAuthKeychainManager loadUserConfigToKeychain:&error];
        userConfig.userHasNewNotifications = [NSNumber numberWithLong:_userHasNewMessages];
        [HimalayaAuthKeychainManager saveUserConfigToKeychain:userConfig];
    }
    
    self.sections = keys;
    self.items = itemsDictionary;
}

- (void)handleErrorWithErrorCode:(NSInteger)errorCode errorMessage:(NSString *)errorMessage{
    [self endRefreshing];
    
    self.mTableView.hidden = YES;
    self.dateFilterBtn.hidden = YES;
    self.resetConditionBtn.hidden = YES;
    
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
    self.altStateTitle.attributedText = [NSLocalizedString(@"notification_center.no_data_state.title", comment: @"Notification center screen title for no data state.") newLineAttributed];
    self.altStateDescription.text = NSLocalizedString(@"notification_center.no_data_state.description", comment: @"Notification centerscreen description for no data state");
    self.altStateRetryButton.hidden = YES;
    self.altStateView.hidden = NO;
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
    NotificationCenterSectionHeaderView *hv = [[NotificationCenterSectionHeaderView alloc] initWithReuseIdentifier:@"NotificationCenterSectionHeaderViewId"];
    NSString *key = self.sections[section];
    hv.titleLabel.text = [NSString stringWithFormat:@"%@", key];
    return hv;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NotificationCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationCenterTableViewCellId" forIndexPath:indexPath];
    NSString *key = self.sections[indexPath.section];
    FPNotificationCenterOM *item = self.items[key][indexPath.row];
    [cell setCellInfo:item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *key = self.sections[indexPath.section];
    FPNotificationCenterOM *item = self.items[key][indexPath.row];
    if ([item.IsRead isEqualToString:@"0"]) {
        item.IsRead = @"1";
        _userHasNewMessages = _userHasNewMessages - 1;
        
        NSError *error;
        if (!error) {
            UserConfigResponse *userConfig = [HimalayaAuthKeychainManager loadUserConfigToKeychain:&error];
            userConfig.userHasNewNotifications = [NSNumber numberWithLong:_userHasNewMessages];
            [HimalayaAuthKeychainManager saveUserConfigToKeychain:userConfig];
        }
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [self cellDidSelectWithFPNotificationCenterOM:item];
    
}

- (void)cellDidSelectWithFPNotificationCenterOM:(FPNotificationCenterOM *)item {
    
    [NotificationCenterModelHelper UpdateAnnouncementReadFlag:item.NotificationId completeBlock:^(NSInteger errorCode, NSString *errorMessage) {
            //ignore result
    }];
    
    WebViewController *webView = [[WebViewController alloc] init];
    webView.html = item.Message;
    webView.title = item.Title;
    [self.navigationController pushViewController:webView animated:YES];
    
}



#pragma mark - Reset filter
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.mTableView) {
        [self updateHeaderItemsFrame];
    }
}

- (void)updateHeaderItemsFrame{
    UIScrollView *scrollView = self.mTableView;
    CGRect tableFrame = scrollView.frame;
    CGFloat topY = CGRectGetMinY(tableFrame) + kTopMargin ;
    CGFloat minY = MAX(topY, topY - scrollView.contentOffset.y);
    [self.dateFilterBtn setY:minY];
    [self.resetConditionBtn setY:minY];
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

@end
