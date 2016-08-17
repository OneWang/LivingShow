//
//  RequestCover.m
//  LivingShow
//
//  Created by LI on 16/8/11.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "RequestCover.h"

@interface RequestCover ()

@property (weak, nonatomic) IBOutlet UIImageView *animView;

@end

@implementation RequestCover

+ (instancetype)requestCover
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    //    NSMutableArray *images = [NSMutableArray array];
    //    for (int i = 1; i <= 10; i++) {
    //        NSString *imageName = [NSString stringWithFormat:@"%d",i];
    //        UIImage *image = [UIImage imageNamed:imageName];
    //        [images addObject:image];
    //    }
    //
    //    _animView.animationRepeatCount = MAXFLOAT;
    //    _animView.animationImages = images;
    //    _animView.animationDuration = 1;
    //    [_animView startAnimating];
}

@end
