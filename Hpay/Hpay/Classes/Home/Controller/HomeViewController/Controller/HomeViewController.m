#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import "HomeHelperModel.h"
#import "FPRefreshGifHeader.h"
#import "ProfileHelperModel.h"
#import "FPUtils.h"
#import "FPHomeMenuSearchBar.h"
#import "HomeAccountListBaseView.h"
#import "AVUtils.h"
#import "NSString+URL.h"
#import "HPHomeRouter.h"
#import "FPHomeHeaderView.h"
#import "TermsConditionsViewController.h"
#import "PINSetViewController.h"
#import "Reachability.h"
#import "HCSSOHelper.h"
#import "LoginHelperModel.h"
#import "HimalayaAuthManager.h"
#import "HomeLoginView.h"
#import "FPStatementOM.h"
#import "StateViewModel.h"
#import "HimalayaAuthKeychainManager.h"
#import "HPDeeplinkData.h"
#import "HPDeeplinkParser.h"
#import "HPDeeplinkNavigator.h"
#import "NSObject+Extension.h"
#import "UIViewController+Alert.h"
#import "ApiError.h"
#import "ThemeManager.h"
#import "StatementViewController.h"
#import "HPAYAnalytics.h"

#import "HPAYBioAuth.h"

@interface HomeViewController () <UITextFieldDelegate, JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate, JXCategoryViewDelegate, FPHomeHeaderViewClickDelegate, FPHomeHeaderViewClickDelegate, QRCodeReaderDelegate, TermsConditionsViewControllerDelegate, HomeLoginViewDelegate>

@property(strong, nonatomic) NSArray <NSString *> *titles;
@property(strong, nonatomic) NSArray<__kindof HomeAccountListBaseView *> *pageViewList;
@property(strong, nonatomic) NSMutableArray *modelList;
@property(strong, nonatomic) NSMutableArray *otcModelList;
@property(strong, nonatomic) NSMutableArray *faitModelList;
@property(strong, nonatomic) UIImageView *bgImageView;
@property(strong, nonatomic) HomeLoginView *bottomUnLoginBgView;
@property(strong, nonatomic) UIImageView *bottomUnLoginImageView;
@property(strong, nonatomic) FPHomeMenuSearchBar *searchBar;
@property(strong, nonatomic) FPHomeHeaderView *topHeaderView;
@property(strong, nonatomic) FPIndexOM *homeModel;
@property(strong, nonatomic) JXPagerView *pagerView;
@property(strong, nonatomic) JXCategoryTitleView *categoryView;
@property(strong, nonatomic) UILabel *timeAgoLabel;
@property(strong, nonatomic) HPHomeRouter<HPHomeRouterInterface> *router;
@property(strong, nonatomic) NSTimer *lastTimeUpdatedTimer;
@property(strong, nonatomic) NSDate *lastTimeUpdated;
@property(strong, nonatomic) UIView *lineView;

@property(assign, nonatomic) BOOL isVisibleTotalCoin;
@property(assign, nonatomic) BOOL hasEXAccount;
@property(assign, nonatomic) BOOL hideZero;
@property(assign, nonatomic) BOOL isNeedHeader;
@property(assign, nonatomic) BOOL isNeedFooter;
@property(assign, nonatomic) BOOL isBarStyleLight;

@end

static const CGFloat kHomeHeadViewHeight = 250.0f;
static const CGFloat kSectionHeaderVerticalOffset = 0.0f;
static const CGFloat kCategoryTitleViewHeight = 50.0f;

@implementation HomeViewController

- (HPHomeRouter<HPHomeRouterInterface> *)router {
    if (_router == nil) {
        _router = [[HPHomeRouter alloc] init];
        _router.currentControllerDelegate = self;
        _router.navigationDelegate = self.navigationController;
        _router.tabBarControllerDelegate = self.tabBarController;
    }
    return _router;
}

#pragma mark - Lifecycle

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.isBarStyleLight) {
        return UIStatusBarStyleLightContent;
    }
    
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
    
    NSError *error;
    UserConfigResponse *userConfig = [HimalayaAuthKeychainManager loadUserConfigToKeychain:&error];
    [self.topHeaderView showAlert:userConfig.userHasNewNotifications];
    
    [[HPAYAnalytics sharedInstance] track:@"home_screen_appear"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self configureLastTimeUpdatedTimer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(linkServiceAction) name:kFPContactCSNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(coinBalanceDidChange) name:kCoinBalanceChangedNotification object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self.timeAgoLabel setText:NULL];
    [self resetLastTimeUpdatedTimer];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.pagerView.frame = self.view.safeAreaLayoutGuide.layoutFrame;
}

