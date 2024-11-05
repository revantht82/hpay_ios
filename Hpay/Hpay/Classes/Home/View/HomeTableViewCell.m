#import "HomeTableViewCell.h"
#import "DecimalUtils.h"

@interface HomeTableViewCell ()
@property(nonatomic, strong) FBCoin *coinModel;

@end

@implementation HomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.viewContainer.layer.shadowColor = kDarkNightColor.CGColor;
    self.viewContainer.layer.shadowOffset = CGSizeMake(0, 1);
    self.viewContainer.layer.shadowOpacity = 0.2;
    self.viewContainer.layer.shadowRadius = 3;
    self.viewContainer.layer.cornerRadius = 3;
    [self applyTheme];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self applyTheme];
}

- (void)applyTheme{
    self.labelAvailableCoin.textColor = [self getCurrentTheme].primaryOnSurface;
    self.labelCoinName.textColor = [self getCurrentTheme].primaryOnSurface;
    self.viewContainer.backgroundColor = [self getCurrentTheme].surface;
}

- (void)configCoinModel:(FBCoin *)coinModel visible:(BOOL)Visible {
    _coinModel = coinModel;
    self.labelCoinName.text = [NSString stringWithFormat:@"%@", coinModel.Code];
    if (coinModel.FiatExchangeRate){
        self.labelFiat.text = [NSString stringWithFormat:@"≈ %@ %@",
                               [DecimalUtils.shared stringInLocalisedFormatWithInput:coinModel.FiatBalance preferredFractionDigits:2],
                               coinModel.FiatCurrency];
        self.labelExchangeRate.text = [NSString stringWithFormat:@"1 %@ ≈ %@ %@", coinModel.Code, coinModel.FiatExchangeRate, coinModel.FiatCurrency];
    }else{
        self.labelExchangeRate.text = kPlaceholderForMarketPriceNotAvailable;
        self.labelFiat.text = kPlaceholderForMarketPriceNotAvailable;
    }
    self.labelAvailableCoin.text = [DecimalUtils.shared stringInLocalisedFormatWithInput:coinModel.UseableBalance preferredFractionDigits:coinModel.DecimalPlace];
}

@end
