//
//  WithdrawAddress.h
//  FiiiPay
//
//  Created by Singer on 2018/4/21.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WithdrawAddress : NSObject

@property(nonatomic, assign) NSInteger Id;

@property(nonatomic, copy) NSString *Address;

/**
 别名
 */
@property(nonatomic, copy) NSString *Alias;

@property(nonatomic, copy) NSString *Tag;

@end
