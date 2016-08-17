//
//  ThirdLoginView.m
//  Live
//
//  Created by LI on 16/8/10.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "ThirdLoginView.h"

@implementation ThirdLoginView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

#pragma mark 设置图片位置
- (void)setup
{
    UIImageView *sina = [self creatImageView:@"wbLoginicon_60x60" tag:LoginTypeSina];
    UIImageView *qq = [self creatImageView:@"qqloginicon_60x60" tag:LoginTypeQQ];
    UIImageView *wechat = [self creatImageView:@"wxloginicon_60x60" tag:LoginTypeWechat];
    
    [self addSubview:sina];
    [self addSubview:qq];
    [self addSubview:wechat];
    
    [sina mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.equalTo(@60);
    }];
    
    [qq mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sina);
        make.right.equalTo(sina.mas_left).offset(-20);
        make.size.equalTo(sina);
    }];
    
    [wechat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sina);
        make.left.equalTo(sina.mas_right).offset(20);
        make.size.equalTo(sina);
    }];
}

#pragma mark 创建图片通过 tag 并添加手势
- (UIImageView *)creatImageView:(NSString *)imageName tag:(NSUInteger)tag
{
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.image = [UIImage imageNamed:imageName];
    imageV.tag = tag;
    imageV.userInteractionEnabled = YES;
    [imageV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)]];
    return imageV;
}

//WARN:图片的点击事件
- (void)click:(UITapGestureRecognizer *)tapRestureRecognizer
{
    if (self.loginBlock) {
        self.loginBlock(tapRestureRecognizer.view.tag);
    }
}

@end
