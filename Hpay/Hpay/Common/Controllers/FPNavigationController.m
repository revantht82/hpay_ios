#import "FPNavigationController.h"

@interface FPNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation FPNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self openCFYNavigationBarFunction:YES];
    [self applyTheme];
}

- (void)setUpNavBar {

}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self applyTheme];
}

- (void)applyTheme{
    id<ThemeProtocol> theme = [self getCurrentTheme];
    UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
    [appearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: theme.onToolbar, NSForegroundColorAttributeName, nil]];
    appearance.backgroundColor = theme.toolbar;
    self.navigationBar.standardAppearance = appearance;
    self.navigationBar.scrollEdgeAppearance = appearance;
    self.navigationBar.compactAppearance = appearance;
    
    [self.navigationBar setTintColor:theme.onToolbar];
    [self.navigationBar setBarTintColor:theme.toolbar];
    self.navigationBar.translucent = YES;
    self.navigationBar.backgroundColor = theme.toolbar;
}


//设置样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count == 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }

    [super pushViewController:viewController animated:animated];
}

@end
