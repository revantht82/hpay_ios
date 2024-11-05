//
//  FetchPhoneCodeViewModel.m
//  Hpay
//
//  Created by Olgu Sirman on 18/01/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "FetchPhoneCodeViewModel.h"
#import "FPCountryList.h"
#import "FetchPhoneCodeProcessedDataModel.h"

@implementation FetchPhoneCodeViewModel

- (void)processDataSourceWith:(FPCountryList *)countryList {
    
    NSMutableArray *dataArray = [NSMutableArray array];
    
    NSArray<FPCountry *>* sortedCountries = [countryList.List sortedArrayUsingComparator:^NSComparisonResult(FPCountry * obj1, FPCountry * obj2) {
        return [[self latinNameFromCountry:obj1 language:countryList.Language] compare:[self latinNameFromCountry:obj2 language:countryList.Language]];
    }];
    
    NSMutableOrderedSet<NSString*> *firstLetterSet = [[NSMutableOrderedSet alloc] init];
    
    for (FPCountry *country in sortedCountries) {
        NSString *name = [self latinNameFromCountry:country language:countryList.Language];
        NSString *firstLetter = [name substringToIndex:1];
        [firstLetterSet addObject:firstLetter.uppercaseString];
    }
    
    [firstLetterSet enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSPredicate *predicate = [self namePredicateForFirstLetter:obj language:countryList.Language];
        NSDictionary *dict = @{obj: [sortedCountries filteredArrayUsingPredicate:predicate]};
        [dataArray addObject:dict];
    }];
    
    NSArray *indexArray = [[firstLetterSet array] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    FetchPhoneCodeProcessedDataModel *model = [[FetchPhoneCodeProcessedDataModel alloc] init];
    [model setDataArray:dataArray.copy];
    [model setIndexArray:indexArray.copy];
    self.didProcessDataSource(model);
}

- (NSString *)latinNameFromCountry:(FPCountry*)country language:(NSString *)language{
    return [language hasPrefix:@"zh-"] ? country.PinYin: country.Name;
}

- (NSPredicate *)namePredicateForFirstLetter:(NSString*)firstLetter language:(NSString *)language{
    if ([language hasPrefix:@"zh-"]){
        return [NSPredicate predicateWithFormat:@"PinYin beginswith[c] %@", firstLetter];
    }else{
        return [NSPredicate predicateWithFormat:@"Name beginswith[c] %@", firstLetter];
    }
}

@end
