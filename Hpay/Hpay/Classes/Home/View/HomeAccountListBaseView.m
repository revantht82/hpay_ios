#import "HomeAccountListBaseView.h"

@interface HomeAccountListBaseView () <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, copy) void (^scrollCallback)(UIScrollView *scrollView);
@property(nonatomic, strong) NSIndexPath *lastSelectedIndexPath;
@end

@implementation HomeAccountListBaseView

static NSString *const kHomeTableViewCellID = @"HomeTableViewCell";

- (void)dealloc {
    self.scrollCallback = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _isHeaderRefreshed = NO;

        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        self.tableView.backgroundColor = kCloudColor;
        self.tableView.tableFooterView = [UIView new];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView registerNib:[UINib nibWithNibName:kHomeTableViewCellID bundle:nil] forCellReuseIdentifier:kHomeTableViewCellID];
        self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.tableView.frame = self.bounds;
}

- (void)setIsNeedHeader:(BOOL)isNeedHeader {
    _isNeedHeader = isNeedHeader;

    __weak typeof(self) weakSelf = self;
    if (self.isNeedHeader) {
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.tableView.mj_header endRefreshing];
            });
        }];
    } else {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_header removeFromSuperview];
        self.tableView.mj_header = nil;
    }
}

- (void)setIsNeedFooter:(BOOL)isNeedFooter {
    _isNeedFooter = isNeedFooter;

    __weak typeof(self) weakSelf = self;
    if (self.isNeedFooter) {
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.dataSource addObject:@"加载更多成功"];
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_footer endRefreshing];
            });
        }];
    } else {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_footer removeFromSuperview];
        self.tableView.mj_footer = nil;
    }
}

- (void)beginFirstRefresh {
    if (!self.isHeaderRefreshed) {
        [self beginRefreshImmediately];
    }
}

- (void)beginRefreshImmediately {
    if (self.isNeedHeader) {
        [self.tableView.mj_header beginRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isHeaderRefreshed = YES;
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        });
    } else {
        self.isHeaderRefreshed = YES;
        [self.tableView reloadData];
    }
}

- (void)selectCellAtIndexPath:(NSIndexPath *)indexPath {
    if (self.lastSelectedIndexPath == indexPath) {
        return;
    }
    if (self.lastSelectedIndexPath != nil) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.lastSelectedIndexPath];
        [cell setSelected:NO animated:NO];
    }
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:YES animated:NO];
    self.lastSelectedIndexPath = indexPath;
}


- (void)textFieldMaskBtnAction:(UIButton *)sender {
    if (self.homeAccountListViewClickSearchTextFieldMaskBtn) {
        self.homeAccountListViewClickSearchTextFieldMaskBtn();
    }
}

- (void)hideZeroBtnClickAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.hideZero = sender.selected;
    if (self.homeAccountListViewClickHideZeroBtn) {
        self.homeAccountListViewClickHideZeroBtn(sender.selected);
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.isHeaderRefreshed) {
        return 0;
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHomeTableViewCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FBCoin *coin = self.dataSource[indexPath.row];
    coin.FiatCurrency = self.fiatCurrency;
    [cell configCoinModel:coin visible:self.visibleAmount];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}

#pragma mark - JXPagingViewListViewDelegate

- (UIView *)listView {
    return self;
}

- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)listDidAppear {
}

- (void)listDidDisappear {
}

@end
