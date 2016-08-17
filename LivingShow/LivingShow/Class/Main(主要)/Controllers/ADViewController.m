//
//  ADViewController.m
//  LivingShow
//
//  Created by LI on 16/8/17.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "ADViewController.h"
#import "AAPLCrossDissolveTransitionAnimator.h"

@interface ADViewController ()<UIViewControllerTransitioningDelegate>
{
    UIImageView *_adsImageView;// 图片视图
    NSTimer *_waitRequestTimer;//
    NSTimer *_adsAccordingTimer;
    UIButton *_time_btton;
    UIButton *_jump_button;
    NSInteger _seconds;
    NSInteger _adsAccording_Integer;
    UIImageView *_LaunchImage;
}
@end

@implementation ADViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.transitioningDelegate = self;
    _LaunchImage = [[UIImageView alloc]initWithFrame:self.view.bounds];
    _LaunchImage.image = [UIImage imageNamed:@"LaunchImage"];
    [self.view addSubview:_LaunchImage];
    [self requestAds];
    _seconds = 6;
    _waitRequestTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(Waiting) userInfo:nil repeats:YES];
}
-(void)requestAds
{
    // 模拟网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addUI];
        [_waitRequestTimer invalidate];
    });
}
-(void)Waiting
{
    _seconds--;
    if (_seconds == 0) {
        [self myLog];
    }
}
/**
 *  添加广告上面的UI
 */
-(void)addUI{
    
    _adsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenW, 0.87*screenH)];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://i.l.inmobicdn.net/banners/FileData/290057e6-a662-411d-86bb-688b3c284460.jpeg"]];
        UIImage *main_image = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _adsImageView.image = main_image;
        });
    });
    [_LaunchImage addSubview:_adsImageView];
    /**
     *  显示倒计时的时间按钮
     *
     */
    _time_btton = [self addButtonWithImagename:@"miaoshu" andTitle:@"5S" andFram:CGRectMake(screenW-70, 30, 50, 30)];
    /**
     *  创建倒计时
     *
     */
    _adsAccordingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAccord) userInfo:nil repeats:YES];
    _adsAccording_Integer = 6;
}
/**
 *  广告的倒计时
 */
-(void)timerAccord
{
    _adsAccording_Integer--;
    [_time_btton setTitle:[NSString stringWithFormat:@"%zd",_adsAccording_Integer] forState:0];
    if (_adsAccording_Integer <=  0) {
        [self myLog];
    }
    /**等于2秒时显示直接接入按钮*/
    if (_adsAccording_Integer == 2) {
        _jump_button  = [self addButtonWithImagename:@"tiaoguo" andTitle:@"直接进入>" andFram:CGRectMake(screenW - 150,screenH * 0.83 - 60, 120, 45)];
        [_jump_button setTitleColor:[UIColor whiteColor] forState:0];
        _jump_button.titleLabel.font = [UIFont systemFontOfSize:15];
        [_jump_button addTarget:self action:@selector(myLog) forControlEvents:UIControlEventTouchUpInside];
    }
}
/**
 *  点击进入按钮
 */
-(void)myLog
{
    self.myBlock(YES);
    [self dismissViewControllerAnimated:YES completion:^{
        [_waitRequestTimer invalidate];
        [_adsAccordingTimer invalidate];
    }];
}
/**
 *  创建广告上面的button按钮
 *
 *  @param imageName 按钮的图片
 *  @param title     按钮的文字
 *  @param btnFram   按钮的fram
 *
 *  @return 返回按钮
 */
-(UIButton *)addButtonWithImagename:(NSString *)imageName andTitle:(NSString *)title andFram:(CGRect)btnFram{
    
    UIButton *button =[[UIButton alloc]initWithFrame:btnFram];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:0];
    [button setTitle:title forState:0];
    button.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [button setTitleColor:[UIColor grayColor]forState:UIControlStateNormal];
    [_adsImageView addSubview:button];
    return button;
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [AAPLCrossDissolveTransitionAnimator new];
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [AAPLCrossDissolveTransitionAnimator new];
}

@end
