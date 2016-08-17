//
//  NetWorkRequest.m
//  LivingShow
//
//  Created by LI on 16/8/12.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "NetWorkRequest.h"


@interface NetWorkRequest ()

/** manager */
@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@end

@implementation NetWorkRequest

static NetWorkRequest *_manager = nil;

- (AFHTTPSessionManager *)sessionManager
{
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
        // 设置超时时间
        _sessionManager.requestSerializer.timeoutInterval = 5.f;
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
        
    }
    return _sessionManager;
}

+ (instancetype)sharedNetWorkRequest
{
    if (_manager == nil) {
        @synchronized (self) {
            if (_manager == nil) {
                _manager = [[self alloc] init];
            }
        }
    }
    return _manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    if (_manager == nil) {
        @synchronized (self) {
            if (_manager == nil) {
                _manager = [super allocWithZone:zone];
            }
        }
    }
    return _manager;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    return _manager;
}

+ (NetworkStates)getNetworkStates
{
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    NSLog(@"%@",subviews);
    // 保存网络状态
    NetworkStates states = NetworkStatesNone;
    for (id child in subviews) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏码
            int networkType = [[child valueForKeyPath:@"dataNetworkType"] intValue];
            switch (networkType) {
                case 0:
                    states = NetworkStatesNone;
                    //无网模式
                    break;
                case 1:
                    states = NetworkStates2G;
                    break;
                case 2:
                    states = NetworkStates3G;
                    break;
                case 3:
                    states = NetworkStates4G;
                    break;
                case 5:
                {
                    states = NetworkStatesWIFI;
                }
                    break;
                default:
                    break;
            }
        }
    }
    //根据状态选择
    return states;
}

- (void)get:(NSString *)url params:(NSDictionary *)params success:(SuccessfulBlock)successBlock failure:(FailureBlock)failureBlock{
    [self.sessionManager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

- (void)post:(NSString *)url params:(NSDictionary *)params success:(SuccessfulBlock)successBlock failure:(FailureBlock)failureBlock{
    [self.sessionManager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

- (void)cancelRequest
{
    [self.sessionManager.operationQueue cancelAllOperations];
}

@end