- (JXPagerView *)preferredPagingView {
    return [[JXPagerView alloc] initWithDelegate:self];
}

- (void)scrollToMenuSearchBar {
    CGFloat offsetY = kHomeHeadViewHeight - self.searchBar.height + self.categoryView.height + kHomeAccountListViewSearchSectionHeaderHeight;
    CGPoint point = CGPointMake(0, offsetY);
    UIScrollView *currentScrollView = self.pagerView.mainTableView;
    [currentScrollView setContentOffset:point animated:YES];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self applyTheme];
}

- (void)applyTheme{
    self.view.backgroundColor = [self getCurrentTheme].background;
    self.statefulViewController.view.backgroundColor = [UIColor clearColor];
    _lineView.backgroundColor = [self getCurrentTheme].primaryOnBackground;
    HomeAccountListBaseView *listView = self.pageViewList.firstObject;
    listView.tableView.backgroundColor = [self getCurrentTheme].background;
}

- (void)setupUI {
    NSNumber* height = [NSNumber numberWithFloat:self.view.frame.size.height - kHomeHeadViewHeight*1.5];
    [self configureViewStateHandlingWithAlignment:kAlignmentBottom
                                           height:height];
    
    [[UITableViewCell appearanceWhenContainedInInstancesOfClasses:@[[JXPagerMainTableView class]]] setBackgroundColor:[UIColor clearColor]];
    
    self.fd_prefersNavigationBarHidden = YES;
    self.hideZero = NO;
    FPHomeHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"FPHomeHeaderView" owner:nil options:nil].lastObject;
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kHomeHeadViewHeight);
    headerView.backgroundColor = [UIColor clearColor];
    
    headerView.delegate = self;
    self.topHeaderView = headerView;
    self.titles = @[NSLocalizedHome(@"home.account_list.heading")];
    
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kCategoryTitleViewHeight)];
    self.categoryView.averageCellSpacingEnabled = NO;
    self.categoryView.titles = self.titles;
    self.categoryView.backgroundColor = [UIColor clearColor];
    self.categoryView.delegate = self;
    self.categoryView.titleColorGradientEnabled = YES;
    self.categoryView.titleLabelZoomEnabled = NO;
    self.categoryView.titleColor = kDustyColor;
    self.categoryView.titleSelectedColor = kDustyColor;
    UIFont *categoryViewTitleFont = kFontSecondarySemibold(14.0);
    self.categoryView.titleFont = categoryViewTitleFont;
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(10, (kCategoryTitleViewHeight - 13) / 2, 2, 13)];
    [self.categoryView addSubview:_lineView];
    
    _pagerView = [self preferredPagingView];
    self.pagerView.pinSectionHeaderVerticalOffset = kSectionHeaderVerticalOffset;
    self.pagerView.mainTableView.gestureDelegate = self;
    [self.view addSubview:self.pagerView];
    self.pagerView.backgroundColor = self.pagerView.mainTableView.backgroundColor = [UIColor clearColor];
    
    self.categoryView.contentScrollView = self.pagerView.listContainerView.collectionView;
    self.categoryView.contentScrollView.backgroundColor = [UIColor clearColor];
    self.timeAgoLabel = [[UILabel alloc] init];
    [self.categoryView addSubview:self.timeAgoLabel];
    [self configureTimeAgoLabel];
    [self updateTimeAgoLabel];
    
    //When the navigation bar is hidden, to handle the buckle return, the following code should be added
    [self.pagerView.listContainerView.collectionView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    [self.pagerView.mainTableView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    [self.view addSubview:self.bgImageView];
    [self.view sendSubviewToBack:self.bgImageView];
    
    FPRefreshGifHeader *refreshHeader = [FPRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.pagerView.mainTableView.mj_header = refreshHeader;
    
    FPHomeMenuSearchBar *searchBar = [[NSBundle mainBundle] loadNibNamed:@"FPHomeMenuSearchBar" owner:self options:nil].lastObject;
    searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 157 - 50);
    searchBar.hidden = YES;
    [self.view addSubview:searchBar];
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(157 - 50);
    }];
    self.searchBar = searchBar;
    
    WS(weakSelf);
    [searchBar setHomeMenuSearchBarItemClick:^(NSInteger index) {
        [weakSelf.pagerView.listContainerView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        [weakSelf.categoryView selectItemAtIndex:index];
    }];
    
    if ([self isAuthorized]){
        [self configureUIForLoggedInUser];
        [self fetchWalletInfo];
        [self handleUserState];
        [self.topHeaderView hideBellBtn:NO];
    }else{
        [self configureUIForLogin];
        [self.topHeaderView hideBellBtn:YES];
    }
    
    [self applyTheme];
}

