//
//  RequestConfirmationView.m
//  Hpay
//
//  Created by ONUR YILMAZ on 31/03/2022.
//  Copyright © 2022 Himalaya. All rights reserved.
//

#import "RequestConfirmationView.h"
#import "HomeHelperModel.h"
#import "FPSecurityAuthManager.h"
#import "FPValueDP.h"
#import "AppDelegate.h"
#import "UIViewController+CurrentViewController.h"
#import "QRView.h"

@interface RequestConfirmationView ()

@property(weak, nonatomic) IBOutlet UIView *contentView;
@property(weak, nonatomic) IBOutlet UIButton *closeButton;
@property(weak, nonatomic) IBOutlet UILabel *pTypeTitleLabel;
@property(weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property(weak, nonatomic) IBOutlet UIView *amountView;
@property(weak, nonatomic) IBOutlet UILabel *amountToRequestLabel;
@property(weak, nonatomic) IBOutlet UILabel *amountValueLabel;

@property(weak, nonatomic) IBOutlet UIView *productCategoryView;
@property(weak, nonatomic) IBOutlet UILabel *productCategoryLabel;
@property(weak, nonatomic) IBOutlet UILabel *insufficientLabel;//余额不足。默认隐藏
@property(weak, nonatomic) IBOutlet UILabel *productCategoryValueLabel;

@property(weak, nonatomic) IBOutlet UIView *notesView;
@property(weak, nonatomic) IBOutlet UILabel *notesLabel;
@property(weak, nonatomic) IBOutlet UILabel *notesValueLabel;

@property(weak, nonatomic) IBOutlet UIButton *completButton; //完成按钮
@property(weak, nonatomic) IBOutlet UIView *insufficientBGView; // 余额不足要显示的View

@property(nonatomic, copy) FinishBlock finishBlock;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *dividers;

@property(nonatomic, strong) FPOrderDetailModel *detailModel;
@property(nonatomic, assign) BOOL isLackofbalance;

@property(nonatomic, copy) NSDictionary *infoDict;


@property(nonatomic, assign) CGFloat contentHeight;
@property(nonatomic, assign) CGPoint initialContentCenter;

@end

@implementation RequestConfirmationView

@synthesize delegate;

+ (instancetype)getPayView:(NSDecimalNumber *)amount amountString:(NSString *)amountStr productCategory:(NSString *)prodCat requestNotes:(NSString *)reqNotes selectedCategoryId:(NSString *)catId{
    RequestConfirmationView *payView = [[[NSBundle mainBundle] loadNibNamed:@"RequestConfirmationView" owner:self options:nil] lastObject];
    if (payView) {
        [[NSNotificationCenter defaultCenter] addObserver:payView selector:@selector(closeAction:) name:kPinInputErrorFiveTimesNotification object:nil];
        payView.backgroundColor = UIColorFromRGBA(0x000000, 0.4);
        [payView.completButton setTitle:payView.completButton.titleLabel.text.localizedUppercaseString forState:UIControlStateNormal];
        payView.amountToRequestLabel.text = NSLocalizedDefault(@"amount_to_request");
        payView.amountValueLabel.text = [NSString stringWithFormat:@"%@ HDO", amountStr];
        payView.productCategoryLabel.text = NSLocalizedDefault(@"product_category");
        payView.productCategoryValueLabel.text = prodCat;
        payView.notesValueLabel.text = reqNotes;
        [payView.notesValueLabel sizeToFit];

        return payView;
    }
    return nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    _contentHeight = self.contentView.frame.size.height;
    _initialContentCenter = self.contentView.center;
    
    [self.contentView setCenterY:self.initialContentCenter.y + self.contentHeight];
    [self applyTheme];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self applyTheme];
}

- (void)applyTheme{
    id<ThemeProtocol> theme = [self getCurrentTheme];
    _contentView.backgroundColor = theme.surface;
    _closeButton.tintColor = theme.primaryOnSurface;
    _pTypeTitleLabel.textColor = theme.primaryOnSurface;
    _moneyLabel.textColor = theme.primaryOnSurface;
    
    _amountToRequestLabel.textColor = theme.secondaryOnSurface;
    _amountValueLabel.textColor = theme.primaryOnSurface;
    
    _productCategoryLabel.textColor = theme.secondaryOnSurface;
    _productCategoryValueLabel.textColor = theme.primaryOnSurface;
    
    _notesLabel.textColor = theme.secondaryOnSurface;
    _notesValueLabel.textColor = theme.primaryOnSurface;

    _completButton.tintColor = theme.primaryButtonOnSurface;
    
    for (UIView *divider in _dividers) {
        divider.backgroundColor = theme.verticalDivider;
    }
}

