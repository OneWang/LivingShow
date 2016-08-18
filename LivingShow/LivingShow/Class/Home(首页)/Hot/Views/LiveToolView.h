//
//  LiveToolView.h
//  LivingShow
//
//  Created by LI on 16/8/15.
//  Copyright © 2016年 LI. All rights reserved.
//  直播间底部的工具栏

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LiveToolType) {
    LiveToolTypePublicTalk,
    LiveToolTypeThumbUp,
    LiveToolTypePrivateTalk,
    LiveToolTypeGift,
    LiveToolTypeRank,
    LiveToolTypeShare,
    LiveToolTypeClose
};

typedef void(^clickToolBlock)(LiveToolType type);

@interface LiveToolView : UIView
/** 点击工具栏  */
@property(nonatomic, copy) clickToolBlock clickTool;
@end
