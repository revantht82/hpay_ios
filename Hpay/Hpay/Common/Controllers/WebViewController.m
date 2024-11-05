//
//  WebViewController.m
//  Hpay
//
//  Created by Alexander Alekseev on 04/07/2023.
//  Copyright © 2023 Himalaya. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

NSString *const DIR_FOR_TMP_FILE = @"tmp_files";

@interface WebViewController ()
@property (strong, nonatomic) WKWebView *webView;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.webView];
    //webView.navigationDelegate = self;
    if (self.html){
        [self.webView loadHTMLString:self.html baseURL:nil];
    } else if (self.file) {
        [self downloadAndOpenFile:self.file useName:self.filename2save];
    }
}

- (void)downloadAndOpenFile:(NSString*)fileURL useName:(NSString*)filename2save {
    [MBHUD showInView:self.view withDetailTitle:nil withType:HUDTypeLoading];
    // Create a URL for the file
    NSURL *url = [NSURL URLWithString:fileURL];
    
    // Create a request and session to download the file
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBHUD hideInView:self.view];
        });
        
        if (error) {
            NSLog(@"Error downloading file: %@", error.localizedDescription);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Unexpected error has occurred.", nil) message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"okay", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
                }];
                [alertController addAction:cancel];
                [self presentViewController:alertController animated:YES completion:nil];
            });
            
        } else {
            NSError *moveError;
            
            NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:DIR_FOR_TMP_FILE];
            
            [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&moveError];
            
            filePath = [filePath stringByAppendingPathComponent:filename2save];
            
            [[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:filePath] error:&moveError];
            if ([[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:filePath] error:&moveError]) {
                // Open the downloaded file in the WKWebView
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
                    [self.webView loadFileURL:fileURL allowingReadAccessToURL:fileURL];
                    
                    // Add a sharing option (e.g., share button)
                    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareFile)];
                    self.navigationItem.rightBarButtonItem = shareButton;
                });
            } else {
                NSLog(@"Error moving file: %@", moveError.localizedDescription);
            }
        }
    }];
    
    [downloadTask resume];
}

- (void)shareFile {
    // Implement sharing functionality here using UIActivityViewController
    NSString *filePath = [self.webView.URL path];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[fileURL] applicationActivities:nil];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)removeAllFilesInFolder:(NSString *)folderPath {
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Check if the folder exists
    if ([fileManager fileExistsAtPath:folderPath isDirectory:NULL]) {
        NSArray *fileArray = [fileManager contentsOfDirectoryAtPath:folderPath error:&error];
        
        if (error) {
            NSLog(@"Error listing files in the folder: %@", error.localizedDescription);
            return;
        }
        
        for (NSString *fileName in fileArray) {
            NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
            
            // Check if the file can be removed
            if ([fileManager isDeletableFileAtPath:filePath]) {
                NSError *removeError;
                if ([fileManager removeItemAtPath:filePath error:&removeError]) {
                    NSLog(@"Removed file: %@", fileName);
                } else {
                    NSLog(@"Error removing file: %@", removeError.localizedDescription);
                }
            }
        }
    } else {
        NSLog(@"The folder does not exist at the specified path: %@", folderPath);
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:DIR_FOR_TMP_FILE];
    [self removeAllFilesInFolder:folderPath];
}

@end
