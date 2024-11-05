#import "StatementRouter.h"
#import "StatementDetailViewController.h"
#import <SafariServices/SafariServices.h>
#import "FPStatementOM.h"
#import "FPUtils.h"

@implementation StatementRouter

- (nonnull StatementDetailViewController *)statementDetailViewController {
    StatementDetailViewController *vc = [SB_STATEMENT instantiateViewControllerWithIdentifier:[StatementDetailViewController className]];
    return vc;
}

- (void)pushToStatementDetailWith:(FPStatementOM *)statementOM :(id)viewController {
    StatementDetailViewController *vc = self.statementDetailViewController;
    vc.delegate = viewController;
    StatementListType cType = [statementOM.Type integerValue];
    struct MStatement mStatement = [FPUtils fetchDetailMStatementByListType:cType];
    NSString *url = [FPUtils convertByChar:mStatement.url];
    NSString *title = [FPUtils convertByChar:mStatement.title];
    vc.title = title;
    [vc configForFundRequestWithType:cType andId: statementOM.OrderId  andUrl:url andSeuge:@"StatementController"];
    [self pushTo:vc];
}

-(void)pushToExport {
    
    
    
    NSURL *zendeskURL = [NSURL URLWithString:@"https://hch-public-documents-dev.s3.eu-west-2.amazonaws.com/assets/HPayTransactions_GqaIeQZpAUmCskUnKs9K1A.csv?X-Amz-Expires=86400&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIASNWRFMBP7MCIAE7O/20230518/eu-west-2/s3/aws4_request&X-Amz-Date=20230518T100001Z&X-Amz-SignedHeaders=host&X-Amz-Signature=b23bc1df062c19eb8d8da56fc8781b02b3641cefd23ddeb6e372a30c787a8e80"];
    SFSafariViewController *safariController = [[SFSafariViewController alloc] initWithURL:zendeskURL];
    [self present:safariController];
}

@end
