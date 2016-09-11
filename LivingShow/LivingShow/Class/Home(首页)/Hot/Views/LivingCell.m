//
//  LivingCell.m
//  LivingShow
//
//  Created by LI on 16/8/15.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "LivingCell.h"

/**  */
#import "SafeObject.h"
#import <SDWebImageDownloader.h>
#import "UIImage+Extension.h"

/** 直播的模型 */
#import "Live.h"
/** 用户模型 */
#import "User.h"

/** 自定义视图 */
#import "RelateAnchor.h"
#import "LiveAnchorView.h"
#import "LiveEndView.h"
#import "LiveUserView.h"
#import "LiveToolView.h"
#import "HeartFlyView.h"

/** 弹幕渲染器 */
#import <BarrageRenderer.h>



@interface LivingCell ()
{
    BarrageRenderer *_renderer;
    NSTimer * _timer;
}

/** 直播播放器 */
@property (strong, nonatomic)  IJKFFMoviePlayerController *moviePlayer;
/** 同一个工会的主播/相关主播 */
@property(nonatomic, weak) UIImageView *otherLiveView;
/** 直播开始前的占位图片 */
@property(nonatomic, weak) UIImageView *placeHolderView;
/** 粒子动画 */
@property(nonatomic, weak) CAEmitterLayer *emitterLayer;
/** 相关主播视图 */
@property (weak, nonatomic) RelateAnchor *relateAnchor;
/** 顶部主播相关视图 */
@property(nonatomic, weak) LiveAnchorView *anchorView;
/** 底部的工具栏 */
@property(nonatomic, weak) LiveToolView *toolView;
/** 直播结束的界面 */
@property (nonatomic, weak) LiveEndView *endView;

@end

@implementation LivingCell

#pragma mark  懒加载
- (UIImageView *)placeHolderView
{
    if (!_placeHolderView) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        imageView.image = [UIImage imageNamed:@"profile_user_414x414"];
        [self.contentView addSubview:imageView];
        _placeHolderView = imageView;
        [self.parentVc showGifLoding:nil inView:self.placeHolderView];
        //强制布局
        [_placeHolderView setNeedsLayout];
    }
    return _placeHolderView;
}

- (UIImageView *)otherLiveView
{
    if (!_otherLiveView) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"private_icon_70x70"]];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOtherLive)]];
        [self.moviePlayer.view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.relateAnchor);
            make.bottom.equalTo(self.relateAnchor.mas_top).offset(-40);
        }];
        
        _otherLiveView = imageView;
    }
    return _otherLiveView;
}

- (void)clickOtherLive{
    NSLog(@"相关主播");
}

- (LiveAnchorView *)anchorView
{
    if (!_anchorView) {
        LiveAnchorView *anchorView = [LiveAnchorView liveAnchorView];
        anchorView.isShow = ^(BOOL isSelected) {
            if (_moviePlayer) {
                _moviePlayer.shouldShowHudView = !isSelected;
            }
        };
        [self.contentView insertSubview:anchorView aboveSubview:self.placeHolderView];
        [anchorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.height.equalTo(@100);
            make.top.equalTo(@20);
        }];
        _anchorView = anchorView;
    }
    return _anchorView;
}

bool _isSelected = NO;
- (LiveToolView *)toolView
{
    if (!_toolView) {
        LiveToolView *toolView = [[LiveToolView alloc] init];
        toolView.clickTool = ^(LiveToolType type) {
            switch (type) {
                case LiveToolTypePublicTalk:
                    _isSelected = !_isSelected;
                    _isSelected ? [_renderer start] : [_renderer stop];
                    break;
                case LiveToolTypeThumbUp:
                    [self animation];
                    break;
                case LiveToolTypePrivateTalk:
                    
                    break;
                case LiveToolTypeGift:
                    
                    break;
                case LiveToolTypeRank:
                    
                    break;
                case LiveToolTypeShare:
                    
                    break;
                case LiveToolTypeClose:
                    [self quit];
                    break;
                default:
                    break;
            }
        };
        [self.contentView insertSubview:toolView aboveSubview:self.placeHolderView];
        [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.bottom.equalTo(@-10);
            make.height.equalTo(@40);
        }];
        _toolView = toolView;
    }
    return _toolView;
}

