//
//  UIImageView+Gif.h
//  MiaowShow
//
//  Created by Li on 16/6/16.
//  Copyright © 2016年 Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Gif)
// 播放GIF
- (void)playGifAnim:(NSArray *)images;
// 停止动画
- (void)stopGifAnim;
@end
