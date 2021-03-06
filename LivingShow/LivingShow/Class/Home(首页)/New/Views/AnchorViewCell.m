//
//  AnchorViewCell.m
//  LivingShow
//
//  Created by LI on 16/8/17.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "AnchorViewCell.h"

#import "User.h"
#import <UIImageView+WebCache.h>

@interface AnchorViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UIImageView *star;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@end

@implementation AnchorViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setUser:(User *)user
{
    _user = user;
    // 设置封面头像
    [_coverView sd_setImageWithURL:[NSURL URLWithString:user.photo] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
    // 是否是新主播
    self.star.hidden = !user.newStar;
    // 地址
    [self.locationBtn setTitle:user.position forState:UIControlStateNormal];
    // 主播名
    self.nickNameLabel.text = user.nickname;
}
@end
