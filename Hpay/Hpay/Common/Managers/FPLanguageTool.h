//
//  FPLanguageTool.h
//  FiiiPay
//
//  Created by Singer on 2018/5/2.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FPGetStringWithKeyFromTable(key, tbl) [[FPLanguageTool sharedInstance] getStringForKey:key withTable:tbl]

@interface FPLanguageTool : NSObject

@property(nonatomic, strong) NSBundle *bundle;
@property(nonatomic, copy) NSString *language;

+ (instancetype)sharedInstance;

- (NSString *)getStringForKey:(NSString *)key withTable:(NSString *)table;

@end
