//
//  FetchPhoneCodeAdapter.m
//  Hpay
//
//  Created by Olgu Sirman on 10/12/2020.
//  Copyright © 2020 Himalaya. All rights reserved.
//

#import "FetchPhoneCodeAdapter.h"
#import "FetchPhoneCodeTableViewCell.h"
#import "FetchPhoneCodeTableHeaderView.h"

static NSString *const kCellIdentifity = @"FetchPhoneCodeTableViewCell";
static CGFloat const kHeightForRow = 44.0f;
static CGFloat const kHeightForHeader = 30.0f;
static CGFloat const kTableViewLeftInset = 15.0f;
static CGFloat const kTableHeaderHeight = 30.0f;

@interface FetchPhoneCodeAdapter () <UITableViewDelegate, UITableViewDataSource>

@property(weak, nonatomic) UITableView *tableView;
@property(copy, nonatomic) NSArray <NSDictionary <NSString *, NSArray<FPCountry *> *> *> *dataArray;
@property(copy, nonatomic) NSArray<NSString *> *indexArray;
@property(assign, nonatomic) FPBackColorStyle style;
@property(copy, nonatomic) NSString *selectPhoneCode;

@end

@implementation FetchPhoneCodeAdapter

- (instancetype)initWithTableView:(__kindof UITableView *)tableView {
    self = [super init];
    if (self) {
        self.tableView = tableView;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return self;
}

- (void)setData:(NSArray<NSDictionary<NSString *, NSArray<FPCountry *> *> *> *)dataArray
     indexArray:(NSArray<NSString *> *)indexArray {
    self.dataArray = dataArray;
    self.indexArray = indexArray;
    [self.tableView reloadData];
}

- (void)configureWithSelectPhoneCode:(NSString *)selectPhoneCode style:(FPBackColorStyle)style {
    self.style = style;
    self.selectPhoneCode = selectPhoneCode;

    [self.tableView registerClass:[FetchPhoneCodeTableViewCell class] forCellReuseIdentifier:kCellIdentifity];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, kTableViewLeftInset, 0, 0);
    self.tableView.separatorColor = kDustyColor25;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = kSurfaceColor;
    self.tableView.sectionIndexColor = UIColorMakeWithHex(@"#878D99");
    if (style == FPBlackBackColorStyle) {
        self.tableView.sectionIndexColor = [UIColor whiteColor];
        self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        self.tableView.backgroundColor = [UIColor blackColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }

}

#pragma mark -- UITableViewDelegate and DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self getCountriesCount:(NSUInteger) section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kHeightForRow;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kHeightForHeader;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    NSString *firstChar = [self configureDataForTableHeaderView:(NSUInteger) section];
    CGRect headerViewFrame = CGRectMake(0, 0, SCREEN_WIDTH, kTableHeaderHeight);
    FetchPhoneCodeTableHeaderView *headerView = [[FetchPhoneCodeTableHeaderView alloc] initWithFrame:headerViewFrame with:firstChar];

    if (self.style == FPBlackBackColorStyle) {
        headerView.backgroundColor = kDarkNightColor;
    }
    return headerView;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.indexArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSString *key = self.indexArray[(NSUInteger) index];
    if (key == UITableViewIndexSearch) {
        [tableView setContentOffset:CGPointZero animated:NO];
        return NSNotFound;
    }
    return index;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FetchPhoneCodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifity];
    if (cell == nil) {
        cell = [[FetchPhoneCodeTableViewCell alloc] initWithReuseIdentifier:kCellIdentifity];
    }

    FPCountry *country = [self getCountry:indexPath];
    if (country) {
        [cell configureWith:country selectPhoneCode:self.selectPhoneCode];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    FPCountry *country = [self getCountry:indexPath];

    if ([self.delegate respondsToSelector:@selector(tableViewDidSelectRow:)]) {
        [self.delegate tableViewDidSelectRow:country];
    }
}

#pragma mark - Helpers

- (NSString *)configureDataForTableHeaderView:(NSUInteger)section {
    NSDictionary *sectionDict = self.dataArray[section];
    NSArray *keys = [sectionDict allKeys];

    NSString *firstChar = @"";
    if (keys.count > 0) {
        firstChar = [NSString stringWithFormat:@"%@", [keys firstObject]];
    }
    return firstChar;
}

- (FPCountry *)getCountry:(NSIndexPath *)indexPath {

    NSDictionary *sectionDict = self.dataArray[(NSUInteger) indexPath.section];
    NSArray *values = [sectionDict allValues];
    if (values.count > 0) {
        NSArray<FPCountry *> *array = [values firstObject];
        if (indexPath.row < array.count) {
            FPCountry *country = array[(NSUInteger) indexPath.row];
            return country;
        }
    }

    return nil;
}

- (NSArray<FPCountry *> *)getCountries:(NSUInteger)section {
    NSDictionary <NSString *, NSArray<FPCountry *> *> *sectionDict = self.dataArray[section];
    NSArray<NSArray<FPCountry *> *> *values = sectionDict.allValues;
    if (values.count > 0) {
        NSArray<FPCountry *> *array = [values firstObject];
        return array;
    }
    return nil;
}

- (NSUInteger)getCountriesCount:(NSUInteger)section {
    return ([self getCountries:section] != nil) ? [[self getCountries:section] count] : 0;
}

@end
