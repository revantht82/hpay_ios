//
//  WebViewController.h
//  Hpay
//
//  Created by Alexander Alekseev on 04/07/2023.
//  Copyright © 2023 Himalaya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebViewController : UIViewController
@property(nonatomic) NSString *html;
@property(nonatomic) NSString *file;
@property(nonatomic) NSString *filename2save;
@end

NS_ASSUME_NONNULL_END
