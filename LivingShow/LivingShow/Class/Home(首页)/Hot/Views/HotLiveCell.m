//
//  HotLiveCell.m
//  LivingShow
//
//  Created by LI on 16/8/12.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "HotLiveCell.h"
#import "Live.h"
#import "UIImage+Extension.h"
#import <UIImageView+WebCache.h>

@interface HotLiveCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIButton    *locationBtn;
@property (weak, nonatomic) IBOutlet UILabel     *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *startView;
@property (weak, nonatomic) IBOutlet UILabel     *chaoyangLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bigPicView;

@end

@implementation HotLiveCell


- (void)setLive:(Live *)live
{
    _live = live;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:live.smallpic] placeholderImage:[UIImage imageNamed:@"placeholder_head"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        image = [UIImage  circleImage:image borderColor:[UIColor redColor] borderWidth:1];
        self.headImageView.image = image;
    }];
    
    self.nameLabel.text = live.myname;
    // 如果没有地址, 给个默认的地址
    if (!live.gps.length) {
        live.gps = @"直播秀";
    }
    [self.locationBtn setTitle:live.gps forState:UIControlStateNormal];
    [self.bigPicView sd_setImageWithURL:[NSURL URLWithString:live.bigpic] placeholderImage:[UIImage imageNamed:@"profile_user_414x414"]];
    self.startView.image  = live.starImage;
    self.startView.hidden = !live.starlevel;
    
    // 设置当前观众数量
    NSString *fullChaoyang = [NSString stringWithFormat:@"%ld人在看", (unsigned long)live.allnum];
    NSRange range = [fullChaoyang rangeOfString:[NSString stringWithFormat:@"%ld", (unsigned long)live.allnum]];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:fullChaoyang];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range: range];
    [attr addAttribute:NSForegroundColorAttributeName value:KeyColor range:range];
    self.chaoyangLabel.attributedText = attr;
}
@end
