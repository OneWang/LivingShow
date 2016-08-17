//
//  HomeADCell.m
//  LivingShow
//
//  Created by LI on 16/8/12.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "HomeADCell.h"
#import "TopAD.h"
#import "XRCarouselView.h"

@interface HomeADCell ()<XRCarouselViewDelegate>

@end

@implementation HomeADCell

- (void)setTopADs:(NSArray *)topADs
{
    _topADs = topADs;
    
    NSMutableArray *imageUrls = [NSMutableArray array];
    for (TopAD *topAD in topADs) {
        [imageUrls addObject:topAD.imageUrl];
    }
    XRCarouselView *view = [XRCarouselView carouselViewWithImageArray:imageUrls describeArray:nil];
    view.time = 2.0;
    view.delegate = self;
    view.frame = self.contentView.bounds;
    [self.contentView addSubview:view];
}

#pragma mark - XRCarouselViewDelegate
- (void)carouselView:(XRCarouselView *)carouselView clickImageAtIndex:(NSInteger)index
{
    if (self.imageClickBlock) {
        self.imageClickBlock(self.topADs[index]);
    }
}

@end
