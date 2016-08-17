//
//  HomeADCell.h
//  LivingShow
//
//  Created by LI on 16/8/12.
//  Copyright © 2016年 LI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TopAD;

@interface HomeADCell : UITableViewCell

/** 顶部AD数组 */
@property (nonatomic, strong) NSArray *topADs;
/** 点击图片的block */
@property (nonatomic, copy) void (^imageClickBlock)(TopAD *topAD);

@end
