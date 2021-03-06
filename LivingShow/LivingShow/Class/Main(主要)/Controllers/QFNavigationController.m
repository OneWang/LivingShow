//
//  QFNavigationController.m
//  Live
//
//  Created by LI on 16/8/11.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "QFNavigationController.h"

#import "HomeViewController.h"
#import "LivingViewController.h"
#import "FellowViewController.h"
#import "MineViewController.h"

@interface QFNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation QFNavigationController

+ (void)initialize
{
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"navBar_bg_414x70"] forBarMetrics:UIBarMetricsDefault];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count) { // 隐藏导航栏
        viewController.hidesBottomBarWhenPushed = YES;
        
        // 自定义返回按钮
        UIButton *btn = [[UIButton alloc] init];
        [btn setImage:[UIImage imageNamed:@"back_9x16"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [btn sizeToFit];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
        // 如果自定义返回按钮后, 滑动返回可能失效, 需要添加下面的代码
        __weak typeof(viewController)Weakself = viewController;
        self.interactivePopGestureRecognizer.delegate = (id)Weakself;
    }
    //设置返回按钮
//    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navBar_bg_414x70"] style:UIBarButtonItemStyleDone target:self action:@selector(popViewControllerAnimated:)];
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    // 判断两种情况: push 和 present
    if ((self.presentedViewController || self.presentingViewController) && self.childViewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else
        [self popViewControllerAnimated:YES];
}

#pragma mark - UIGestureRecognizerDelegate
////右滑返回的处理
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    BOOL ok = YES; // 默认为支持右滑反回
    if ([self.topViewController isKindOfClass:[HomeViewController class]] ||
        [self.topViewController isKindOfClass:[LivingViewController class]] ||
        [self.topViewController isKindOfClass:[FellowViewController class]] ||
        [self.topViewController isKindOfClass:[MineViewController class]]) {
        return NO;
    }
    return ok;
}

@end