- (void)configureUIForLoggedInUser{
    self.pagerView.mainTableView.scrollEnabled = YES;
    self.pagerView.listContainerView.hidden = NO;
    self.pagerView.listContainerView.backgroundColor = [UIColor clearColor];
    [self hideLoginView];
    self.categoryView.hidden = NO;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
}

- (void)configureUIForLogin{
    self.pagerView.mainTableView.scrollEnabled = NO;
    self.pagerView.listContainerView.hidden = YES;
    [self showLoginView];
    [self.bottomUnLoginBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(350);
    }];
    
    self.categoryView.hidden = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
}

- (void)configureLastTimeUpdatedTimer{
    if (!self.lastTimeUpdatedTimer && self.homeModel){
        self.lastTimeUpdatedTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self updateTimeAgoLabel];
        }];
        [self.lastTimeUpdatedTimer fire];
    }
}

- (void)resetLastTimeUpdatedTimer{
    [self.lastTimeUpdatedTimer invalidate];
    self.lastTimeUpdatedTimer = NULL;
}

- (void)updateTimeAgoLabel{
    [self.timeAgoLabel setText:self.lastTimeUpdated.lastUpdateTimeString];
}

- (void)configureTimeAgoLabel{
    [self.timeAgoLabel setTextColor:kDustyColor];
    [self.timeAgoLabel setFont:[UIFont systemFontOfSize:12]];
    self.timeAgoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [[self.timeAgoLabel.topAnchor constraintEqualToAnchor:self.categoryView.topAnchor] setActive:YES];
    [[self.timeAgoLabel.bottomAnchor constraintEqualToAnchor:self.categoryView.bottomAnchor] setActive:YES];
    [[self.timeAgoLabel.trailingAnchor constraintEqualToAnchor:self.categoryView.trailingAnchor constant:-20] setActive:YES];
}

#pragma mark - Download Data

- (void)refreshData {
    [self fetchWalletInfo];
}

- (void)fetchWalletInfo {
    
    if (!self.homeModel) {
        [self showLoading];
    }
    
    [HomeHelperModel fetchHomePageIndexCompleteBlock:^(FPIndexOM *model, NSInteger errorCode, NSString *errorMessage) {
        [self.timeAgoLabel setText:NULL];
        self.lastTimeUpdated = NULL;
        [self resetLastTimeUpdatedTimer];
        [self hideStatefulView];
        [self.pagerView.mainTableView.mj_header endRefreshing];
        switch(errorCode){
            case kFPNetRequestSuccessCode:{
                self.homeModel = model;
                [self predicateFromCoinList];
                //Cache list data locally for currency filtering（statement）
                [FPUtils saveToCoinListToLocal:model.CurrencyItemList];
                self.lastTimeUpdated = [[NSDate alloc] init];
                [self configureLastTimeUpdatedTimer];
                break;
            }
            case kFPNetWorkErrorCode:{
                [self handleNetworkError];
                break;
            }
            case kErrorCodeInvalidKYC:{
                [self handleKYCError];
                break;
            }
            case kErrorCodeUserNotAllowed:
            case kErrorCodeUserNotAuthorized:
                return;
            case kErrorCodeMarketPriceNotAvailable:
                self.lastTimeUpdated = [[NSDate alloc] init];
                [self configureLastTimeUpdatedTimer];
                [self showAlertForMarketPriceNotAvailable];
                break;
            default:{
                [self handleApiError];
                break;
            }
        }
    }];
}

#pragma mark - Error utilities

-(void) showLoading{
    [self showLoadingState];
}

-(void) hideStatefulView{
    [self hideStatefulViewController];
}

- (void) handleKYCError{
    if (!self.bottomUnLoginBgView.isHidden){
        return;
    }
    [self showEmptyList];
    [self showCustomErrorWithViewModel:StateViewModel.kycErrorModel
                    primaryButtonTitle:NULL
                  secondaryButtonTitle:NULL
                   didTapPrimaryButton:NULL
                 didTapSecondaryButton:NULL];
}

