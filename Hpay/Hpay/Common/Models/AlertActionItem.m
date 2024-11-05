//
//  AlertActionItem.m
//  Hpay
//
//  Created by Ugur Bozkurt on 05/08/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "AlertActionItem.h"

@implementation AlertActionItem

+ (instancetype)actionWithTitle:(NSString *)title style:(AlertActionStyle)style handler:(nullable AlertActionItemHandler)handler{
    return [[AlertActionItem alloc] initWithTitle:title style:style handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title style:(AlertActionStyle)style handler:(nullable AlertActionItemHandler)handler{
    if (self = [super init]) {
        _title = title;
        _handler = handler;
        _style = style;
    }
    return self;
}

+ (instancetype)defaultDismissItem{
    return [[AlertActionItem alloc] initWithTitle:NSLocalizedString(@"dismiss", @"")
                                            style:AlertActionStyleCancel
                                          handler:NULL];
}

+ (instancetype)defaultDismissItemWithHandler:(AlertActionItemHandler)handler{
    return [[AlertActionItem alloc] initWithTitle:NSLocalizedString(@"dismiss", @"")
                                            style:AlertActionStyleCancel
                                          handler:handler];
}

+ (instancetype)defaultGotItItemWithHandler:(AlertActionItemHandler)handler{
    return [[AlertActionItem alloc] initWithTitle:NSLocalizedString(@"got_it", @"")
                                            style:AlertActionStyleCancel
                                          handler:handler];
}

+ (instancetype)defaultCancelItem{
    return [[AlertActionItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"")
                                            style:AlertActionStyleCancel
                                          handler:NULL];
}

+ (instancetype)defaultCancelItemWithHandler:(AlertActionItemHandler)handler{
    return [[AlertActionItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"")
                                            style:AlertActionStyleCancel
                                          handler:handler];
}

+ (instancetype)defaultOKItem{
    return [[AlertActionItem alloc] initWithTitle:NSLocalizedString(@"okay", @"")
                                            style:AlertActionStyleDefault
                                          handler:NULL];
}

+ (instancetype)defaultRetryItemWithHandler:(AlertActionItemHandler)handler{
    return [[AlertActionItem alloc] initWithTitle:StateViewModel.refreshButtonTitle
                                            style:AlertActionStyleCancel
                                          handler:handler];
}

+ (instancetype)defaultContinueItemWithHandler:(AlertActionItemHandler)handler{
    return [[AlertActionItem alloc] initWithTitle:NSLocalizedString(@"Continue", @"")
                                            style:AlertActionStyleDefault
                                          handler:handler];
}
@end
