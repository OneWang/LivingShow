//
//  QFTabbar.h
//  Live
//
//  Created by LI on 16/8/11.
//  Copyright © 2016年 LI. All rights reserved.
//

#import <UIKit/UIKit.h>


@class QFTabbar;

@protocol tabBarDelegate <NSObject>

@optional
- (void)tabBar:(QFTabbar *) tabBar didSelectButtonFrom:(int)from to:(int)to;

@end

@interface QFTabbar : UIView

@property (weak,nonatomic) id<tabBarDelegate> delegate;

/** 按钮索引 */
@property (assign, nonatomic) NSInteger selectedIndex;

/**
 *  对外部留下一个接口用来创建一个 button
 *
 *  @param name    normal 状态下的图片名字
 *  @param selName 选中之后的图片名字
 */
- (void)addTabBarButtonWithImageName:(NSString *)name title:(NSString *)title;

@end