- (void) handleNetworkError{
    if (!self.bottomUnLoginBgView.isHidden){
        return;
    }
    if (!self.homeModel) {
        [self showNetworkErrorWithPrimaryButtonTitle:StateViewModel.retryButtonTitle
                                secondaryButtonTitle:NULL
                                 didTapPrimaryButton:^(id  _Nonnull sender) {
            [self didTapRefresh:sender];
        } didTapSecondaryButton:NULL];
    }else{
        [self showAlertForConnectionFailure];
    }
}

- (void) handleApiError{
    if (!self.bottomUnLoginBgView.isHidden){
        return;
    }
    if (!self.homeModel) {
        [self showGenericApiErrorWithPrimaryButtonTitle:StateViewModel.retryButtonTitle
                                   secondaryButtonTitle:NULL
                                    didTapPrimaryButton:^(id  _Nonnull sender) {
            [self didTapRefresh:sender];
        } didTapSecondaryButton:NULL];
    }else{
        [self showApiErrorAlert];
    }
}

- (void)showApiErrorAlert{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:NSLocalizedString(@"pay_merchant_refresh.backend_error.title_label", @"")
                                          message:NSLocalizedString(@"unexpected_error", @"")
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"dismiss", @"")
                                                            style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:dismissAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void) openQRScanner {
    [self homeHeadViewClickWithType:HomeHeadViewClickTypeScan];
}

- (void)homeHeadViewClickWithType:(HomeHeadViewClickType)type {
    if (![self isNetworkConnected]){
        [self showAlertForNetworkError];
        return;
    }else if (![self isAuthorized]) {
        [self loginAction];
        return;
    }else if ([self isKYCNotVerified]) {
        [self presentKYCNotVerifiedAlert];
        return;
    }
    
    switch (type) {
        case HomeHeadViewClickTypeScan: {
            
            
//            ///REMOVE IT
//            NSError *jsonError;
//            NSString *json = @"{\"Message\":\"Some long long long long long long long long long long long long long long long long long error message from back-end about this error\",\"Code\":11110,\"Data\":{\"CoinName\":\"HDO\",\"Amount\":1.28,\"DecimalPlace\":2,\"Timestamp\":\"1701172700303\",\"Users\":[{\"Status\":true,\"ErrorCode\":10030,\"OrderNo\":\"\",\"AccountName\":\"P****c@g****l.com\",\"NickName\":\"nickname3\"},{\"Status\":true,\"ErrorCode\":0,\"OrderNo\":\"24602769988460997\",\"AccountName\":\"447*****803\",\"NickName\":\"nickname5\"},{\"Status\":false,\"ErrorCode\":10123,\"OrderNo\":\"\",\"AccountName\":\"+86*****345\",\"NickName\":\"\"},]}}";
//            
//            NSData *objectData = [json dataUsingEncoding:NSUTF8StringEncoding];
//            NSDictionary *testData = [NSJSONSerialization JSONObjectWithData:objectData
//                                                  options:NSJSONReadingMutableContainers
//                                                    error:&jsonError];
//            
//            [self.router presentGroupTransferPaySuccessPageWith:testData];
//            break;
//            /////////
            
            if (![AVUtils isAuthorisedForVideoAccess]) {
                [self.router showAlertWithMessage:NSLocalizedHome(@"camera_permission_error")
                                    actionHandler:^(UIAlertAction *_Nonnull action) {
                    [NSString openSettings];
                }];
            } else {
                [[HPAYAnalytics sharedInstance] track:@"home_scan_tap"];
                [self.router presentToQrCodeReader:self];
            }
        }
            break;
        case HomeHeadViewClickTypeTransfer:
            [[HPAYAnalytics sharedInstance] track:@"home_send_tap"];
            //[self.router pushToChooseCoinTransfer];
            [self.router pushToTransferWithCoin:nil userHash:nil];
            break;
        case HomeHeadViewClickTypeFiiiEX:
            [[HPAYAnalytics sharedInstance] track:@"home_transfer_tap"];
            [self.router pushToHuZhuan];
            break;
        case HomeHeadViewClickTypeRequest:
            [self.router pushToRequest];
            break;
        case HomeHeadViewClickTypeRequestIndividual:
            [[HPAYAnalytics sharedInstance] track:@"home_request_tap"];
            [self.router pushToRequestIndividual];
            break;
        case HomeHeadViewClickTypeBell:
            [self.router pushToNotificationCenter];
            break;
        default:
            break;
    }
}

