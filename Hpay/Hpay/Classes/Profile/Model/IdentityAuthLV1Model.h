//
//  IdentityAuthLV1Model.h
//  FiiiPay
//
//  Created by Singer on 2018/4/11.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IdentityAuthLV1Model : NSObject <NSCopying>
@property(nonatomic, copy) NSString *Fullname;
@property(nonatomic, copy) NSString *FirstName;
@property(nonatomic, copy) NSString *LastName;
@property(nonatomic, assign) NSInteger IdentityDocType;


/**
 证件号码
 */
@property(nonatomic, copy) NSString *IdentityDocNo;


/**
 证件正面照
 */
@property(nonatomic, copy) NSString *FrontIdentityImage;


/**
 证件反面照
 */
@property(nonatomic, copy) NSString *BackIdentityImage;


/**
 手持证件照
 */
@property(nonatomic, copy) NSString *HandHoldWithCard;

@end