- (void)animation{
    int _heartSize = 36;
    
    HeartFlyView *heart = [[HeartFlyView alloc]initWithFrame:CGRectMake(0, 0, _heartSize, _heartSize)];
    [self.contentView addSubview:heart];
    CGPoint fountainSource = CGPointMake(_heartSize + _heartSize/2.0, self.contentView.bounds.size.height - _heartSize/2.0 - 10);
    heart.center = fountainSource;
    [heart animateInView:self.contentView];
    
    // button点击动画
    CAKeyframeAnimation *btnAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    btnAnimation.values = @[@(1.0),@(0.7),@(0.5),@(0.3),@(0.5),@(0.7),@(1.0), @(1.2), @(1.4), @(1.2), @(1.0)];
    btnAnimation.keyTimes = @[@(0.0),@(0.1),@(0.2),@(0.3),@(0.4),@(0.5),@(0.6),@(0.7),@(0.8),@(0.9),@(1.0)];
    btnAnimation.calculationMode = kCAAnimationLinear;
    btnAnimation.duration = 0.3;
    UIImageView *image = (UIImageView *)[self.toolView viewWithTag:1];
    [image.layer addAnimation:btnAnimation forKey:@"SHOW"];
}

- (void)quit
{
    if (_relateAnchor) {
        [_relateAnchor removeFromSuperview];
        _relateAnchor = nil;
    }
    
    if (_moviePlayer) {
        [self.moviePlayer shutdown];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self.moviePlayer.view removeFromSuperview];
        self.moviePlayer = nil;
    }
    [_renderer stop];
    [_renderer.view removeFromSuperview];
    _renderer = nil;
    [self.parentVc dismissViewControllerAnimated:YES completion:nil];
}

- (CAEmitterLayer *)emitterLayer
{
    if (!_emitterLayer) {
        CAEmitterLayer *emitter = [CAEmitterLayer layer];
        
        // 发射器在xy平面的中心位置
        emitter.emitterPosition = CGPointMake(self.moviePlayer.view.frame.size.width-50,self.moviePlayer.view.frame.size.height-50);
        // 发射器的尺寸大小
        emitter.emitterSize = CGSizeMake(20, 20);
        // 渲染模式
        emitter.renderMode = kCAEmitterLayerUnordered;
        // 开启三维效果
//        _emitter.preservesDepth = YES;
        NSMutableArray *array = [NSMutableArray array];
        // 创建粒子
        for (int i = 0; i<10; i++) {
            // 发射单元
            CAEmitterCell *stepCell = [CAEmitterCell emitterCell];
            // 粒子的创建速率，默认为1/s
            stepCell.birthRate = 1;
            // 粒子存活时间
            stepCell.lifetime = arc4random_uniform(4) + 1;
            // 粒子的生存时间容差
            stepCell.lifetimeRange = 1.5;
            // 颜色
            // fire.color=[[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1]CGColor];
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"good%d_30x30", i]];
            // 粒子显示的内容
            stepCell.contents = (id)[image CGImage];
            // 粒子的名字
//            [fire setName:@"step%d", i];
            // 粒子的运动速度
            stepCell.velocity = arc4random_uniform(100) + 100;
            // 粒子速度的容差
            stepCell.velocityRange = 90;
            // 粒子在xy平面的发射角度
            stepCell.emissionLongitude = M_PI+M_PI_2;;
            // 粒子发射角度的容差
            stepCell.emissionRange = M_PI_2/6;
            // 缩放比例
            stepCell.scale = 0.4;
            [array addObject:stepCell];
        }
        emitter.emitterCells = array;
        [self.moviePlayer.view.layer insertSublayer:emitter below:self.relateAnchor.layer];
        
        _emitterLayer = emitter;
    }
    return _emitterLayer;
}

