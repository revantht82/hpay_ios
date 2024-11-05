//
//  FPLanguageTool.m
//  FiiiPay
//
//  Created by Singer on 2018/5/2.
//  Copyright © 2018 Himalaya. All rights reserved.
//
#define CNS @"zh-Hans"
#define CNHant @"zh-Hant" //繁体中文
#define CNHantHK @"zh-HK" //繁体香港
#define CNHantTW @"zh-TW" //繁体台湾
#define EN @"en"
#define LANGUAGE_SET @"langeuageset"

@interface FPLanguageTool ()

@end

@implementation FPLanguageTool

static FPLanguageTool *sharedModel;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedModel = [FPLanguageTool new];
        [sharedModel initLanguage];
    });

    return sharedModel;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initLanguage];
    }

    return self;
}

- (void)initLanguage {
    NSString *preferredLanguage = [[NSBundle mainBundle] preferredLocalizations].firstObject;
    
    if ([preferredLanguage isEqual:[NSNull null]]) {
        self.language = EN;
    } else {
        self.language = preferredLanguage;
    }
}

- (NSString *)getStringForKey:(NSString *)key withTable:(NSString *)table {
    if (self.bundle) {
        return NSLocalizedStringFromTableInBundle(key, table, self.bundle, @"");
    }

    return NSLocalizedStringFromTable(key, table, @"");
}

@end
