//
//  LiveUserView.h
//  LivingShow
//
//  Created by LI on 16/8/15.
//  Copyright © 2016年 LI. All rights reserved.
//  显示用户信息的 view

typedef void(^closeBlock)(void);

#import <UIKit/UIKit.h>

@class User;

@interface LiveUserView : UIView
+ (instancetype)userView;
/** 点击关闭 */
@property (nonatomic, copy) closeBlock close;
/** 用户信息 */
@property (nonatomic, strong) User *user;
@end
