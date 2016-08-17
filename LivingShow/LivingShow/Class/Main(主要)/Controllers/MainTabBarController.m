//
//  MainTabBarController.m
//  Live
//
//  Created by LI on 16/8/10.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "MainTabBarController.h"
/** 自定义导航控制器 */
#import "QFNavigationController.h"

/** 子控制器 */
#import "HomeViewController.h"
#import "LivingViewController.h"
#import "FellowViewController.h"
#import "MineViewController.h"

#import "ADViewController.h"

/** 导入系统框架 */
#import <AVFoundation/AVFoundation.h>

@interface MainTabBarController ()<UITabBarControllerDelegate>

{
    BOOL _isClick;
    UIImageView *_imageView;
}

@end

@implementation MainTabBarController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    ADViewController *one = [[ADViewController alloc]init];
    one.myBlock = ^(BOOL isClick){
        _isClick = isClick;
        [_imageView removeFromSuperview];
        _imageView = nil;
    };
    if (_isClick == NO) {
        [self presentViewController:one animated:NO completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    
    _imageView.image = [UIImage imageNamed:@"LaunchImage"];
    [self.view addSubview:_imageView];
    [self.view bringSubviewToFront:_imageView];
    
    //设置代理
    self.delegate = self;
    
    //设置 TabBarcontroller 下面的子控制器
    [self setup];
}

#pragma 设置子控制器
- (void)setup{
    HomeViewController *home = [[HomeViewController alloc] init];
    home.title = @"首页";
    [self addChildViewController:home withImageNamed:@"home" withTitle:@"首页"];
    [self addChildViewController:[[LivingViewController alloc] init] withImageNamed:@"discover" withTitle:@"直播"];
    [self addChildViewController:[[FellowViewController alloc] init] withImageNamed:@"payticket" withTitle:@"关注"];
    [self addChildViewController:[[MineViewController alloc] init] withImageNamed:@"myinfo" withTitle:@"我的"];
}

#pragma mark 封装添加控制器方法
- (void)addChildViewController:(UIViewController *)chileViewController withImageNamed:(NSString *)imageName withTitle:(NSString *)title{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:chileViewController];
    UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_on",imageName]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image selectedImage:selImage];
    
    // 设置图片居中, 这儿需要注意top和bottom必须绝对值一样大
    chileViewController.tabBarItem.imageInsets = UIEdgeInsetsMake(10, 0, 0, 0);
    chileViewController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -5);
    
    //设置导航栏为透明的
//    if ([chileViewController isKindOfClass:[HomeViewController class]]) {
//        [nav.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//        nav.navigationBar.shadowImage = [[UIImage alloc] init];
//        nav.navigationBar.translucent = YES;
//        nav.navigationBar.hidden = YES;
//    }
    //添加到主控制器
    [self addChildViewController:nav];
}

#pragma mark UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([tabBarController.childViewControllers indexOfObject:viewController] == tabBarController.childViewControllers.count - 3) {
//        self.hidesBottomBarWhenPushed = YES;
//        //判断是否是模拟器
//        if ([[UIDevice deviceVersion] isEqualToString:@"iPhone Simulator"]) {
//            [self showInfo:@"请用真机进行测试, 此模块不支持模拟器测试"];
//            return NO;
//        }
//        
//        //判断是否有摄像头
//        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//            [self showInfo:@"您的设备没有摄像头或者相关的驱动, 不能进行直播"];
//            return NO;
//        }
//        
//        //判断是否有摄像头权限
//        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//        if (status == AVAuthorizationStatusRestricted|| status == AVAuthorizationStatusDenied) {
//            [self showInfo:@"app需要访问您的摄像头。\n请启用摄像头-设置/隐私/摄像头"];
//            return NO;
//        }
//        
//        // 开启麦克风权限
//        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
//            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
//                if (granted) {
//                    return YES;
//                }else {
//                    [self showInfo:@"app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风"];
//                    return NO;
//                }
//            }];
//        }
//        LivingViewController *living = [[LivingViewController alloc] init];
//        [self presentViewController:living animated:YES completion:nil];
//        return NO;
    }
    return YES;
}

@end
