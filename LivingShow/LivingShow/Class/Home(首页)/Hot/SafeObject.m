//
//  SafeObject.m
//  LivingShow
//
//  Created by LI on 16/8/15.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "SafeObject.h"

@interface SafeObject ()

{
    __weak id _object;
    SEL _sel;
}

@end

@implementation SafeObject

- (instancetype)initWithObject:(id)object
{
    if (self = [super init]) {
        _object = object;
        _sel = nil;
    }
    return self;
}

- (instancetype)initWithObject:(id)object withSelector:(SEL)selector
{
    if(self = [super init])
    {
        _object = object;
        _sel = selector;
    }
    return self;
}

- (void)execute
{
    if (_object && _sel && [_object respondsToSelector:_sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_object performSelector:_sel withObject:nil];
#pragma clang diagnostic pop
    }
}
@end
