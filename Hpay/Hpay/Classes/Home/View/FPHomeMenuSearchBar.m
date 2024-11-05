#import "FPHomeMenuSearchBar.h"

@interface FPHomeMenuSearchBar () <JXCategoryViewDelegate>

@end

@implementation FPHomeMenuSearchBar

- (void)awakeFromNib {
    [super awakeFromNib];
//    UIImage *image = [UIImage createGradientImageWithFromColor:kThemeGradientFromColor toColor:kThemeGradientToColor];
    UIImage *image = [UIImage createImageWithColor:kDarkNightColor];
    self.imageView.image = image;
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(10, (50 - 13) / 2 + (107 - 50), 2, 13)];
    leftLine.backgroundColor = UIColor.whiteColor;
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftLine.frame) + 8, 107 - 50, [UIScreen mainScreen].bounds.size.width, 50)];
    self.categoryView.averageCellSpacingEnabled = NO;
//    self.categoryView.titles = @[@"钱包账户", @"法币账户",@"OTC账户"];
    self.categoryView.titles = @[NSLocalizedHome(@"home.account_list.heading")];
    self.categoryView.backgroundColor = [UIColor clearColor];
    self.categoryView.delegate = self;
    self.categoryView.titleColorGradientEnabled = YES;
    self.categoryView.titleLabelZoomEnabled = NO;
    self.categoryView.titleColor = UIColorFromRGBA(0xFFFFFF, 0.4);
    self.categoryView.titleSelectedColor = kSurfaceColor;
    self.categoryView.contentEdgeInsetLeft = 0;
    UIFont *categoryViewTitleFont = kFontSecondarySemibold(14.0);
    self.categoryView.titleFont = categoryViewTitleFont;

//    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
//    lineView.indicatorLineViewColor = self.categoryView.titleSelectedColor;
//    lineView.indicatorLineWidth = 30;
//    self.categoryView.indicators = @[lineView];
    [self.topView addSubview:self.categoryView];
    [self.topView addSubview:leftLine];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    if (self.homeMenuSearchBarItemClick) {
        self.homeMenuSearchBarItemClick(index);
    }
}
@end
