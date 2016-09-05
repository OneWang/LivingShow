//
//  QFTabbar.m
//  Live
//
//  Created by LI on 16/8/11.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "QFTabbar.h"
#import "MyTabBarButton.h"

@interface QFTabbar ()

/** 选中的按钮 */
@property (nonatomic,strong) UIButton * selectedButton;

@end

@implementation QFTabbar

- (void)addTabBarButtonWithImageName:(NSString *)imageName title:(NSString *)title{
    MyTabBarButton * button = [[MyTabBarButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    UIImage *selImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_on",imageName]];
    [button setImage:selImage forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSInteger count = self.subviews.count;
    for (int i = 0; i < count; i++) {
        MyTabBarButton * button = self.subviews[i];
        button.tag = i;
        CGFloat buttonY = 0;
        CGFloat buttonW = self.frame.size.width / count;
        CGFloat buttonX = i * buttonW;
        CGFloat buttonH = self.frame.size.height;
        
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        if (0 == i) {
            [self buttonClick:button];
        }
    }
}

/**
 *  按钮的点击事件
 */
- (void)buttonClick:(UIButton *)btn{
    
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectButtonFrom:to:)]) {
        [self.delegate tabBar:self didSelectButtonFrom:(int)self.selectedButton.tag to:(int)btn.tag];
    }
    
    self.selectedButton.selected = NO;
    
    btn.selected = YES;
    
    self.selectedButton = btn;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    UIButton * button = self.subviews[selectedIndex];
    [self buttonClick:button];
}

@end