- (RelateAnchor *)relateAnchor
{
    if (!_relateAnchor) {
        RelateAnchor *anchor = [RelateAnchor relateAnchor];
        [self.moviePlayer.view addSubview:anchor];
        [anchor addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickRelateAnchor)]];
        [anchor mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-30);
            make.centerY.equalTo(self.moviePlayer.view);
            make.width.height.equalTo(@98);
        }];
        _relateAnchor = anchor;
    }
    return _relateAnchor;
}

- (LiveEndView *)endView
{
    if (!_endView) {
        LiveEndView *endView = [LiveEndView liveEndView];
        [self.contentView addSubview:endView];
        [endView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        endView.clickOther = ^{
            [self quit];
        };
        endView.quit = ^{
            [self clickRelateAnchor];
        };
        _endView = endView;
    }
    return _endView;
}

#pragma mark - private method

- (void)plarFLV:(NSString *)flv placeHolderUrl:(NSString *)placeHolderUrl
{
    if (_moviePlayer) {
        if (_moviePlayer) {
            [self.contentView insertSubview:self.placeHolderView aboveSubview:_moviePlayer.view];
        }
        if (_relateAnchor) {
            [_relateAnchor removeFromSuperview];
            _relateAnchor = nil;
        }
        [_moviePlayer shutdown];
        [_moviePlayer.view removeFromSuperview];
        _moviePlayer = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
    // 如果切换主播, 取消之前的动画
    if (_emitterLayer) {
        [_emitterLayer removeFromSuperlayer];
        _emitterLayer = nil;
    }
    
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:placeHolderUrl] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.parentVc showGifLoding:nil inView:self.placeHolderView];
            self.placeHolderView.image = [UIImage blurImage:image blur:0.8];
        });
    }];
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    [options setPlayerOptionIntValue:1  forKey:@"videotoolbox"];
    
    // 帧速率(fps) （可以改，确认非标准桢率会导致音画不同步，所以只能设定为15或者29.97）
//    [options setPlayerOptionIntValue:29.97 forKey:@"r"];
    
    [options setOptionIntValue:29.97 forKey:@"r" ofCategory:kIJKFFOptionCategoryPlayer];
    [options setOptionIntValue:60 forKey:@"max-fps" ofCategory:kIJKFFOptionCategoryPlayer];
    [options setOptionIntValue:IJK_AVDISCARD_DEFAULT forKey:@"skip_frame" ofCategory:kIJKFFOptionCategoryCodec];
    
    [options setOptionIntValue:IJK_AVDISCARD_DEFAULT forKey:@"skip_loop_filter" ofCategory:kIJKFFOptionCategoryCodec];
    
    [options setOptionIntValue:1 forKey:@"videotoolbox" ofCategory:kIJKFFOptionCategoryPlayer];
    
    // -vol——设置音量大小，256为标准音量。（要设置成两倍音量时则输入512，依此类推
    [options setPlayerOptionIntValue:512 forKey:@"vol"];
    
    
    IJKFFMoviePlayerController *moviePlayer = [[IJKFFMoviePlayerController alloc] initWithContentURLString:flv withOptions:options];
    moviePlayer.view.frame = self.contentView.bounds;
    // 填充fill
    moviePlayer.scalingMode = IJKMPMovieScalingModeAspectFill;
    // 设置自动播放(必须设置为NO, 防止自动播放, 才能更好的控制直播的状态)
    moviePlayer.shouldAutoplay = NO;
    // 默认不显示
    moviePlayer.shouldShowHudView = NO;
    
    [self.contentView insertSubview:moviePlayer.view atIndex:0];
    
    [moviePlayer prepareToPlay];
    
    self.moviePlayer = moviePlayer;
    
    // 设置监听
    [self initObserver];
    
    // 显示工会其他主播和类似主播
    [moviePlayer.view bringSubviewToFront:self.otherLiveView];
    
    // 开始来访动画
    [self.emitterLayer setHidden:NO];
}


