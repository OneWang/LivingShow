//
//  LiveAnchorView.m
//  LivingShow
//
//  Created by LI on 16/8/15.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "LiveAnchorView.h"

#import "Live.h"
#import "User.h"
#import "UIImage+Extension.h"
#import <UIImageView+WebCache.h>

@interface LiveAnchorView ()

@property (weak, nonatomic) IBOutlet UIView *anchorView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleLabel;
@property (weak, nonatomic) IBOutlet UIButton *careBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *peoplesScrollView;
@property (weak, nonatomic) IBOutlet UIButton *giftView;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSArray *LookUsers;

@end

@implementation LiveAnchorView

- (NSArray *)LookUsers
{
    if (!_LookUsers) {
        NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"user.plist" ofType:nil]];
        _LookUsers = [User mj_objectArrayWithKeyValuesArray:array];
    }
    return _LookUsers;
}

+ (instancetype)liveAnchorView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self maskViewToBounds:self.anchorView];
    [self maskViewToBounds:self.headImageView];
    [self maskViewToBounds:self.giftView];
    [self maskViewToBounds:self.careBtn];
    
    self.headImageView.layer.borderWidth = 1;
    self.headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [self.careBtn setBackgroundImage:[UIImage imageWithColor:[UIColor blueColor] size:self.careBtn.size] forState:UIControlStateNormal];
    [self.careBtn setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor] size:self.careBtn.size] forState:UIControlStateSelected];
    [self setupChangeyang];
    
    // 默认是关闭的
    [self Device:self.careBtn];
}

- (void)maskViewToBounds:(UIView *)view
{
    view.layer.cornerRadius = view.height * 0.5;
    view.layer.masksToBounds = YES;
}

static int randomNum = 0;
- (void)setLive:(Live *)live
{
    _live = live;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:live.smallpic] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
    self.nameLabel.text = live.myname;
    self.peopleLabel.text = [NSString stringWithFormat:@"%ld人", (unsigned long)live.allnum];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateNum) userInfo:nil repeats:YES];
    self.headImageView.userInteractionEnabled = YES;
    [self.headImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickChangYang:)]];
}

- (void)updateNum
{
    randomNum += arc4random_uniform(5);
    self.peopleLabel.text = [NSString stringWithFormat:@"%lu人", self.live.allnum + randomNum];
    [self.giftView setTitle:[NSString stringWithFormat:@"猫粮:%u  娃娃%u", 1993045 + randomNum,  124593+randomNum] forState:UIControlStateNormal];
}

- (void)setupChangeyang
{
    self.peoplesScrollView.contentSize = CGSizeMake((self.peoplesScrollView.height + 10) * self.LookUsers.count + 10, 0);
    CGFloat width = self.peoplesScrollView.height - 10;
    CGFloat x = 0;
    for (int i = 0; i<self.LookUsers.count; i++) {
        x = 0 + (10 + width) * i;
        UIImageView *userView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 5, width, width)];
        userView.layer.cornerRadius = width * 0.5;
        userView.layer.masksToBounds = YES;
        User *user = self.LookUsers[i];
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:user.photo] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                userView.image = [UIImage circleImage:image borderColor:[UIColor whiteColor] borderWidth:1];
            });
        }];
        // 设置监听
        userView.userInteractionEnabled = YES;
        [userView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickChangYang:)]];
        userView.tag = i;
        [self.peoplesScrollView addSubview:userView];
    }
    
}

- (void)clickChangYang:(UITapGestureRecognizer *)tapGes
{
    if (tapGes.view == self.headImageView) {
        User *user = [[User alloc] init];
        user.nickname = self.live.myname;
        user.photo = self.live.bigpic;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyClickUser object:nil userInfo:@{@"user" : user}];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyClickUser object:nil userInfo:@{@"user" : self.LookUsers[tapGes.view.tag]}];
    }
}


- (IBAction)Device:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.isShow) {
        self.isShow(sender.selected);
    }
}

@end
