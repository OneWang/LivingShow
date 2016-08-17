//
//  LoginViewController.m
//  Live
//
//  Created by LI on 16/8/10.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "LoginViewController.h"
/** 根控制器 */
#import "MainTabBarController.h"

/** 第三方登录 */
#import "ThirdLoginView.h"

@interface LoginViewController ()

/** player */
@property (nonatomic, strong) IJKFFMoviePlayerController *player;
/** 第三方登录 */
@property (nonatomic, weak) ThirdLoginView *thirdView;
/** 快速通道 */
@property (nonatomic, weak) UIButton *quickBtn;
/** 封面图片 */
@property (nonatomic, weak) UIImageView *coverView;

@end

@implementation LoginViewController

#pragma mark - 懒加载
- (IJKFFMoviePlayerController *)player
{
    if (!_player) {
        //随机播放一组视频
        NSString *path = arc4random_uniform(10) % 2 ? @"login_video" : @"loginmovie";
        //创建播放器
        IJKFFMoviePlayerController *player = [[IJKFFMoviePlayerController alloc] initWithContentURLString:[[NSBundle mainBundle] pathForResource:path ofType:@"mp4"] withOptions:[IJKFFOptions optionsByDefault]];
        //设置 player 的 frame
        player.view.frame = self.view.bounds;
        //设置填充模式
        player.scalingMode = IJKMPMovieScalingModeAspectFill;
        //添加到视图
        [self.view addSubview:player.view];
        //设置自动播放
        player.shouldAutoplay = NO;
        //准备播放
        [player prepareToPlay];
        
        _player = player;
    }
    return _player;
}
//设置启动页面
- (UIImageView *)coverView
{
    if (!_coverView) {
        UIImageView *cover = [[UIImageView alloc] initWithFrame:self.view.bounds];
        cover.image = [UIImage imageNamed:@"LaunchImage"];
        [self.player.view addSubview:cover];
        _coverView = cover;
    }
    return _coverView;
}

//WARN:设置第三方登录
- (ThirdLoginView *)thirdView
{
    if (!_thirdView) {
        ThirdLoginView *thirdView = [[ThirdLoginView alloc] initWithFrame:CGRectMake(0, 0, 400, 200)];
        thirdView.loginBlock = ^(LoginType type){
            //登录成功
            [self loginSuccess];
            if (type == LoginTypeSina) {
                NSLog(@"点击了新浪登录按钮");
            } else if (type == LoginTypeQQ){
                NSLog(@"点击了 qq 登录按钮");
            }else{
                NSLog(@"点击了微信登录按钮");
            }
        };
        thirdView.hidden = YES;
        [self.view addSubview:thirdView];
        _thirdView = thirdView;
    }
    return _thirdView;
}
//WARN:设置快速登录按钮
- (UIButton *)quickBtn
{
    if (!_quickBtn) {
        UIButton *btn = [[UIButton alloc] init];
        btn.backgroundColor = [UIColor clearColor];
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor yellowColor].CGColor;
        [btn setTitle:@"您的快速通道" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor cyanColor]  forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(loginSuccess) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        btn.hidden = YES;
        _quickBtn = btn;
    }
    return _quickBtn;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置播放监听和按钮布局
    [self setUp];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //停止播放
    [self.player shutdown];
    //移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //清空播放器
    [self.player.view removeFromSuperview];
    self.player = nil;
    
}

- (void)setUp{
    [self addObserverIsplay];
    
    self.coverView.hidden = NO;
    
    [self.quickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@40);
        make.right.equalTo(@-40);
        make.bottom.equalTo(@-60);
        make.height.equalTo(@40);
    }];
    
    [self.thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@60);
        make.bottom.equalTo(self.quickBtn.mas_top).offset(-40);
    }];

}

#pragma mark - private method

- (void)addObserverIsplay
{
    // 监听视频是否播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinish) name:IJKMPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateDidChange) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:nil];
}

- (void)didFinish
{
    // 播放完之后, 继续重播
    [self.player play];
}

- (void)stateDidChange
{
    if ((self.player.loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        if (!self.player.isPlaying) {
            self.coverView.frame = self.view.bounds;
            [self.view insertSubview:self.coverView atIndex:0];
            [self.player play];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.thirdView.hidden = NO;
                self.quickBtn.hidden = NO;
            });
        }
    }
}

// 登录成功
- (void)loginSuccess
{
    [self showHint:@"登录成功"];
    //延迟1s 停止播放移除播放器
    //注意:再次发送登录参数到服务器
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentViewController:[[MainTabBarController alloc] init] animated:NO completion:^{
            [self.player stop];
            [self.player.view removeFromSuperview];
            self.player = nil;
        }];
    });
}

- (void)dealloc
{
    NSLog(@"登录页面:%s",__func__);
}

@end