#pragma mark -- 关闭

- (IBAction)closeAction:(id)sender {
    [self closeReviewDetails];
}

-(void)closeReviewDetails {
    [self hide];
}

#pragma mark -- 完成

- (IBAction)completAction:(id)sender {
    [self closeReviewDetails];
    [self->delegate confirmationViewDismissed];
}

#pragma mark -- 取消

- (IBAction)cancelAction:(id)sender {
    [self hide];
}

#pragma mark -- 充值

- (IBAction)topupAction:(id)sender {
    [self hide];
  
}

- (void)showWithType {
    [self removeObserver];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeAction:) name:kPinInputErrorFiveTimesNotification object:nil];
    [self show];
    self.pTypeTitleLabel.text = NSLocalizedDefault(@"review_details");

}

#pragma mark -- public

- (void)show {
    
    [AppDelegate.keyWindow addSubview:self];
    [AppDelegate.keyWindow bringSubviewToFront:self];
    self.hidden = NO;
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(AppDelegate.keyWindow);
    }];
    
    [self layoutIfNeeded];

    [UIView animateWithDuration:0.3 animations:^{
        [self.contentView setY:(self.bounds.size.height - self.contentView.bounds.size.height)];
    }];
    
}

- (void)hide {

    [UIView animateWithDuration:0.3 animations:^{
        [self.contentView setCenterY:[self initialContentCenter].y + [self contentHeight]];
        [self.contentView layoutSubviews];
        [self layoutIfNeeded];
    }                completion:^(BOOL finished) {
        if (self.isNeedRemoveView == NO) {
            [self removeFromSuperview];
        }
        self.hidden = YES;
        [self removeObserver];
    }];
}

// commented out on 07/06/2022

//- (void)showInsufficientView {
//
//    [MBHUD showInView:self.contentView withDetailTitle:NSLocalizedHome(@"insufficient_balance") withType:HUDTypeError];
//    self.isLackofbalance = YES;
//    self.completButton.hidden = YES;
//    self.insufficientBGView.hidden = NO;
//    self.insufficientLabel.hidden = NO;
//}
//
//- (void)loadDataWithOrderId:(NSString *)OrderId {
//    self.queryId = OrderId;
//    self.isLackofbalance = NO;
//    self.completButton.hidden = NO;
//    self.insufficientBGView.hidden = YES;
//    self.insufficientLabel.hidden = YES;
//
//    [HomeHelperModel fetchToBePaidOrderWithOrderId:OrderId completeBlock:^(NSDictionary *dict, NSInteger errorCode, NSString *errorMessage) {
//        if (dict && errorCode == kFPNetRequestSuccessCode) {
//            [self show];
//            FPOrderDetailModel *detailModel = [FPOrderDetailModel mj_objectWithKeyValues:dict];
//            detailModel.OrderNo = OrderId;
//            [self writeData:detailModel];
//            NSString *amount = [NSString stringWithFormat:@"%@", [dict valueForKey:@"Amount"]];
//            NSString *balance = [NSString stringWithFormat:@"%@", [dict valueForKey:@"Balance"]];
//            NSDecimalNumber *amountNumber = [NSDecimalNumber decimalNumberWithString:amount];
//            NSDecimalNumber *balanceNumber = [NSDecimalNumber decimalNumberWithString:balance];
//            NSComparisonResult result = [balanceNumber compare:amountNumber];
//            if (result == NSOrderedAscending) {
//                [self showInsufficientView];
//            }
//
//        }
//    }];
//}

//- (void)writeData:(FPOrderDetailModel *)detailModel {
//    self.detailModel = detailModel;
//    self.moneyLabel.text = [NSString stringWithFormat:@"%@ %@", detailModel.CryptoAmount, detailModel.CryptoCode];
//    self.amountValueLabel.text = [NSString stringWithFormat:@"%@", detailModel.MerchantName];
//    self.productCategoryValueLabel.text = [NSString stringWithFormat:@"%@", detailModel.CryptoCode];
//
//}
@end
