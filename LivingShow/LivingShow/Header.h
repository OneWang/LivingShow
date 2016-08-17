//
//  Header.h
//  LivingShow
//
//  Created by LI on 16/8/11.
//  Copyright © 2016年 LI. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height

// 颜色相关
#define Color(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define KeyColor Color(216, 41, 116)

// 点击了用户
#define kNotifyClickUser @"kNotifyClickUser"
// 当前没有关注的主播, 去看热门主播
#define kNotifyToseeBigWorld @"kNotifyToseeBigWorld"

#endif /* Header_h */
