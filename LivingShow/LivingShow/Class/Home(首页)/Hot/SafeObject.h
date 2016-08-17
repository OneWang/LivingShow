//
//  SafeObject.h
//  LivingShow
//
//  Created by LI on 16/8/15.
//  Copyright © 2016年 LI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SafeObject : NSObject
- (instancetype)initWithObject:(id)object;
- (instancetype)initWithObject:(id)object withSelector:(SEL)selector;
- (void)execute;
@end
