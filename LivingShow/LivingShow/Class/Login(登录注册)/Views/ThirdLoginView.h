//
//  ThirdLoginView.h
//  Live
//
//  Created by LI on 16/8/10.
//  Copyright © 2016年 LI. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LoginType){
    LoginTypeSina,
    LoginTypeQQ,
    LoginTypeWechat
};

typedef void(^clickLogin)(LoginType type);

@interface ThirdLoginView : UIView

/** 点击登录按钮后所做的事情 */
@property (copy, nonatomic) clickLogin loginBlock;

@end
