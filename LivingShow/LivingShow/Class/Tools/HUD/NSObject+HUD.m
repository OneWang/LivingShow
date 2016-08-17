//
//  NSObject+HUD.m
//  LivingShow
//
//  Created by Li on 16/6/29.
//  Copyright © 2016年 Li. All rights reserved.
//

#import "NSObject+HUD.h"

@implementation NSObject (HUD)
- (void)showInfo:(NSString *)info
{
    if ([self isKindOfClass:[UIViewController class]] || [self isKindOfClass:[UIView class]]) {
        [[[UIAlertView alloc] initWithTitle:@"直播秀" message:info delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
}
@end
