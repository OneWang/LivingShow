//
//  MyTabBarButton.m
//  MTime
//
//  Created by MS on 16-1-16.
//  Copyright (c) 2016年 MS. All rights reserved.
//

#import "MyTabBarButton.h"

#define Rate 0.5

@implementation MyTabBarButton

- (instancetype)init
{
    if (self = [super init]) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = self.frame.size.width;
    CGFloat imageH = self.frame.size.height * 0.8;
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}


- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat labelX = 0;
    CGFloat labelY = self.frame.size.height * Rate;
    CGFloat labelW = self.frame.size.width;
    CGFloat labelH = self.frame.size.height * (1 - Rate);
    
    return CGRectMake(labelX, labelY, labelW, labelH);
}

- (void)setHighlighted:(BOOL)highlighted
{

}

@end
