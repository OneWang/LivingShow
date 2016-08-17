//
//  HomeViewController.m
//  LivingShow
//
//  Created by LI on 16/8/11.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "HomeViewController.h"

/** 子控制器 */
#import "HotViewController.h"
#import "NewViewController.h"
#import "FellowerViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    CGFloat y = 0;
    // 设置搜索框
//    CGFloat searchH = 44;
//    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, y, screenW, searchH)];
//    [self.view addSubview:searchBar];
    
    // 添加所有子控制器
    [self setUpAllViewController];
    
     // 设置整体内容尺寸（包含标题滚动视图和底部内容滚动视图）
    [self setUpContentViewFrame:^(UIView *contentView) {
        CGFloat contentX = 0;
//        CGFloat contentY = CGRectGetMaxY(searchBar.frame);
        CGFloat contentY = 64;
        CGFloat contentH = screenH - contentY;
        contentView.frame = CGRectMake(contentX, contentY, screenW, contentH);
        contentView.backgroundColor = [UIColor lightGrayColor];
        contentView.userInteractionEnabled = YES;
    }];
    
    /****** 标题渐变 ******/
    // 推荐方式(设置标题颜色渐变) // 默认RGB样式
    [self setUpTitleGradient:^(YZTitleColorGradientStyle *titleColorGradientStyle, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor) {
//        *titleColorGradientStyle = YZTitleColorGradientStyleFill;
        *norColor = [UIColor blackColor];
        *selColor = [UIColor orangeColor];
    }];
    
    /****** 设置遮盖 ******/
    // *推荐方式(设置遮盖)
    [self setUpCoverEffect:^(UIColor **coverColor, CGFloat *coverCornerRadius) {
        
        // 设置蒙版颜色
        *coverColor = [UIColor cyanColor];
        
        // 设置蒙版圆角半径
        *coverCornerRadius = 3;
    }];
}

// 添加所有子控制器
- (void)setUpAllViewController
{
    HotViewController *hot = [[HotViewController alloc] init];
    [self addChildViewController:hot];
    hot.title = @"最热";
    
    NewViewController *new = [[NewViewController alloc] init];
    [self addChildViewController:new];
    new.title = @"最新";
    
    FellowerViewController *fellower = [[FellowerViewController alloc] init];
    [self addChildViewController:fellower];
    fellower.title = @"关注";
    
}


@end
