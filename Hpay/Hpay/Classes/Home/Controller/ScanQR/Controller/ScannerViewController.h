//
//  ScannerViewController.h
//  Hpay
//
//  Created by Younes Soltan on 20/05/2022.
//  Copyright © 2022 Himalaya. All rights reserved.
//

#import "FPViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ScanQRRouter.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScannerViewController : FPViewController <AVCaptureMetadataOutputObjectsDelegate>


@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;

@property (nonatomic) BOOL isReading;

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property(strong, nonatomic) ScanQRRouter<ScanQRRouterInterface> *router;

@end

NS_ASSUME_NONNULL_END
