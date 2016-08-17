//
//  ADViewController.h
//  LivingShow
//
//  Created by LI on 16/8/17.
//  Copyright © 2016年 LI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADViewController : UIViewController
/**
 *   block
 */
@property(nonatomic,copy)void(^myBlock)(BOOL isClick);
@end