#pragma mark - JXPagerViewDelegate

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.topHeaderView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return kHomeHeadViewHeight;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return kCategoryTitleViewHeight;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return self.categoryView.titles.count;
}

- (id <JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    if (!self.pageViewList) {
        HomeAccountListBaseView *wallet = [[HomeAccountListBaseView alloc] init];
        wallet.dataSource = self.homeModel.CurrencyItemList;
        self.pageViewList = @[wallet];
        
    }
    WS(weakSelf);
    HomeAccountListBaseView *listView = self.pageViewList[index];
    listView.tableView.backgroundColor = [self getCurrentTheme].background;
    
    listView.homeAccountListViewClickSearchTextFieldMaskBtn = ^{
        [weakSelf scrollToMenuSearchBar];
    };
    [listView setHomeAccountListViewClickHideZeroBtn:^(BOOL hideZero) {
        weakSelf.hideZero = hideZero;
        for (HomeAccountListBaseView *listView in weakSelf.pageViewList) {
            listView.hideZero = hideZero;
        }
        [weakSelf predicateFromCoinList];
        
    }];
    listView.naviController = self.navigationController;
    listView.isNeedHeader = NO;
    listView.visibleAmount = self.isVisibleTotalCoin;
    listView.fiatCurrency = self.homeModel.FiatCurrency;
    listView.isHeaderRefreshed = NO;
    [listView beginFirstRefresh];
    return listView;
}

