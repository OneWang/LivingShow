//
//  LiveAnchorView.h
//  LivingShow
//
//  Created by LI on 16/8/15.
//  Copyright © 2016年 LI. All rights reserved.
//

typedef void(^clickDevice)(BOOL isSelected);

#import <UIKit/UIKit.h>

@class Live,User;

@interface LiveAnchorView : UIView

+ (instancetype)liveAnchorView;
/** 主播 */
@property(nonatomic, strong) User *user;
/** 直播 */
@property(nonatomic, strong) Live *live;
/** 点击开关  */
@property(nonatomic, copy) clickDevice isShow;

@end
