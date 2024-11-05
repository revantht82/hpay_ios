//
//  Created by ONUR YILMAZ on 21/03/2022.
//  Copyright © 2022 Himalaya. All rights reserved.
//

#import "FPViewController.h"
#import "RequestIndividualConfirmationView.h"
#import "QRView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RequestmoneyIndividualViewController : FPViewController <RequestIndividualConfirmationViewDelegate, QRViewDelegate > 

-(void)updateSelectorLabels:(NSString *)productCategory;

@end

NS_ASSUME_NONNULL_END