- (void)showEmptyList{
    HomeAccountListBaseView *listView = self.pageViewList.firstObject;
    listView.isHeaderRefreshed = NO;
    [listView.tableView reloadData];
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
    if (index != self.searchBar.categoryView.selectedIndex) {
        [self.searchBar.categoryView selectItemAtIndex:index];
    }
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickedItemContentScrollViewTransitionToIndex:(NSInteger)index {
    [self.pagerView.listContainerView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = kHomeHeadViewHeight;
    self.searchBar.hidden = !(scrollView.mj_offsetY >= offsetY);
    self.isBarStyleLight = !self.searchBar.hidden;
    [self setNeedsStatusBarAppearanceUpdate];
    
    if (!self.searchBar.hidden) {
        [UIView performWithoutAnimation:^{
            [self.searchBar.categoryView selectItemAtIndex:self.categoryView.selectedIndex];
        }];
    }
}

#pragma mark - JXPagerMainTableViewGestureDelegate

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //When the categoryView is forbidden to slide left and right, you can scroll up and down and left and right
    if (otherGestureRecognizer == self.categoryView.collectionView.panGestureRecognizer) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

#pragma mark - UITextFieldValueChange

- (void)searchCoinValueChange:(UITextField *)textField {
    [self predicateFromCoinList];
    for (HomeAccountListBaseView *view in self.pageViewList) {
        view.searchText = textField.text;
        view.isHeaderRefreshed = NO;
        [view.tableView reloadData];
    }
}

- (void)predicateFromCoinList {
    NSPredicate *predicate = nil;
    NSPredicate *fiatPredicate = nil;
    
    [self.modelList removeAllObjects];
    [self.faitModelList removeAllObjects];
    [self.otcModelList removeAllObjects];
    if (predicate) {
        
        NSArray *filteredArray = [self.homeModel.CurrencyItemList filteredArrayUsingPredicate:predicate];
        if (filteredArray.count > 0) {
            [self.modelList addObjectsFromArray:filteredArray];
        }
        
        NSArray *filteredFaitArray = [self.homeModel.FiatCurrencyItemList filteredArrayUsingPredicate:fiatPredicate];
        if (filteredFaitArray.count > 0) {
            [self.faitModelList addObjectsFromArray:filteredFaitArray];
        }
        NSArray *filteredOTCArray = [self.homeModel.OTCCryptCurrencyItemList filteredArrayUsingPredicate:predicate];
        if (filteredOTCArray.count > 0) {
            [self.otcModelList addObjectsFromArray:filteredOTCArray];
        }
    } else {
        [self.modelList addObjectsFromArray:self.homeModel.CurrencyItemList];
        [self.faitModelList addObjectsFromArray:self.homeModel.FiatCurrencyItemList];
        [self.otcModelList addObjectsFromArray:self.homeModel.OTCCryptCurrencyItemList];
    }
    
    HomeAccountListBaseView *listView = self.pageViewList.firstObject;
    listView.dataSource = self.modelList;
    listView.isHeaderRefreshed = YES;
    listView.fiatCurrency = self.homeModel.FiatCurrency;
    [listView.tableView reloadData];
}

#pragma mark - QRCodeReaderDelegate

- (void)readerDidCancel:(QRCodeReaderViewController *)reader {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result {
    
    struct DeeplinkValidationResult parseResult = [HPDeeplinkParser validateDeeplinkWithURLString:result];
    
    NSString *orderId = [HPDeeplinkParser parseOrderIdFromQueryItems:parseResult.queryItems fullURL:result];
    
    if (!orderId || !parseResult.isValid) {
        AlertActionItem *cancelItem = [AlertActionItem defaultCancelItemWithHandler:^{
            [self.navigationController popViewControllerAnimated:true];
        }];
        
        AlertActionItem *okItem = [AlertActionItem actionWithTitle:NSLocalizedString(@"qr_scanner.invalid_qr.rescan_button.title", @"")
                                                             style:AlertActionStyleDefault
                                                           handler:^{
            [reader startScanning];
        }];
        
        [reader showAlertWithTitle:@""
                           message:NSLocalizedString(@"qr_scanner.invalid_qr.message", @"QR code scan invalid qr scan popup message")
                           actions:[NSArray arrayWithObjects:cancelItem, okItem, nil]];
        return;
    }
    
    [reader dismissViewControllerAnimated:NO completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (orderId) {
                if ([parseResult.route isEqualToString:@"GFashion"]){
                    [self.router presentPayMerchantWithOrderId:orderId];
                } else if ([parseResult.route isEqualToString:@"RequestPayment"]) {
                    [self.router presentPaymentRequestWithOrderId:orderId];
                } else if ([parseResult.route isEqualToString:@"UserQR"]) {
                    
                    [HomeHelperModel fetchUser:orderId completBlock:^(NSDictionary *message) {
                        if (message && [message objectForKey:@"IsTransferAbled"] ){
                            [self.router pushToChooseCoinTransferScan:orderId];
                        }
                        else {
                            AlertActionItem *cancelItem = [AlertActionItem defaultCancelItemWithHandler:^{
                                [reader dismissViewControllerAnimated:YES completion:nil];
                            }];
                            
                            AlertActionItem *okItem = [AlertActionItem actionWithTitle:NSLocalizedString(@"qr_scanner.invalid_qr.rescan_button.title", @"")
                                                                                 style:AlertActionStyleDefault
                                                                               handler:^{
                                [reader startScanning];
                            }];
                            
                            [reader showAlertWithTitle:@""
                                               message:NSLocalizedString(@"qr_scanner.invalid_qr.message", @"QR code scan invalid qr scan popup message")
                                               actions:[NSArray arrayWithObjects:cancelItem, okItem, nil]];
                            return;
                        }
                    }];
                    
                    


                }
            }
        });
    }];
}

#pragma mark - Personal information authentication

- (void)presentKYCNotVerifiedAlert {
    [self showKycAlert];
}

- (void)resetPassword {
    
}

