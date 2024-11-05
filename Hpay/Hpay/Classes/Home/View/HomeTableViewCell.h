#import <UIKit/UIKit.h>
#import "FBCoin.h"

@interface HomeTableViewCell : UITableViewCell

@property(weak, nonatomic) IBOutlet UIView *viewContainer;
@property(weak, nonatomic) IBOutlet UILabel *labelCoinName;
@property(weak, nonatomic) IBOutlet UILabel *labelAvailableCoin;
@property(weak, nonatomic) IBOutlet UILabel *labelExchangeRate;
@property(weak, nonatomic) IBOutlet UILabel *labelFiat;

- (void)configCoinModel:(FBCoin *)coinModel visible:(BOOL)Visible;
@end
