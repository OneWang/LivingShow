//
//  LivingFlowLayout.m
//  LivingShow
//
//  Created by LI on 16/8/15.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "LivingFlowLayout.h"

@implementation LivingFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    //设置 collectionview 的滚动方向
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置每个 Item 的 size
    self.itemSize = self.collectionView.bounds.size;
    //设置每个 Item 之间的行距和左右间距
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    //隐藏滑动时候的水平滚动条和竖直滚动条
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
}

@end
