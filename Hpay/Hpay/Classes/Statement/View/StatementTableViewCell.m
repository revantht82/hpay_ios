#import "StatementTableViewCell.h"
#import "DecimalUtils.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface StatementTableViewCell ()

@end

@implementation StatementTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self applyTheme];
}

- (void)applyTheme {
    self.viewContainer.backgroundColor = [self getCurrentTheme].surface;
    self.typeLabel.textColor = [self getCurrentTheme].primaryOnSurface;
    self.amountLabel.textColor = [self getCurrentTheme].primaryOnSurface;
    self.statusLabel.textColor = [self getCurrentTheme].secondaryOnSurface;
    self.timeLabel.textColor = [self getCurrentTheme].secondaryOnSurface;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [self applyTheme];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setHighlighted:selected animated:false];
}

-(NSString*)oStatusName:(NSString*)status {
    NSString *stateName;
    switch (status.intValue) {
        case 1:
            stateName = NSLocalizedString(@"order_status.pending", comment: @"");
            break;
        case 2:
            stateName = NSLocalizedString(@"order_status.complete", comment: @"");
            break;
        case 3:
            stateName = NSLocalizedString(@"order_status.cancelled", comment: @"");
            break;
        case 8:
            stateName = NSLocalizedString(@"order_status.expired", comment: @"");
            break;
        case 12:
            stateName = NSLocalizedString(@"order_status.failed", comment: @"");
            break;
        default:
            stateName = NSLocalizedString(@"order_status.unknown", comment: @"");
            break;
    }
    return stateName;
}

- (void)setCellInfo:(FPStatementOM *)model {
    self.typeLabel.text = model.typeName;
    if ([model.Status isEqual:@"1"]) {
        self.statusLabel.text = [self oStatusName:model.Status];
    } else if ([model.Status isEqual:@"2"]) {
        self.statusLabel.text = model.Name;
    } else {
        self.statusLabel.text = model.Name;
    }    self.timeLabel.text = model.utc2Local;
    NSInteger modelType = [model.Type integerValue];
    if (modelType == StatementListTypeDeposit
        || modelType == StatementListTypeTransferIn
        || modelType == StatementListTypeGPayExchangeIn
        || modelType == StatementListTypeGPayBuyCrpytoCode
        || modelType == StatementListTypeGateway
        || modelType == StatementListTypeMerchantPaymentIn
        || modelType == StatementListTypeMerchantRefund
        || modelType == StatementListTypeHuazhuanIn
        || modelType == StatementListTypeRequestFundIn
        || modelType == StatementListTypeRequestPaymentIn)

    {
        //加
        self.amountLabel.text = [NSString stringWithFormat:@"+%@ %@",
                                 [DecimalUtils.shared stringInLocalisedFormatWithInput:model.CryptoAmount preferredFractionDigits:model.decimalPlace],
                                 model.Code];
    } else {
        //-
        self.amountLabel.text = [NSString stringWithFormat:@"-%@ %@",
                                 [DecimalUtils.shared stringInLocalisedFormatWithInput:model.CryptoAmount preferredFractionDigits:model.decimalPlace],
                                 model.Code];
    }
    
    if (model.IconUrl){
        [self.iconImageView setImageWithURL:[NSURL URLWithString:model.IconUrl]];
    } else {
        self.iconImageView.image = [UIImage imageNamed:[self getIconNameFromModelType:modelType withStatus:model.Status]];
    }
}

- (NSString *)getIconNameFromModelType:(NSInteger)modelType withStatus:(nullable NSString*) statusCode {
    NSString *iconName = @"";
    switch (modelType) {
        case StatementListTypeDeposit:
            //充币
            iconName = @"statement_icon_deposit";
            break;
        case StatementListTypeWithdraw:
            //提币
            iconName = @"statement_icon_withdrawal";
            break;
        case StatementListTypePay:
            //线下消费
            iconName = @"statement_icon_pay";
            break;
//        case StatementListTypeRefund:
//            //退款
//            iconName = @"statement_icon_pay";
//            break;
        case StatementListTypeMerchantRefundOut:
            //退款
            iconName = @"statement_icon_pay";
            break;
        case StatementListTypeTransferOut:
            iconName = @"statement_send_outgoing";
            break;
        case StatementListTypeTransferIn:
            //转账
            iconName = @"statement_send_incoming";
            break;
        case StatementListTypeGPayExchangeOut:
        case StatementListTypeGPayExchangeIn:
            //闪兑
            iconName = @"statement_otc_exchage_icon";
            break;
        case StatementListTypeGPayBuyCrpytoCode:
        case StatementListTypeGPaySellCrpytoCode:
            //信用卡买币、售币
            iconName = @"statement_icon_buycrpyto";
            break;
        case StatementListTypeGatewayOrderOutcome:
        case StatementListTypeGatewayOrderRefund:
            //线上消费及退款
            iconName = @"statement_icon_shopping_online";
            break;
        case StatementListTypeGateway:
        case StatementListTypeGatewayBack:
            //网关入账及退单
            iconName = @"statement_icon_paymentgateway";
            break;

        case StatementListTypeHuazhuanOut:
            iconName = @"statement_transfer_outgoing";
            break;
        case StatementListTypeHuazhuanIn:
            iconName = @"statement_transfer_incoming";
            break;
        case StatementListTypeMerchantPaymentOut:
        case StatementListTypeMerchantPaymentIn:
        case StatementListTypeMerchantRefund:
            iconName = @"merchant_GFashion";
            break;
        case StatementListTypeRequestFundIn:
            if ([statusCode isEqual:@"1"]) {
                iconName = @"statement_fund_request_Pending";
            } else if ([statusCode isEqual:@"2"]) {
                iconName = @"statement_fund_received_request";
            } else {
                iconName = @"";
            }
            break;
        case StatementListTypeRequestFundOut:
            if ([statusCode isEqual:@"2"]) {
                iconName = @"statement_fund_sent_request";
            } else {
                iconName = @"";
            }
            break;
        case StatementListTypeRequestPaymentIn:
            if ([statusCode isEqual:@"1"]) {
                iconName = @"statement_fund_request_Pending";
            } else if ([statusCode isEqual:@"2"]) {
                iconName = @"statement_fund_received_request";
            } else {
                iconName = @"";
            }
            break;
        case StatementListTypeRequestPaymentOut:
            if ([statusCode isEqual:@"2"]) {
                iconName = @"statement_fund_sent_request";
            } else {
                iconName = @"";
            }
            break;
        default:
            break;
    }
    return iconName;
}

@end
