//
//  FPBaseModel.m
//  GiiiPlus
//
//  Created by apple on 2017/9/8.
//
//

#import "FPBaseModel.h"

@implementation FPBaseModel
+ (void)load {
    [NSObject mj_setupReplacedKeyFromPropertyName:^NSDictionary * {
        return @{
                @"ID": @"id"
        };
    }];
}
@end
