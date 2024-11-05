#import "HPHomeBaseRouter.h"
#import "QRCodeReaderViewController.h"
#import "HomeViewController.h"
#import "FPStatementOM.h"
#import "FBCoin.h"

@protocol HPHomeRouterInterface <HPHomeBaseRouterInterface>

- (void)pushToChooseCoinTransfer;
-(void)pushToChooseCoinTransferScan:(NSString *_Nullable)userHash;
- (void)pushToChooseCoinDeposit;
- (void)pushToChooseCoinWithdrawal;
- (void)pushToHuZhuan;
- (void)pushToDeposit:(FBCoin *_Nonnull)coin;
- (void)pushToRequest;
- (void)pushToRequestIndividual;
- (void)pushToNotificationCenter;

- (void)presentToQrCodeReader:(nonnull HomeViewController*)homeViewController;
- (void)pushToStatementDetailWith:(nonnull FPStatementOM *)statementOM;
- (void)presentLogin:(void (^_Nullable)(void))loginSuccessHandler;
- (void)pushToTransferWithCoin:(FBCoin *_Nullable)coin userHash:(NSString*_Nullable)userHash;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HPHomeRouter : HPHomeBaseRouter <HPHomeRouterInterface>

@property (strong, nonatomic) QRCodeReaderViewController *qrReaderController;

@end

NS_ASSUME_NONNULL_END
