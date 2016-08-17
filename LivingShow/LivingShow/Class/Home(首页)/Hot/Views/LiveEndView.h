//
//  LiveEndView.h
//  LivingShow
//
//  Created by LI on 16/8/15.
//  Copyright © 2016年 LI. All rights reserved.
//  直播结束之后的 view

typedef void(^clickOtherAnchor)(void);
typedef void(^quit)(void);

#import <UIKit/UIKit.h>

@interface LiveEndView : UIView
+ (instancetype)liveEndView;
/** 查看其他主播 */
@property (nonatomic, copy) clickOtherAnchor clickOther;
/** 退出 */
@property (nonatomic, copy) quit quit;
@end