- (void)linkServiceAction {
    [self.router.qrReaderController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Lazy Loading

- (NSMutableArray *)modelList {
    if (!_modelList) {
        _modelList = [[NSMutableArray alloc] init];
    }
    return _modelList;
}

- (NSMutableArray *)faitModelList {
    if (!_faitModelList) {
        _faitModelList = [[NSMutableArray alloc] init];
    }
    return _faitModelList;
}

- (NSMutableArray *)otcModelList {
    if (!_otcModelList) {
        _otcModelList = [NSMutableArray array];
    }
    return _otcModelList;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.contentMode = UIViewContentModeScaleToFill;
        CGFloat height = kHomeHeadViewHeight;
        _bgImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
        _bgImageView.backgroundColor = [UIColor clearColor];
    }
    return _bgImageView;
}

- (UIView *)bottomUnLoginBgView {
    if (!_bottomUnLoginBgView) {
        _bottomUnLoginBgView = [[HomeLoginView alloc] init];
        [_bottomUnLoginBgView setDelegate:self];
    }
    return _bottomUnLoginBgView;
}

#pragma mark - HomeLoginViewDelegate

- (void)didLoginTap{
    [self loginAction];
}

#pragma mark - StatefulViewController actions

- (void)didTapRefresh:(id)sender{
    [self refreshData];
}

#pragma mark - HimalayaAuthManagerStateDelegate

- (void)didStateFailedWithErrorCode:(NSInteger)errorCode{
    [self showAlertForNetworkError];
}

- (UserConfigResponse *)userConfig{
    NSError *error;
    return [HimalayaAuthKeychainManager loadUserConfigToKeychain:&error];
}

- (BOOL)isKYCNotVerified{
    UserConfigResponse *response = [self userConfig];
    return !response.isKYCVerified.boolValue;
}

- (HCIdentityUser *)userInfo{
    NSError *error;
    return [HimalayaAuthKeychainManager loadUserDataWithError:&error];
}

- (BOOL)isUserPinSet{
    HCIdentityUser *response = [self userInfo];
    return response.isPinSet.boolValue;
}

- (void)handleUserState{
    if ([self isUserNotAllowed]){
        NSString *message = [self getUserNotAllowedMessage];
        [self showUserNotAllowedAlertWithHandler:^{
            [self logout];
        } alertMessage:message];
    }else if (![self isUserPinSet]) {
        [self showPinSetVC];
    }else{
        [self showVerifyPinVC];
    }
}

- (BOOL)isUserNotAllowed{
    UserConfigResponse *response = [self userConfig];
    if([response.userState isEqualToString:@"USER_ALLOWED"]){
        return NO;
    }
    if([response.userState isEqualToString:@"USER_COUNTRY_NOT_ALLOWED"]){
        return YES;
    }
    if([response.userState isEqualToString:@"USER_BLOCKED"]){
        return YES;
    }
    if([response.userState isEqualToString:@"HPAY_BLOCKED"]){
        return YES;
    }
    return !response.isUserAllowed.boolValue;
}

-(NSString *)getUserNotAllowedMessage {
    UserConfigResponse *response = [self userConfig];
    if([response.userState isEqualToString:@"USER_COUNTRY_NOT_ALLOWED"]){
        return NSLocalizedString(@"user.isCountryNotAllowed.alert.description", @"The user is not allowed to use alert description");
    }
    if([response.userState isEqualToString:@"USER_BLOCKED"]){
        return NSLocalizedString(@"user.isBlocked.alert.description", @"The user is not allowed to use alert description");
    }
    if([response.userState isEqualToString:@"HPAY_BLOCKED"]){
        return NSLocalizedString(@"hpay.isBlocked.alert.description", @"The user is not allowed to use alert description");
    }
    return NSLocalizedString(@"user.isCountryNotAllowed.alert.description", @"The user is not allowed to use alert description");
}

- (void)showPinSetVC{
    PINSetViewController *vc = [SB_PROFILE instantiateViewControllerWithIdentifier:[PINSetViewController className]];
    vc.PINSetType = PINSetTypeVerifyFirstSetNewPIN;
    FPNavigationController *nav = [[FPNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Helpers

- (void)showLoginView{
    [self hideStatefulView];
    self.bottomUnLoginBgView.hidden = NO;
    [self.view addSubview:self.bottomUnLoginBgView];
}

- (void)hideLoginView{
    self.bottomUnLoginBgView.hidden = YES;
    [self.bottomUnLoginBgView removeFromSuperview];
}

- (void)logout {
    [[HimalayaAuthManager sharedManager] endSessionWithPresenter:self handler:^(OIDEndSessionResponse * _Nullable endSessionResponse, NSError * _Nullable endSessionError) {
        if (endSessionError) {
            NSString *genericErrorDescription = NSLocalizedString(@"unexpected_error", @"Show generic error happened on logOut process");
            [MBHUD showInView:self.view withDetailTitle:genericErrorDescription withType:HUDTypeError];
            return;
        }
        
        [self handleSuccessLogOut];
        
    }];
}

- (void)handleSuccessLogOut {
    [[GCUserManager manager] logOut];
    [self configureUIForLogin];
}

- (BOOL)isVisibleTotalCoin {
    return YES;
}

#pragma mark - TermsConditionsViewControllerDelegate

- (void)conditionsAccepted {
    
}

#pragma mark - kCoinBalanceChangedNotification

- (void)coinBalanceDidChange {
    [self refreshData];
}

@end
