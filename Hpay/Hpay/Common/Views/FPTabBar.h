//
//  PFTabBar.h
//  GiiiPlus
//
//  Created by apple on 2017/8/24.
//
//

#import <UIKit/UIKit.h>

@protocol FPTabBarDelegate <NSObject>

@required
- (void)changeTabByIndex:(NSInteger)fromTabIndex toTabByIndex:(NSInteger)toTabIndex;

@end

@interface FPTabBar : UIView

@property(weak, nonatomic) id <FPTabBarDelegate> delegate;

- (void)selectIndex:(NSInteger)index;

- (void)updateBadgeNumOrPoint:(NSInteger)count;

- (void)hidenProfileRedDot:(BOOL)hidden;
@end
