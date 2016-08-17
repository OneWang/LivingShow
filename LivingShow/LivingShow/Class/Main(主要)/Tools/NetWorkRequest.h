//
//  NetWorkRequest.h
//  LivingShow
//
//  Created by LI on 16/8/12.
//  Copyright © 2016年 LI. All rights reserved.
//

typedef void(^SuccessfulBlock)(id object);

typedef void(^FailureBlock)(NSError *error);

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NetworkStates) {
    NetworkStatesNone, // 没有网络
    NetworkStates2G, // 2G
    NetworkStates3G, // 3G
    NetworkStates4G, // 4G
    NetworkStatesWIFI // WIFI
};

@interface NetWorkRequest : NSObject

/** 请求成功后的回调 */
@property (copy, nonatomic) SuccessfulBlock successfulBlock;

/** 请求失败后的回调 */
@property (copy, nonatomic) FailureBlock failureBlock;

/** 网络请求的单例 */
+ (instancetype)sharedNetWorkRequest;

// 判断网络类型
+ (NetworkStates)getNetworkStates;

/** post 和 get 请求的方法 */
- (void)get:(NSString *)url params:(NSDictionary *)params success:(SuccessfulBlock)successBlock failure:(FailureBlock)failureBlock;

- (void)post:(NSString *)url params:(NSDictionary *)params success:(SuccessfulBlock)successBlock failure:(FailureBlock)failureBlock;

/** 取消请求数据 */
- (void)cancelRequest;

@end
