//
//  IdentityAuthLV2Model.h
//  FiiiPay
//
//  Created by Singer on 2018/4/11.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IdentityAuthLV2Model : NSObject <NSCopying>

@property(nonatomic, copy) NSString *Address1;
@property(nonatomic, copy) NSString *Address2;
@property(nonatomic, copy) NSString *City;
@property(nonatomic, copy) NSString *State;
@property(nonatomic, copy) NSString *Postcode;
@property(nonatomic, copy) NSString *Country;
@property(nonatomic, copy) NSString *CountryId;
@property(nonatomic, copy) NSString *ResidentImage;

@end
