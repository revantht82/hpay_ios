#import "GroupSendResultViewController.h"
#import "NSString+UTCTimeStamp.h"
#import "PaySuccessRouter.h"
#import "HomeViewController.h"
#import "DecimalUtils.h"
#import "ResultGroupSendReceiverListViewCell.h"
#import "ApiError.h"

@interface GroupSendResultViewController () <UITableViewDataSource, UITableViewDelegate>
    @property(nonatomic, strong) NSArray *receiversArray;
@end

@implementation GroupSendResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _receiversArray = [[NSArray alloc] initWithArray:(NSArray*)self.transferDict[@"Users"]];
    
    [self configurePageUI];
    [self configurePage];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoticeNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kCoinBalanceChangedNotification object:nil];
    [self applyTheme];
    
    _receiversTable.delegate = self;
    _receiversTable.dataSource = self;
    [_receiversTable registerNib:[UINib nibWithNibName:@"ResultGroupSendReceiverListViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ResultGroupSendReceiverListViewCellId"];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self applyTheme];
}

- (void)applyTheme{
    self.view.backgroundColor = [self getCurrentTheme].background;
    self.topLabel.textColor = [self getCurrentTheme].primaryOnBackground;
    self.receiversTable.backgroundColor = [self getCurrentTheme].background;
}

#pragma mark - Carry out

- (IBAction)doneAction:(id)sender {
    [self dismiss];
}

- (nullable HomeViewController *)homeController {
    return (HomeViewController *)[(UINavigationController *)((UITabBarController *)self.presentingViewController).viewControllers.firstObject topViewController];
}

#pragma mark - Private Helpers

- (void)dismiss {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
    self.doneButton.backgroundColor = [self getCurrentTheme].primaryButton;
    
    [self.view layoutIfNeeded];
}

- (void)configurePage {
    
    if ([self.transferDict[@"Code"] intValue] != 0){
        
        self.resultIcon.image = [UIImage imageNamed:@"icon_error"];
        self.resultIcon.tintColor = [self getCurrentTheme].warning;
        
        self.topLabel.text = [self.transferDict[@"Message"] stringValue];
        self.titleHeightConst.constant = 150;
        self.receiversTable.hidden = YES;
        
        return;
    }
    
    NSUInteger successful_transactions = 0;
    NSUInteger total_receivers = [_receiversArray count];
    for (NSDictionary *user in _receiversArray){
        if ([user[@"Status"] boolValue] == 1) successful_transactions++;
    }
    
    NSString *transactionCompletedString = NSLocalizedString(@"groupPaymentCompletedSuccesfullDescription", nil);

//    NSString *cryptoCode = self.transferDict[@"Data"][@"CoinName"];
//    NSNumber *amount = self.transferDict[@"Data"][@"Amount"];
//    NSUInteger decimalPlaceUInt = [((NSNumber*)self.transferDict[@"Data"][@"DecimalPlace"]) unsignedIntValue];
//    
//    NSString *formattedAmount = [DecimalUtils.shared stringInLocalisedFormatWithInput:amount.stringValue preferredFractionDigits:decimalPlaceUInt];
    NSString *totalString = [NSString stringWithFormat:transactionCompletedString, successful_transactions, total_receivers];

    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:totalString];
    [attributedString setAttributes:@{NSFontAttributeName: kFontMediumWeight(24), NSForegroundColorAttributeName: kDarkNightColor} range:[totalString rangeOfString:transactionCompletedString]];
//    [attributedString setAttributes:@{NSFontAttributeName: UIFontMake(12), NSForegroundColorAttributeName: kBlackColor} range:[totalString rangeOfString:cryptoCode]];
//    [attributedString setAttributes:@{NSFontAttributeName: UIFontMake(30), NSForegroundColorAttributeName: kDarkNightColor} range:[totalString rangeOfString:formattedAmount]];
    self.topLabel.attributedText = attributedString;
    
    
    [self configureDismissBarButtonItem];
   
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_receiversArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ResultGroupSendReceiverListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultGroupSendReceiverListViewCellId" forIndexPath:indexPath];
    if(cell == nil) {
        cell = [[ResultGroupSendReceiverListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ResultGroupSendReceiverListViewCellId"];
    }
    NSDictionary *user = _receiversArray[indexPath.row];
    
    cell.backgroundColor = [self getCurrentTheme].background;
    
    if ([user[@"Status"] boolValue] == 1) {
        
        [cell setValueToAmount:[NSString stringWithFormat:@"%@ %@", [self.transferDict[@"Amount"] stringValue], self.transferDict[@"CoinName"]]];
        [cell.amount setHidden:NO];
        [cell.resultIcon setImage:[UIImage imageNamed:@"check-mark-circle-line-icon"]];
        cell.resultIcon.tintColor = [self getCurrentTheme].controlBorder;
        [cell.errorIcon setHidden:YES];
    } else {
        [cell.amount setHidden:YES];
        [cell.resultIcon setImage:[UIImage imageNamed:@"close-round-line-icon"]];
        cell.resultIcon.tintColor = [self getCurrentTheme].warning;
        [cell.errorIcon setHidden:NO];
        cell.errorIcon.tintColor = [self getCurrentTheme].pendingStatus;
    }
    
    NSString *name_for_row = user[@"AccountName"];
    if (user[@"NickName"] && [user[@"NickName"] stringValue].length > 0){
        name_for_row = [NSString stringWithFormat:@"%@ - %@", user[@"AccountName"], user[@"NickName"]];
    }
    
    cell.name.text = name_for_row;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *user = _receiversArray[indexPath.row];

// Test data
//    user = @{
//        @"OrderNo": @"",
//        @"AccountName": @"u***j@h***a.exchange",
//        @"Status": @false,
//        @"ErrorCode": @10099,
//        @"NickName": @""
//        
//    };
    
    if ([user[@"Status"] boolValue] == 1) {
        
    } else {
        [self handleErrorWithErrorCode:[user[@"ErrorCode"] intValue] message:@""];
    }
}

- (void)handleErrorWithErrorCode:(NSInteger)code message:(NSString *)message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    alert.title = @"";
    UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedDefault(@"okay") style:UIAlertActionStyleDefault handler: ^(UIAlertAction * _Nonnull action) {
        [self.navigationController popToRootViewControllerAnimated:true];
    }];
    
    [alert addAction:ok];
    
    switch (code) {
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
        
        default: {
            ApiError* error = [ApiError errorWithCode:code message:NULL];
            alert.message = error.prettyMessage;
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

@end
