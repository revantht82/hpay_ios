#import <UIKit/UIKit.h>
#import "JXCategoryTitleView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FPHomeMenuSearchBar : UIView
@property(weak, nonatomic) IBOutlet UIImageView *imageView;
@property(weak, nonatomic) IBOutlet UIView *topView;
@property(nonatomic, strong) JXCategoryTitleView *categoryView;
@property(weak, nonatomic) IBOutlet UIView *bottomView;
@property(nonatomic, copy) void (^homeMenuSearchBarItemClick)(NSInteger index);
@end

NS_ASSUME_NONNULL_END
