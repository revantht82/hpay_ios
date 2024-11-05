//
//  FetchPhoneCodeViewModel.h
//  Hpay
//
//  Created by Olgu Sirman on 18/01/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPCountryList.h"
#import "FetchPhoneCodeProcessedDataModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^FetchPhoneCodeViewModelBlock)(FetchPhoneCodeProcessedDataModel *model);

@interface FetchPhoneCodeViewModel : NSObject

@property(nonatomic, strong) FetchPhoneCodeViewModelBlock _Nullable didProcessDataSource;

- (void)processDataSourceWith:(FPCountryList *)countryList;

@end

NS_ASSUME_NONNULL_END
