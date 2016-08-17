//
//  AnchorViewCell.h
//  LivingShow
//
//  Created by LI on 16/8/17.
//  Copyright © 2016年 LI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;
@interface AnchorViewCell : UICollectionViewCell
/** 主播 */
@property(nonatomic, strong) User *user;
@end
