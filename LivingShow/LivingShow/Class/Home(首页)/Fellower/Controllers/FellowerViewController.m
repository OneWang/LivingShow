//
//  FellowerViewController.m
//  LivingShow
//
//  Created by LI on 16/8/11.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "FellowerViewController.h"
#import "DisplayViewHeader.h"
#import "RequestCover.h"

@interface FellowerViewController ()

@property (nonatomic, weak) RequestCover *cover;

@property (weak, nonatomic) IBOutlet UIButton *toSeeBtn;

@end

@implementation FellowerViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.toSeeBtn.layer.borderWidth = 1;
    self.toSeeBtn.layer.borderColor = KeyColor.CGColor;
    self.toSeeBtn.layer.cornerRadius = self.toSeeBtn.height * 0.5;
    [self.toSeeBtn.layer masksToBounds];
    [self.toSeeBtn setTitleColor:KeyColor forState:UIControlStateNormal];
    
    // 只需要监听自己发出的，不需要监听所有对象发出的通知，否则会导致一个控制器发出，所有控制器都能监听,造成所有控制器请求数据
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:DisplayViewClickOrScrollDidFinshNote object:self];
    
//    RequestCover *cover = [RequestCover requestCover];
    
//    [self.view addSubview:cover];
    
//    _cover = cover;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
//    self.cover.frame = self.view.bounds;
}

- (IBAction)toSeeWorld {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyToseeBigWorld object:nil];
}

// 加载数据
- (void)loadData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSLog(@"%@--请求数据成功",self.title);
        
        [self.cover removeFromSuperview];
        
    });
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
