//
//  RequestmoneyViewController.h
//  Hpay
//
//  Created by ONUR YILMAZ on 21/03/2022.
//  Copyright © 2022 Himalaya. All rights reserved.
//

#import "FPViewController.h"
#import "RequestConfirmationView.h"
#import "QRView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RequestmoneyViewController : FPViewController <RequestConfirmationViewDelegate, QRViewDelegate > 

-(void)updateSelectorLabels:(NSString *)productCategory;

@end

NS_ASSUME_NONNULL_END
