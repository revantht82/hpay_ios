//
//  Created by ONUR YILMAZ on 31/03/2022.
//  Copyright © 2022 Himalaya. All rights reserved.
//

#import "RequestIndividualConfirmationView.h"
#import "HomeHelperModel.h"
#import "FPSecurityAuthManager.h"
#import "FPValueDP.h"
#import "AppDelegate.h"
#import "UIViewController+CurrentViewController.h"

@interface RequestIndividualConfirmationView ()

@property(weak, nonatomic) IBOutlet UIView *contentView;
@property(weak, nonatomic) IBOutlet UIButton *closeButton; //完成按钮
@property(weak, nonatomic) IBOutlet UILabel *pTypeTitleLabel;
@property(weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property(weak, nonatomic) IBOutlet UIView *amountView;
@property(weak, nonatomic) IBOutlet UILabel *amountToRequestLabel;
@property(weak, nonatomic) IBOutlet UILabel *amountValueLabel;

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

@implementation RequestIndividualConfirmationView

@synthesize delegate;

+ (instancetype)getPayView:(NSDecimalNumber *)amount coinString:(NSString *)coinStr amountString:(NSString *)amountStr requestNotes:(NSString *)reqNotes{
    RequestIndividualConfirmationView *payView = [[[NSBundle mainBundle] loadNibNamed:@"RequestIndividualConfirmationView" owner:self options:nil] lastObject];
    if (payView) {
        [[NSNotificationCenter defaultCenter] addObserver:payView selector:@selector(closeAction:) name:kPinInputErrorFiveTimesNotification object:nil];
        payView.backgroundColor = UIColorFromRGBA(0x000000, 0.4);
        [payView.completButton setTitle:payView.completButton.titleLabel.text.localizedUppercaseString forState:UIControlStateNormal];
        payView.amountToRequestLabel.text = NSLocalizedDefault(@"amount_to_request");
        payView.amountValueLabel.text = [NSString stringWithFormat:@"%@ %@", amountStr, coinStr];
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

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _contentHeight = self.contentView.frame.size.height;
    _initialContentCenter = self.contentView.center;
    
    [self.contentView setCenterY:self.initialContentCenter.y + self.contentHeight];
    [self applyTheme];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
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

    _notesLabel.textColor = theme.secondaryOnSurface;
    _notesValueLabel.textColor = theme.primaryOnSurface;
    _amountValueLabel.textColor = theme.primaryOnSurface;
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

- (void)showWithType{
    [self removeObserver];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeAction:) name: kPinInputErrorFiveTimesNotification object:nil];
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

@end
