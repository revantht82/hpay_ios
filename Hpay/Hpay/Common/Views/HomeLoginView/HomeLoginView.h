//
//  HomeLoginView.h
//  Hpay
//
//  Created by Ugur Bozkurt on 21/07/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HomeLoginViewDelegate <NSObject>
- (void)didLoginTap;
@end


@interface HomeLoginView : UIView
@property(nonatomic, weak) id <HomeLoginViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
