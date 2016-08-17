//
//  LivingCell.h
//  LivingShow
//
//  Created by LI on 16/8/15.
//  Copyright © 2016年 LI. All rights reserved.
//  直播的 cell

typedef void(^clickRelateLive)(void);

#import <UIKit/UIKit.h>

@class Live;
@interface LivingCell : UICollectionViewCell
/** 直播 */
@property (nonatomic, strong) Live *live;
/** 相关的直播或者主播 */
@property (nonatomic, strong) Live *relateLive;
/** 父控制器用于显示加载动画 */
@property (nonatomic, weak) UIViewController *parentVc;
/** 点击关联主播 */
@property (nonatomic, copy) clickRelateLive clickLive;
@end
