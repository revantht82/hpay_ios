//
//  FetchPhoneCodeViewController.m
//  FiiiPay
//
//  Created by Mac on 2018/6/8.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "FetchPhoneCodeViewController.h"
#import "FetchPhoneCodeAdapter.h"
#import "FetchPhoneCodeViewModel.h"
#import "FetchPhoneCodeProcessedDataModel.h"

@interface FetchPhoneCodeViewController () <FetchPhoneCodeAdapterDelegate>
@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(copy, nonatomic) NSArray <NSDictionary <NSString *, NSArray<FPCountry *> *> *> *dataArray;
@property(copy, nonatomic) NSArray<NSString *> *indexArray;
@property(strong, nonatomic) FetchPhoneCodeAdapter *adapter;
@property(strong, nonatomic) FetchPhoneCodeViewModel *viewModel;

@end

@implementation FetchPhoneCodeViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.style == FPBlackBackColorStyle) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self bindAdapter];
    [self bindViewModel];
    
    self.navigationItem.title = NSLocalizedDefault(@"select_country_region");
    if (self.style == FPBlackBackColorStyle) {
        self.navigationItem.title = NSLocalizedDefault(@"select_country_region");
        self.view.backgroundColor = [UIColor blackColor];
    }
    [self applyTheme];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.style == FPBlackBackColorStyle) {
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self applyTheme];
}

- (void)applyTheme{
    self.tableView.backgroundColor = [self getCurrentTheme].background;
}

- (void)bindAdapter {
    self.adapter = [[FetchPhoneCodeAdapter alloc] initWithTableView:self.tableView];
    self.adapter.delegate = self;
    [self.adapter configureWithSelectPhoneCode:self.selectPhoneCode style:_style];
}

- (void)bindViewModel {
    self.viewModel = [[FetchPhoneCodeViewModel alloc] init];
    if (self.countryList.List.count > 0) {
        WS(weakSelf);
        [self.viewModel setDidProcessDataSource:^(FetchPhoneCodeProcessedDataModel * _Nonnull model) {
            weakSelf.dataArray = [NSArray arrayWithArray:model.dataArray];
            weakSelf.indexArray = [NSArray arrayWithArray:model.indexArray];
            [weakSelf.adapter setData:model.dataArray indexArray:model.indexArray];
        }];
        [self.viewModel processDataSourceWith:self.countryList];
    }
}

#pragma mark - FetchPhoneCodeAdapterDelegate

- (void)tableViewDidSelectRow:(FPCountry *)country {

    if (country && self.clickBlock) {
        self.clickBlock(country);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
