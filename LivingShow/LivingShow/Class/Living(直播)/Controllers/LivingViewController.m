//
//  LivingViewController.m
//  Live
//
//  Created by LI on 16/8/11.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "LivingViewController.h"
#import "MainTabBarController.h"

#import "GPUImageGaussianBlurFilter.h"
#import "QFTabbar.h"

#import "StartLiveView.h"

@interface LivingViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (weak, nonatomic) IBOutlet UITextField *myTitle;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@end

@implementation LivingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置背景图片高斯模糊
    [self gaussianImage];
    
    self.navigationController.navigationBar.hidden = YES;
    
    //设置键盘TextField
    [self setupTextField];
}

#pragma mark ---- <设置键盘TextField>
- (void)setupTextField {
    
    [_myTitle becomeFirstResponder];
    
    //设置键盘颜色
    _myTitle.tintColor = [UIColor whiteColor];
    
    //设置占位文字颜色
    [_myTitle setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
}

#pragma mark ---- <设置背景图片高斯模糊>
- (void)gaussianImage {
    GPUImageGaussianBlurFilter * blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    blurFilter.blurRadiusInPixels = 2.0;
    UIImage * image = [UIImage imageNamed:@"bg_zbfx"];
    UIImage *blurredImage = [blurFilter imageByFilteringImage:image];
    
    self.backgroundView.image = blurredImage;
}

//返回主界面
- (IBAction)backMain {

//    [self dismissViewControllerAnimated:YES completion:nil];
    __weak MainTabBarController *tabBar = (MainTabBarController *)self.tabBarController;
    QFTabbar *myTabBar = nil;
    for (UIView *view in tabBar.tabBar.subviews) {
        if ([view isKindOfClass:[QFTabbar class]]) {
            myTabBar = (QFTabbar *)view;
        }
    }
    myTabBar.selectedIndex = 0;
}

//开始直播采集
- (IBAction)startLiveStream {
    
    StartLiveView *view = [[StartLiveView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:view];
    
    _backBtn.hidden = YES;
    _middleView.hidden = YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_myTitle endEditing:YES];
}

@end
