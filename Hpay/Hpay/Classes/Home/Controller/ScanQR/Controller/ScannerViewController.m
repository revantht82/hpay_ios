//
//  ScannerViewController.m
//  Hpay
//
//  Created by Younes Soltan on 20/05/2022.
//  Copyright © 2022 Himalaya. All rights reserved.
//

#import "ScannerViewController.h"
#import "FPStatementOM.h"
#import "ScanQRRouter.h"

@interface ScannerViewController ()

@end

@implementation ScannerViewController

- (ScanQRRouter<ScanQRRouterInterface> *)router {
    if (_router == nil) {
        _router = [[ScanQRRouter alloc] init];
        _router.currentControllerDelegate = self;
        _router.navigationDelegate = self.navigationController;
        _router.tabBarControllerDelegate = self.tabBarController;
    }
    return _router;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
    [self startReading];
}

- (void)startReading {
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
 
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
       
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
    
}

-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    
    [_videoPreviewLayer removeFromSuperlayer];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
        NSString *urlQR =  metadataObj.stringValue;
        NSString *baseUrl = [urlQR substringToIndex:58];
        
        if ([RequestFundQRURL isEqualToString:baseUrl]) {
            NSString *orderId = [urlQR substringFromIndex:67];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"OrderId"] = orderId;
            FPStatementOM *statementOM = [FPStatementOM mModelWithData:dict];
     
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.router pushToStatementDetailWith:statementOM];
              });
            
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedDefault(@"request_invalid_qr") preferredStyle:UIAlertControllerStyleAlert];
            alert.title = @"";
            UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedDefault(@"okay") style:UIAlertActionStyleDefault handler: ^(UIAlertAction * _Nonnull action) {
                [self.navigationController popToRootViewControllerAnimated:true];
            }];
            
            [alert addAction:ok];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController presentViewController:alert animated:YES completion:nil];
            });
        }
    }
}


@end
