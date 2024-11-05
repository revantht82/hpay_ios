#import "CBPayView.h"
#import "HomeHelperModel.h"
#import "FPSecurityAuthManager.h"
#import "FPValueDP.h"
#import "AppDelegate.h"
#import "UIViewController+CurrentViewController.h"

@interface CBPayView ()
@property(weak, nonatomic) IBOutlet UILabel *topTitleLabel;
@property(weak, nonatomic) IBOutlet UILabel *bottomTitleLabel;

@property(weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property(weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property(weak, nonatomic) IBOutlet UILabel *coinLabel;
@property(weak, nonatomic) IBOutlet UILabel *insufficientLabel;//余额不足。默认隐藏
@property(weak, nonatomic) IBOutlet UIButton *completButton; //完成按钮
@property(weak, nonatomic) IBOutlet UIButton *closeButton; //完成按钮
@property(weak, nonatomic) IBOutlet UIView *insufficientBGView; // 余额不足要显示的View

@property(weak, nonatomic) IBOutlet UIView *contentView;

@property(nonatomic, assign) CBPayViewType pType;
@property(weak, nonatomic) IBOutlet UILabel *pTypeTitleLabel;
@property(nonatomic, copy) FinishBlock finishBlock;
@property(weak, nonatomic) IBOutlet UIView *shopV;
@property(weak, nonatomic) IBOutlet UIView *feeV;
@property(weak, nonatomic) IBOutlet UIView *coinV;
@property(weak, nonatomic) IBOutlet UIView *addrV;
@property(weak, nonatomic) IBOutlet UIView *tagV;
@property(weak, nonatomic) IBOutlet UILabel *tagValLabel;
@property(weak, nonatomic) IBOutlet UILabel *tagLeftPlace;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *dividers;

@property(nonatomic, strong) FPOrderDetailModel *detailModel;
@property(nonatomic, assign) BOOL isLackofbalance; //是否余额不足


@property(nonatomic, copy) NSDictionary *infoDict;
@property(weak, nonatomic) IBOutlet UILabel *addressWithdrawLabel;
@property(weak, nonatomic) IBOutlet UILabel *addressWithdrawLeftLabel;
@property(weak, nonatomic) IBOutlet UILabel *feeWithdrawLabel;
@property(weak, nonatomic) IBOutlet UILabel *feeWithdrawLeftLabel;
//联系客服回调
@property(nonatomic, copy) LinkCustomerBlock linkCBlock;

@property(nonatomic, assign) CGFloat contentHeight;
@property(nonatomic, assign) CGPoint initialContentCenter;

@end

@implementation CBPayView
+ (instancetype)getPayView {
    CBPayView *payView = [[[NSBundle mainBundle] loadNibNamed:@"CBPayView" owner:self options:nil] lastObject];
    if (payView) {
        // 点击了忘记PIN码通知
        [[NSNotificationCenter defaultCenter] addObserver:payView selector:@selector(closeAction:) name:kPinInputErrorFiveTimesNotification object:nil];
        payView.backgroundColor = UIColorFromRGBA(0x000000, 0.4);
        [payView.completButton setTitle:payView.completButton.titleLabel.text.localizedUppercaseString forState:UIControlStateNormal];
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
    _moneyLabel.textColor = theme.primaryOnSurface;
    _topTitleLabel.textColor = theme.secondaryOnSurface;
    _shopNameLabel.textColor = theme.primaryOnSurface;
    _feeWithdrawLeftLabel.textColor = theme.secondaryOnSurface;
    _feeWithdrawLabel.textColor = theme.primaryOnSurface;
    _addressWithdrawLeftLabel.textColor = theme.secondaryOnSurface;
    _addressWithdrawLabel.textColor = theme.primaryOnSurface;
    _tagLeftPlace.textColor = theme.secondaryOnSurface;
    _tagValLabel.textColor = theme.primaryOnSurface;
    _bottomTitleLabel.textColor = theme.secondaryOnSurface;
    _coinLabel.textColor = theme.primaryOnSurface;
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

    if (self.clickBlock) {
        if (self.isLackofbalance) {
            self.clickBlock(CBPayViewClickCancelType, nil);
        } else {
            self.clickBlock(CBPayViewClickCloseType, nil);
        }

    }
}

#pragma mark -- 完成

- (IBAction)completAction:(id)sender {
    [self closeReviewDetails];
    FPSecurityAuthManager *authManager = nil;
    authManager = [[FPSecurityAuthManager alloc] init];
    authManager.isOnlyVerifyPin = YES;
    [authManager securityAuth];
    [authManager setSecurityAuthSuccessBlock:^(NSString *securityPssaword) {


        if (self.pType == CBPayViewTypePay) {
            [MBHUD showInView:self withTitle:nil withType:HUDTypeLoading];
            [HomeHelperModel payExistedOrder:self.detailModel.OrderNo Pin:securityPssaword type:FPPaymentTypeNormal completeBlock:^(FPOrderDetailModel *model, NSInteger errorCode, NSString *errorMessage) {
                [MBHUD hideInView:self];
                if (model && errorCode == kFPNetRequestSuccessCode) {
                    if (self.clickBlock) {
                        self.clickBlock(CBPayViewClickSuccessType, model);
                    }
                    [self hide];
                } else if (errorCode == kFPLackofBalanceCode) {
                    // 余额不足，切换余额不足页面
                    [self showInsufficientView];
                } else if (errorCode == 10062) {
                    [self hide];
                    if (errorMessage){
                        [self showErrorAlertWithMessage:errorMessage];
                    }
                } else if (errorCode == 10130) {
                    [self hide];
                    [self showErrorAlertWithMessage:NSLocalizedCommon(@"abnomal_currency")];
                } else {
                    // 其他错误
                    errorMessage ? [MBHUD showInView:self withDetailTitle:errorMessage withType:HUDTypeError] : nil;
                }
            }];

        } else if (self.pType == CBPayViewTypeWithdrawal) {
            if (self.finishBlock) {
                self.finishBlock(@{@"securityPssaword": securityPssaword});
                [self hide];
            }
        } else if (self.pType == CBPayViewTypeWithtransfer) {
            if (self.finishBlock) {
                self.finishBlock(@{@"securityPssaword": securityPssaword});
                [self hide];
            }
        } else if (self.pType == CBPayViewTypeWithGPayExChange) {
            if (self.finishBlock) {
                self.finishBlock(@{@"securityPssaword": securityPssaword});
                [self hide];
            }
        } else if (self.pType == CBPayViewTypeWithGPayHuaZhuan) {
            if (self.finishBlock) {
                self.finishBlock(@{@"securityPssaword": securityPssaword});
                [self hide];
            }
        }

    }];
}

- (void)showErrorAlertWithMessage:(NSString *) errorMessage{
    AlertActionItem *cancelItem = [AlertActionItem defaultCancelItemWithHandler:^{
        if (self.clickBlock) {
            self.clickBlock(CBPayViewClickCloseType, nil);
        }
    }];
    
    AlertActionItem *contactItem = [AlertActionItem actionWithTitle:NSLocalizedCommon(@"contact") style:(AlertActionStyleDefault) handler:^{
        if (self.clickBlock) {
            [self hide];
            self.clickBlock(CBPayViewClickLinkType, nil);
        }
    }];
    
    [[UIViewController getCurrentViewController] showAlertWithTitle:@""
                                                            message:errorMessage
                                                            actions:[NSArray arrayWithObjects:cancelItem, contactItem, nil]];
}

#pragma mark -- 取消

- (IBAction)cancelAction:(id)sender {
    [self hide];
    if (self.clickBlock) {

        self.clickBlock(CBPayViewClickCancelType, nil);
    }
}

#pragma mark -- 充值

- (IBAction)topupAction:(id)sender {
    [self hide];
    if (self.clickBlock) {
        self.clickBlock(CBPayViewClickTopupType, self.detailModel);
    }
}

- (void)showWithType:(CBPayViewType)pType andInfoDict:(NSDictionary *)infoDict withFinishEvent:(FinishBlock)finishBlock andLinkBlock:(LinkCustomerBlock)linkBlock {
    [self removeObserver];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeAction:) name:kPinInputErrorFiveTimesNotification object:nil];
    self.linkCBlock = linkBlock;
    self.finishBlock = finishBlock;
    self.infoDict = infoDict;
    self.pType = pType;
    [self show];

    switch (pType) {
        case CBPayViewTypePay: {
            self.shopV.hidden = NO;
            self.coinV.hidden = NO;
        }
            break;
        case CBPayViewTypeWithtransfer: {
            self.pTypeTitleLabel.text = NSLocalizedDefault(@"review_details");
            self.shopV.hidden = NO;
            self.coinV.hidden = NO;
            self.moneyLabel.hidden = YES;
            self.topTitleLabel.text = NSLocalizedDefault(@"amount_received");
            self.bottomTitleLabel.text = NSLocalizedDefault(@"receiver_account");
            if (infoDict && infoDict.count > 0) {
                self.shopNameLabel.text = [NSString stringWithFormat:@"%@ %@", infoDict[@"Amount"], infoDict[@"CoinCode"]];
                self.shopNameLabel.adjustsFontSizeToFitWidth = YES;
                self.coinLabel.text = infoDict[@"Account"];
            }
        }
            break;
        case CBPayViewTypeWithdrawal: {
            self.pTypeTitleLabel.text = NSLocalizedWallet(@"confirm_to_withdraw");
            self.shopV.hidden = YES;
            self.coinV.hidden = YES;
            self.feeV.hidden = NO;
            self.addrV.hidden = NO;

            if (infoDict && infoDict.count > 0) {
                NSString *tagStr = infoDict[@"Tag"];
                if (tagStr && tagStr.length > 0) {
                    self.tagV.hidden = NO;
                    self.tagValLabel.text = tagStr;
                }

                NSString *code = infoDict[@"Code"];
                NSString *amount = infoDict[@"Amount"];
                NSString *feeD = infoDict[@"Fee"];
                NSString *decimalPlace = infoDict[@"DecimalPlace"];
                NSString *jian = [FPValueDP A:amount jianB:feeD withPlace:[decimalPlace integerValue]];
                self.feeWithdrawLabel.text = [NSString stringWithFormat:@"%@ %@", jian, code];
                self.addressWithdrawLabel.text = infoDict[@"Address"];
                self.moneyLabel.text = @"";
            }
        }
            break;
        case CBPayViewTypeWithGPayExChange : {
            self.pTypeTitleLabel.text = NSLocalizedDefault(@"exchange");
            self.shopV.hidden = NO;
            self.coinV.hidden = NO;
            self.moneyLabel.hidden = YES;
            self.topTitleLabel.text = NSLocalizedDefault(@"exchange_to_token/currency");
            self.bottomTitleLabel.text = NSLocalizedDefault(@"received_token");
            if (infoDict && infoDict.count > 0) {
                self.shopNameLabel.text = [NSString stringWithFormat:@"%@", infoDict[@"CoinCode"]];
                self.shopNameLabel.adjustsFontSizeToFitWidth = YES;
                self.coinLabel.text = infoDict[@"Amount"];
            }
        }
            break;

        case CBPayViewTypeWithGPayHuaZhuan : {
            self.pTypeTitleLabel.text = NSLocalizedDefault(@"review_details");
            self.shopV.hidden = NO;
            self.coinV.hidden = NO;
            self.moneyLabel.hidden = YES;
            self.tagV.hidden = NO;
            self.tagLeftPlace.hidden = true;
            self.tagValLabel.hidden = true;
            UIView *divider =  _dividers.lastObject;
            [divider removeFromSuperview];
            
            self.tagLeftPlace.text = NSLocalizedDefault(@"Transfer_to");
            self.topTitleLabel.text = NSLocalizedDefault(@"Token");
            self.bottomTitleLabel.text = NSLocalizedDefault(@"Transfer_Amount");
            if (infoDict && infoDict.count > 0) {
                self.shopNameLabel.text = [NSString stringWithFormat:@"%@", infoDict[@"CoinCode"]];
                self.shopNameLabel.adjustsFontSizeToFitWidth = YES;
                self.coinLabel.text = infoDict[@"Amount"];
                self.tagValLabel.text = NSLocalizedDefault(@"Transfer_to_HExchange");
            }
        }
            break;

        default:
            break;
    }
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

- (void)showInsufficientView {

    [MBHUD showInView:self.contentView withDetailTitle:NSLocalizedHome(@"insufficient_balance") withType:HUDTypeError];
    self.isLackofbalance = YES;
    self.completButton.hidden = YES;
    self.insufficientBGView.hidden = NO;
    self.insufficientLabel.hidden = NO;
}

- (void)loadDataWithOrderId:(NSString *)OrderId {
    self.queryId = OrderId;
    self.isLackofbalance = NO;
    self.completButton.hidden = NO;
    self.insufficientBGView.hidden = YES;
    self.insufficientLabel.hidden = YES;

    [HomeHelperModel fetchToBePaidOrderWithOrderId:OrderId completeBlock:^(NSDictionary *dict, NSInteger errorCode, NSString *errorMessage) {
        if (dict && errorCode == kFPNetRequestSuccessCode) {
            [self show];
            FPOrderDetailModel *detailModel = [FPOrderDetailModel mj_objectWithKeyValues:dict];
            detailModel.OrderNo = OrderId;
            [self writeData:detailModel];
            NSString *amount = [NSString stringWithFormat:@"%@", [dict valueForKey:@"Amount"]];
            NSString *balance = [NSString stringWithFormat:@"%@", [dict valueForKey:@"Balance"]];
            NSDecimalNumber *amountNumber = [NSDecimalNumber decimalNumberWithString:amount];
            NSDecimalNumber *balanceNumber = [NSDecimalNumber decimalNumberWithString:balance];
            NSComparisonResult result = [balanceNumber compare:amountNumber];
            if (result == NSOrderedAscending) {
                [self showInsufficientView];
            }

        }
    }];
}

- (void)writeData:(FPOrderDetailModel *)detailModel {
    self.detailModel = detailModel;
    self.moneyLabel.text = [NSString stringWithFormat:@"%@ %@", detailModel.CryptoAmount, detailModel.CryptoCode];
    self.shopNameLabel.text = [NSString stringWithFormat:@"%@", detailModel.MerchantName];
    self.coinLabel.text = [NSString stringWithFormat:@"%@", detailModel.CryptoCode];

}
@end