- (void)initObserver
{
    // 监听视频是否播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinish) name:IJKMPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateDidChange) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:self.moviePlayer];
}

- (void)clickRelateAnchor
{
    if (self.clickLive) {
        self.clickLive();
    }
}

#pragma mark - notify method

- (void)stateDidChange
{
    if ((self.moviePlayer.loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        if (!self.moviePlayer.isPlaying) {
            [self.moviePlayer play];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (_placeHolderView) {
                    [_placeHolderView removeFromSuperview];
                    _placeHolderView = nil;
                    [self.moviePlayer.view addSubview:_renderer.view];
                }
                [self.parentVc hideGufLoding];
            });
        }else{
            // 如果是网络状态不好, 断开后恢复, 也需要去掉加载
            if (self.parentVc.gifView.isAnimating) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.parentVc hideGufLoding];
                });
            }
        }
    }else if (self.moviePlayer.loadState & IJKMPMovieLoadStateStalled){ // 网速不佳, 自动暂停状态
        [self.parentVc showGifLoding:nil inView:self.moviePlayer.view];
    }
}

- (void)didFinish
{
    NSLog(@"加载状态...%ld %ld %s", self.moviePlayer.loadState, self.moviePlayer.playbackState, __func__);
    // 因为网速或者其他原因导致直播stop了, 也要显示GIF
    if (self.moviePlayer.loadState & IJKMPMovieLoadStateStalled && !self.parentVc.gifView) {
        [self.parentVc showGifLoding:nil inView:self.moviePlayer.view];
        return;
    }
    //    方法：
    //      1、重新获取直播地址，服务端控制是否有地址返回。
    //      2、用户http请求该地址，若请求成功表示直播未结束，否则结束
    __weak typeof(self)weakSelf = self;
    [[NetWorkRequest sharedNetWorkRequest] get:self.live.flv params:nil success:^(id object) {
        NSLog(@"请求成功%@, 等待继续播放", object);
    } failure:^(NSError *error) {
        NSLog(@"请求失败, 加载失败界面, 关闭播放器%@", error);
        [weakSelf.moviePlayer shutdown];
        [weakSelf.moviePlayer.view removeFromSuperview];
        weakSelf.moviePlayer = nil;
        weakSelf.endView.hidden = NO;
    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.toolView.hidden = NO;
        
        _renderer = [[BarrageRenderer alloc] init];
        _renderer.canvasMargin = UIEdgeInsetsMake(screenH * 0.3, 10, 10, 10);
        [self.contentView addSubview:_renderer.view];
        
        SafeObject * safeObj = [[SafeObject alloc]initWithObject:self withSelector:@selector(autoSendBarrage)];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:safeObj selector:@selector(execute) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)autoSendBarrage
{
    NSInteger spriteNumber = [_renderer spritesNumberWithName:nil];
    if (spriteNumber <= 50) { // 限制屏幕上的弹幕量
        [_renderer receive:[self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionR2L]];
    }
}

#pragma mark - 弹幕描述符生产方法

long _index = 0;
/// 生成精灵描述 - 过场文字弹幕
- (BarrageDescriptor *)walkTextSpriteDescriptorWithDirection:(NSInteger)direction
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"text"] = self.danMuText[arc4random_uniform((uint32_t)self.danMuText.count)];
    descriptor.params[@"textColor"] = Color(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256));
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(direction);
    descriptor.params[@"clickAction"] = ^{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"弹幕被点击" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
    };
    return descriptor;
}

- (NSArray *)danMuText
{
    return [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"danmu.plist" ofType:nil]];
}

- (void)setLive:(Live *)live
{
    _live = live;
    self.anchorView.live = live;
    [self plarFLV:live.flv placeHolderUrl:live.bigpic];
}

- (void)setRelateLive:(Live *)relateLive
{
    _relateLive = relateLive;
    // 设置相关主播
    if (relateLive) {
        self.relateAnchor.live = relateLive;
    }else{
        self.relateAnchor.hidden = YES;
    }
}
@end
