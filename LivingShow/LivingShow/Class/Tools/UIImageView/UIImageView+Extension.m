//
//  UIImageView+Gif.m
//  MiaowShow
//
//  Created by Li on 16/6/16.
//  Copyright © 2016年 Li. All rights reserved.
//

#import "UIImageView+Extension.h"

@implementation UIImageView (Gif)
// 播放GIF
- (void)playGifAnim:(NSArray *)images
{
    if (!images.count) {
        return;
    }
    //动画图片数组
    self.animationImages = images;
    //执行一次完整动画所需的时长
    self.animationDuration = 0.5;
    //动画重复次数, 设置成0 就是无限循环
    self.animationRepeatCount = 0;
    [self startAnimating];
}
// 停止动画
- (void)stopGifAnim
{
    if (self.isAnimating) {
        [self stopAnimating];
    }
    [self removeFromSuperview];
}
@end
