#import "FPViewController.h"

@protocol StatementDetailDelegate <NSObject>

-(void)requestFundDidCanceled;

@end

@interface StatementDetailViewController : FPViewController

- (void)configWithType:(StatementListType)detailType andId:(NSString *)ID andUrl:(NSString *)url;
- (void)configForFundRequestWithType:(StatementListType)detailType andId:(NSString *)ID andUrl:(NSString *)url andSeuge:(NSString*)seugeIdentifier;
- (void)configureDismissBarButtonItem;

@property(nonatomic, assign) ActionResultVCFrom actionResult;
@property(nonatomic, assign) id delegate;

@end
