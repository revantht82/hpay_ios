/*
 * QRCodeReaderViewController
 *
 * Copyright 2014-present Yannick Loriot.
 * http://yannickloriot.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "QRCodeReaderViewController.h"
#import "QRCameraSwitchButton.h"
#import "QRCodeReaderView.h"

#define mainHeight     [[UIScreen mainScreen] bounds].size.height
#define mainWidth      [[UIScreen mainScreen] bounds].size.width
#define navBarHeight   self.navigationController.navigationBar.frame.size.height

@interface QRCodeReaderViewController () <AVCaptureMetadataOutputObjectsDelegate, QRCodeReaderViewDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) QRCameraSwitchButton *switchCameraButton;
@property (strong, nonatomic) QRCodeReaderView     *cameraView;
@property (strong, nonatomic) AVAudioPlayer        *beepPlayer;
@property (strong, nonatomic) UIButton             *cancelButton;
@property (strong, nonatomic) UIImageView          *imgLine;
@property (strong, nonatomic) UILabel              *lblTip1;
@property (strong, nonatomic) NSTimer              *timerScan;
@property (strong, nonatomic) NSString             *lpType;

@property (strong, nonatomic) AVCaptureDevice            *defaultDevice;
@property (strong, nonatomic) AVCaptureDeviceInput       *defaultDeviceInput;
@property (strong, nonatomic) AVCaptureDevice            *frontDevice;
@property (strong, nonatomic) AVCaptureDeviceInput       *frontDeviceInput;
@property (strong, nonatomic) AVCaptureMetadataOutput    *metadataOutput;
@property (strong, nonatomic) AVCaptureSession           *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic , strong) UIView *lineFrameView;

@property (copy, nonatomic) void (^completionBlock) (NSString *);

@end

@implementation QRCodeReaderViewController

- (id)init
{
    self = [super init];
    if (self) {
        NSString * wavPath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"wav"];
        NSData* data = [[NSData alloc] initWithContentsOfFile:wavPath];
        _beepPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
    }
    
    return [self initWithCancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")];
}

- (id)initWithCancelButtonTitle:(NSString *)cancelTitle lpTitle:(NSString *)lpType
{
    if ((self = [super init])) {
        _lpType = lpType;
        self.view.backgroundColor = [UIColor blackColor];
        
        [self setupAVComponents];
        [self configureDefaultComponents];
        [self setupUIComponentsWithCancelButtonTitle:cancelTitle];
        [self setupAutoLayoutConstraints];
        
        [_cameraView.layer insertSublayer:self.previewLayer atIndex:0];
        
    }
    return self;
}

- (id)initWithBackButtonAmdlpTitle:(NSString *)lpType
{
    if ((self = [super init])) {
        _lpType = lpType;
        self.view.backgroundColor = [UIColor blackColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftClick) name:kStartRescanQRCodeNotification object:nil];
        [self setupAVComponents];
        [self configureDefaultComponents];
        [self setupUIComponentsWithCancelButtonImage];
        [self setupAutoLayoutConstraints];
        
        [_cameraView.layer insertSublayer:self.previewLayer atIndex:0];
        
    }
    return self;
}

- (id)initWithCancelButtonTitle:(NSString *)cancelTitle
{
    if ((self = [super init])) {
        self.view.backgroundColor = [UIColor blackColor];
        
        [self setupAVComponents];
        [self configureDefaultComponents];
        [self setupUIComponentsWithCancelButtonTitle:cancelTitle];
        [self setupAutoLayoutConstraints];
        
        [_cameraView.layer insertSublayer:self.previewLayer atIndex:0];
        
    }
    return self;
}

+ (instancetype)readerWithCancelButtonTitle:(NSString *)cancelTitle {
    return [[self alloc] initWithCancelButtonTitle:cancelTitle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLeftBarBtn];
    self.fd_prefersNavigationBarHidden = YES;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startScanning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self stopScanning];
    [super viewWillDisappear:animated];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    _previewLayer.frame = self.view.bounds;
    self.lblTip1.hidden = self.hidenTipsLabel;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)hasTopNotch {
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in windows) {
        if (window.isKeyWindow) {
            return window.safeAreaInsets.top > 20.0;
        }
    }
    
    return NO;
}

- (void)initLeftBarBtn {
    
}

-(void)setupRightBarBtn {
    
}

- (void)scanAnimate
{
    self.imgLine.mj_y = 0;
    [UIView animateWithDuration:2 animations:^{
        self.imgLine.mj_y = CGRectGetHeight(self.lineFrameView.frame);
    }];
}

- (void)loadView:(CGRect)rect
{
    [self scanAnimate];
}

-(void)leftClick{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - Managing the Orientation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [_cameraView setNeedsDisplay];
    
    if (self.previewLayer.connection.isVideoOrientationSupported) {
        self.previewLayer.connection.videoOrientation = [[self class] videoOrientationFromInterfaceOrientation:toInterfaceOrientation];
    }
}

+ (AVCaptureVideoOrientation)videoOrientationFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    switch (interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            return AVCaptureVideoOrientationLandscapeLeft;
        case UIInterfaceOrientationLandscapeRight:
            return AVCaptureVideoOrientationLandscapeRight;
        case UIInterfaceOrientationPortrait:
            return AVCaptureVideoOrientationPortrait;
        default:
            return AVCaptureVideoOrientationPortraitUpsideDown;
    }
}

#pragma mark - Managing the Block

- (void)setCompletionWithBlock:(void (^) (NSString *resultAsString))completionBlock
{
    self.completionBlock = completionBlock;
}

#pragma mark - 返回图片
- (void)setupUIComponentsWithCancelButtonImage
{
    [self setupUIComponentsWithCancelButtonTitle:@""];
}

#pragma mark - Initializing the AV Components

- (void)setupUIComponentsWithCancelButtonTitle:(NSString *)cancelButtonTitle
{
    self.cameraView                                       = [[QRCodeReaderView alloc] init];
    _cameraView.translatesAutoresizingMaskIntoConstraints = NO;
    _cameraView.clipsToBounds                             = YES;
    _cameraView.delegate                                  = self;
    [self.view addSubview:_cameraView];
    
    
    
    if (_frontDevice) {
        _switchCameraButton = [[QRCameraSwitchButton alloc] init];
        [_switchCameraButton setTranslatesAutoresizingMaskIntoConstraints:false];
        [_switchCameraButton addTarget:self action:@selector(switchCameraAction:) forControlEvents:UIControlEventTouchUpInside];
        _switchCameraButton.hidden = YES;
        [self.view addSubview:_switchCameraButton];
    }
    
    self.cancelButton                                       = [[UIButton alloc] init];
    self.cancelButton.hidden                                = YES;
    _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.cancelButton.frame = CGRectMake(15, 20, 60, 30);
    [_cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_cancelButton];
    
    UIButton *closeBtn = [[UIButton alloc]init];
    if (self.hasTopNotch) {
        closeBtn.frame = CGRectMake(-5, 50, 60, 40);
    } else {
        closeBtn.frame = CGRectMake(-10, 20, 60, 40);
    }
    [closeBtn setTitle:cancelButtonTitle forState:UIControlStateNormal];
    if (cancelButtonTitle && [cancelButtonTitle isEqualToString:@""])
    {
        [closeBtn setImage:[UIImage imageNamed:@"login_Back"] forState:UIControlStateNormal];
    }
    [closeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    
    CGFloat c_width = mainWidth - 100;
    CGFloat s_height = mainHeight - 40;
    CGFloat y = (s_height - c_width) / 2 - s_height / 6;
    
    
    UILabel *tipsLabel = [[UILabel alloc]init];
    tipsLabel.text = self.lpType;
    tipsLabel.font = UIFontMake(20);
    tipsLabel.textColor = [UIColor whiteColor];
    tipsLabel.frame = CGRectMake(0, y - 52 + 64, SCREEN_WIDTH, 28);
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipsLabel];
    
    UILabel *ctititleLabel = [[UILabel alloc]init];
    //    ctititleLabel.text = @"扫描二维码";
    ctititleLabel.font = UIFontMake(17);
    ctititleLabel.textColor = [UIColor whiteColor];
    if (self.hasTopNotch) {
        ctititleLabel.frame = CGRectMake(0, y - 52 + 30, SCREEN_WIDTH, 28);
    }else{
        ctititleLabel.frame = CGRectMake(0, y - 52 + 10, SCREEN_WIDTH, 28);
    }
    
    ctititleLabel.textAlignment = NSTextAlignmentCenter;
    self.ctititleLabel = ctititleLabel;
    [self.view addSubview:ctititleLabel];
    
    CGFloat corWidth = 16;
    UIImage *corImage = [UIImage imageNamed:@"cor1"];
    UIImageView* img1 = [[UIImageView alloc] initWithFrame:CGRectMake(49, y + 77, corWidth, corWidth)];
    img1.image = corImage;
    img1.image = [corImage imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
    img1.tintColor = kMarigoldColor;
    [self.view addSubview:img1];
    
    UIImageView* img2 = [[UIImageView alloc] initWithFrame:CGRectMake(35 + c_width, y + 77, corWidth, corWidth)];
    img2.image = corImage;
    img2.image = [corImage imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
    img2.tintColor = img1.tintColor;
    img2.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    [self.view addSubview:img2];
    
    UIImageView* img3 = [[UIImageView alloc] initWithFrame:CGRectMake(49, y + c_width + 64, corWidth, corWidth)];
    img3.image = corImage;
    img3.image = [corImage imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
    img3.tintColor = img1.tintColor;
    img3.transform = CGAffineTransformMakeScale(1.0,-1.0);
    [self.view addSubview:img3];
    
    UIImageView* img4 = [[UIImageView alloc] initWithFrame:CGRectMake(35 + c_width, y + c_width + 64, corWidth, corWidth)];
    img4.image = corImage;
    img4.image = [corImage imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
    img4.tintColor = img1.tintColor;
    img4.transform = CGAffineTransformMakeScale(-1.0,-1.0);
    [self.view addSubview:img4];
    
    
    UIView *lineFrameView = [UIView new];
    lineFrameView.frame = CGRectMake(49, y + 77,c_width, CGRectGetMaxY(img4.frame) - CGRectGetMinY(img1.frame));
    [self.view addSubview:lineFrameView];
    self.lineFrameView = lineFrameView;
    _imgLine = [[UIImageView alloc] init];
    UIImage *lineImage = [UIImage imageNamed:@"QRCodeScanLine"];
    _imgLine.image = lineImage;
    _imgLine.image = [lineImage imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
    _imgLine.tintColor = kMarigoldColor;
    _imgLine.frame = CGRectMake(0,20, CGRectGetWidth(lineFrameView.frame), 12);
    [lineFrameView addSubview:_imgLine];
    lineFrameView.clipsToBounds = YES;
    
    UILabel *tipsLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(img4.frame)+50, mainWidth-20, 50)];
    tipsLabel1.text = NSLocalizedHome(@"qr_code_help_text");
    tipsLabel1.numberOfLines = 0;
    tipsLabel1.textColor = [UIColor whiteColor];
    tipsLabel1.font = UIFontMake(14);
    tipsLabel1.textAlignment = NSTextAlignmentCenter;
    NSDictionary *attrs = @{NSFontAttributeName :tipsLabel1.font};
    CGSize maxSize = CGSizeMake(mainWidth-20, MAXFLOAT);
    
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    CGSize size = [tipsLabel1.text boundingRectWithSize:maxSize options:options attributes:attrs context:nil].size;
    tipsLabel1.mj_h = size.height;
    tipsLabel1.hidden = self.hidenTipsLabel;
    self.lblTip1 = tipsLabel1;
    [self.view addSubview:tipsLabel1];
    
}

- (void)setupAutoLayoutConstraints
{
    NSDictionary *views = NSDictionaryOfVariableBindings(_cameraView, _cancelButton);
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_cameraView][_cancelButton(0)]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cameraView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_cancelButton]-|" options:0 metrics:nil views:views]];
    
    if (_switchCameraButton) {
        NSDictionary *switchViews = NSDictionaryOfVariableBindings(_switchCameraButton);
        
        [self.view addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_switchCameraButton(50)]" options:0 metrics:nil views:switchViews]];
        [self.view addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_switchCameraButton(70)]|" options:0 metrics:nil views:switchViews]];
    }
}

- (void)setupAVComponents
{
    NSError *error;
    self.defaultDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (_defaultDevice) {
        self.defaultDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_defaultDevice error:&error];
        
        self.metadataOutput     = [[AVCaptureMetadataOutput alloc] init];
        self.session            = [[AVCaptureSession alloc] init];
        self.previewLayer       = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        
        AVCaptureDeviceDiscoverySession *captureDeviceDiscoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera]
                                              mediaType:AVMediaTypeVideo
                                               position:AVCaptureDevicePositionBack];
        NSArray *captureDevices = [captureDeviceDiscoverySession devices];

        for (AVCaptureDevice *device in captureDevices) {
            if (device.position == AVCaptureDevicePositionFront) {
                self.frontDevice = device;
            }
        }
        
        if (_frontDevice) {
            self.frontDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_frontDevice error:nil];
        }
        
        self.session.sessionPreset = AVCaptureSessionPresetHigh;
    } else {
        NSLog(@"Error %@", error.localizedDescription);
    }
}

- (void)configureDefaultComponents
{
    [_session addOutput:_metadataOutput];
    
    if (_defaultDeviceInput) {
        [_session addInput:_defaultDeviceInput];
    }
    
    [_metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    NSMutableArray *metadataObjectTypes = [NSMutableArray array];
    if ([[_metadataOutput availableMetadataObjectTypes] containsObject:AVMetadataObjectTypeQRCode]) {
        [metadataObjectTypes addObject:AVMetadataObjectTypeQRCode];
    }
    if ([[_metadataOutput availableMetadataObjectTypes] containsObject:AVMetadataObjectTypeEAN13Code]) {
        [metadataObjectTypes addObject:AVMetadataObjectTypeEAN13Code];
    }
    if ([[_metadataOutput availableMetadataObjectTypes] containsObject:AVMetadataObjectTypeEAN8Code]) {
        [metadataObjectTypes addObject:AVMetadataObjectTypeEAN8Code];
    }
    if ([[_metadataOutput availableMetadataObjectTypes] containsObject:AVMetadataObjectTypeCode128Code]) {
        [metadataObjectTypes addObject:AVMetadataObjectTypeCode128Code];
    }
    
    [_metadataOutput setMetadataObjectTypes:metadataObjectTypes];
    [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_previewLayer setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    if ([_previewLayer.connection isVideoOrientationSupported]) {
        
        _previewLayer.connection.videoOrientation = [[self class] videoOrientationFromInterfaceOrientation:self.interfaceOrientation];
    }
    
//    __weak typeof(self) weakSelf = self;
//    [[NSNotificationCenter defaultCenter]addObserverForName:AVCaptureInputPortFormatDescriptionDidChangeNotification
//                                                     object:nil
//                                                      queue:[NSOperationQueue mainQueue]
//                                                 usingBlock:^(NSNotification * _Nonnull note) {
//        if (weakSelf){
//            //调整扫描区域
//            AVCaptureMetadataOutput *output = weakSelf.session.outputs.firstObject;
//            output.rectOfInterest = [weakSelf.previewLayer metadataOutputRectOfInterestForRect:weakSelf.cameraView.innerViewRect];
//        }
//    }];
}

- (void)switchDeviceInput
{
    if (_frontDeviceInput) {
        [_session beginConfiguration];
        
        AVCaptureDeviceInput *currentInput = [_session.inputs firstObject];
        [_session removeInput:currentInput];
        
        AVCaptureDeviceInput *newDeviceInput = (currentInput.device.position == AVCaptureDevicePositionFront) ? _defaultDeviceInput : _frontDeviceInput;
        [_session addInput:newDeviceInput];
        
        [_session commitConfiguration];
    }
}

#pragma mark - Catching Button Events

- (void)cancelAction:(UIButton *)button
{
    [self stopScanning];
    
    if (_completionBlock) {
        _completionBlock(nil);
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(readerDidCancel:)]) {
        [_delegate readerDidCancel:self];
    }
}

- (void)switchCameraAction:(UIButton *)button
{
    [self switchDeviceInput];
}

#pragma mark - Controlling Reader

- (void)startScanning;
{
//    [_delegate reader:self didScanResult:@"https://hpmvp-83-hpay-merchant-api.dev.aws.himalaya.exchange/pay?OrderId=f4e059e2-5dfb-4228-9bdc-0f0f7ee81ff1"];
//    return;
    
    if (![self.session isRunning]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            [self.session startRunning];

        });

    }
    
    if(_timerScan)
    {
        [_timerScan invalidate];
        _timerScan = nil;
    }
    
    _timerScan = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scanAnimate) userInfo:nil repeats:YES];
}

- (void)stopScanning;
{
    if ([self.session isRunning]) {
        [self.session stopRunning];
    }
    if(_timerScan)
    {
        [_timerScan invalidate];
        _timerScan = nil;
    }
}

#pragma mark - AVCaptureMetadataOutputObjects Delegate Methods

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    for(AVMetadataObject *current in metadataObjects) {
        if ([current isKindOfClass:[AVMetadataMachineReadableCodeObject class]]
            && [current.type isEqualToString:AVMetadataObjectTypeQRCode])
        {
            NSString *scannedResult = [(AVMetadataMachineReadableCodeObject *) current stringValue];
            
            [self stopScanning];
            if (_completionBlock) {
                [_beepPlayer play];
                _completionBlock(scannedResult);
            }
            
            if (_delegate && [_delegate respondsToSelector:@selector(reader:didScanResult:)]) {
                [_delegate reader:self didScanResult:scannedResult];
            }
            
            break;
        }
    }
}

#pragma mark - Checking the Metadata Items Types

+ (BOOL)isAvailable
{
    @autoreleasepool {
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if (!captureDevice) {
            return NO;
        }
        
        NSError *error;
        AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
        
        if (!deviceInput || error) {
            return NO;
        }
        
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        
        if (![output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
            return NO;
        }
        
        return YES;
    }
}

-(void)barcodeResult:(NSString *)scannedResult{
    
}

- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
