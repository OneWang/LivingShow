//
//  NewFlowLayout.m
//  LivingShow
//
//  Created by LI on 16/8/17.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "NewFlowLayout.h"

@implementation NewFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    CGFloat wh = (screenW - 3) / 3.0;
    self.itemSize = CGSizeMake(wh , wh);
    self.minimumLineSpacing = 1;
    self.minimumInteritemSpacing = 1;
    
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.alwaysBounceVertical = YES;
}

@end
