//
//  RelateAnchor.h
//  LivingShow
//
//  Created by LI on 16/8/15.
//  Copyright © 2016年 LI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Live;

@interface RelateAnchor : UIView

/** 相关主播 */
@property (strong, nonatomic) Live *live;

+ (instancetype)relateAnchor;

@end
