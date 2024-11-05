//
//  PFTabBar.m
//  GiiiPlus
//
//  Created by apple on 2017/8/24.
//
//

#import "FPTabBar.h"
#import "FPTabBarButton.h"
#import "UIImage+Extension.h"

#define kButtonTagNum 9000

@interface FPTabBar ()
@property(nonatomic, strong) NSArray *array;
@property(nonatomic, strong) FPTabBarButton *selectedBarButton;
@property(nonatomic, strong) NSMutableArray<FPTabBarButton *> *barButtons;
@property(nonatomic, strong) UILabel *mineBadgeLabel;
@property(nonatomic, strong) UIImageView *redDotImageView;
@end

@implementation FPTabBar

#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kSurfaceColor;
        [self initTabBarButtons];
        [self initTabBarBadgeRound];
    }
    return self;
}

#pragma mark - 选中index 对应的button

- (void)selectIndex:(NSInteger)index {
    FPTabBarButton *btn = (FPTabBarButton *) [self viewWithTag:(kButtonTagNum + index)];
    self.selectedBarButton.selected = NO;
    btn.selected = YES;
    self.selectedBarButton = btn;
}

#pragma mark - 初始化自定义Button

- (void)initTabBarButtons {
    
    //设计加载json文件
    NSArray *array =
    @[
        @{
            @"NormalImage": @"tabbar_home_normal",
            @"SelectedImage": @"tabbar_home_selected",
            @"Title": NSLocalizedDefault(@"home")
        },
        @{
            @"NormalImage": @"tabbar_statement_normal",
            @"SelectedImage": @"tabbar_statement_normal",
            @"Title": NSLocalizedDefault(@"transactionsTitle")
        },
        @{
            @"NormalImage": @"tabbar_profile_normal",
            @"SelectedImage": @"tabbar_profile_selected",
            @"Title": NSLocalizedDefault(@"profile")
        }
    ];
    
    self.array = array;
    self.barButtons = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < array.count; i++) {
        FPTabBarButton *btn = [FPTabBarButton buttonWithType:UIButtonTypeCustom];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        btn.tag = kButtonTagNum + i;
        NSDictionary *dict = array[i];
        [btn setTitle:dict[@"Title"] forState:UIControlStateNormal];
        btn.titleLabel.font = UIFontMake(10);
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        [self applyThemeToButton:btn images:dict];
        [self.barButtons addObject:btn];
        [self addSubview:btn];
        if (i == 0) {
            btn.selected = YES;
            self.selectedBarButton = btn;
        }
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    for (NSInteger i = 0; i < self.barButtons.count; i++) {
        NSDictionary *dict = self.array[i];
        FPTabBarButton *button = self.barButtons[i];
        [self applyThemeToButton:button images:dict];
    }
}

- (void)applyThemeToButton:(UIButton *)button images:(NSDictionary *)images{
    UIImage *normalImage = [UIImage imageNamed:images[@"NormalImage"]];
    UIImage *selectedImage = [UIImage imageNamed:images[@"SelectedImage"]];
    [button setImage: [normalImage tintedWithColor:[self getCurrentTheme].secondaryOnSurface] forState:UIControlStateNormal];
    [button setImage: [selectedImage tintedWithColor:[self getCurrentTheme].primaryOnSurface] forState:UIControlStateSelected];
    [button setTitleColor:[self getCurrentTheme].secondaryOnSurface forState:UIControlStateNormal];
    [button setTitleColor:[self getCurrentTheme].primaryOnSurface forState:UIControlStateSelected];
}

#pragma mark - 初始化自定义Button上badgeView

- (void)initTabBarBadgeRound {
    self.mineBadgeLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 4, 14, 14);
        label.backgroundColor = kUnreadDotColor;
        label.layer.cornerRadius = 7;
        label.font = UIFontMake(12);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.layer.masksToBounds = YES;
        label.hidden = YES;
        label;
    });
    //我的
    FPTabBarButton *carBtn = [self viewWithTag:kButtonTagNum + 2];
    [carBtn addSubview:self.mineBadgeLabel];
}


- (void)initTabbarRedDot {
    FPTabBarButton *profileBtn = [self viewWithTag:kButtonTagNum + 3];
    UIImageView *redDotImageView = [UIImageView new];
    redDotImageView.backgroundColor = kCranberryColor;
    redDotImageView.frame = CGRectMake(0, 4, 6, 6);
    redDotImageView.layer.cornerRadius = 3;
    self.redDotImageView = redDotImageView;
    
    [profileBtn addSubview:redDotImageView];
    redDotImageView.hidden = YES;
}

- (void)hidenProfileRedDot:(BOOL)hidden {
    self.redDotImageView.hidden = hidden;
}

#pragma mark -

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat btnW = SCREEN_WIDTH / self.array.count;
    for (NSInteger i = 0; i < self.array.count; i++) {
        FPTabBarButton *btn = [self viewWithTag:kButtonTagNum + i];
        btn.frame = CGRectMake(i * btnW, 0, btnW, CGRectGetHeight(self.frame));
        if (i == 2) {
            //我的
            CGRect minePoinyFrame = self.mineBadgeLabel.frame;
            minePoinyFrame.origin.x = btnW / 2 + 6;
            self.mineBadgeLabel.frame = minePoinyFrame;
        }
        if (i == 3) {
            //我的
            CGRect redDotImageViewFrame = self.redDotImageView.frame;
            redDotImageViewFrame.origin.x = btnW / 2 + 6;
            self.redDotImageView.frame = redDotImageViewFrame;
        }
    }
}

#pragma mark - 点击事件

- (void)btnClick:(FPTabBarButton *)button {
    [self.delegate changeTabByIndex:self.selectedBarButton.tag - kButtonTagNum toTabByIndex:button.tag - kButtonTagNum];
    if(button.tag != 9001){
        self.selectedBarButton.selected = NO;
        button.selected = YES;
        self.selectedBarButton = button;
    }
}

#pragma mark - 更新红点或badge条数

- (void)updateBadgeNumOrPoint:(NSInteger)count {
    if (count == 0) {
        self.mineBadgeLabel.hidden = YES;
    } else {
        self.mineBadgeLabel.hidden = NO;
        NSString *str = [NSString stringWithFormat:@"%@", @(count)];
        self.mineBadgeLabel.text = str;
        CGRect circleF = self.mineBadgeLabel.frame;
        circleF.size.width = [self getTextWidth:str] + 6;
        self.mineBadgeLabel.frame = circleF;
    }
    
}

- (CGFloat)getTextWidth:(NSString *)string {
    UIFont *font = UIFontMake(15);
    CGSize constraint = CGSizeMake(60, MAXFLOAT);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [string boundingRectWithSize:constraint
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName: font}
                                              context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    return size.width;
    
}

@end
