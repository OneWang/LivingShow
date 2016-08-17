//
//  LFLiveStreamInfo.h
//  LFLiveKit
//
//  Created by 倾慕 on 16/5/2.
//  Copyright © 2016年 倾慕. All rights reserved.
//  真正的上传地址 token等

#import <Foundation/Foundation.h>

/// 流状态
typedef NS_ENUM(NSUInteger, LFLiveState){
    /// 准备
    LFLiveReady = 0,
    /// 连接中
    LFLivePending = 1,
    /// 已连接
    LFLiveStart = 2,
    /// 已断开
    LFLiveStop = 3,
    /// 连接出错
    LFLiveError = 4
};

typedef NS_ENUM(NSUInteger,LFLiveSocketErrorCode) {
    LFLiveSocketError_PreView               = 201,///< 预览失败
    LFLiveSocketError_GetStreamInfo         = 202,///< 获取流媒体信息失败
    LFLiveSocketError_ConnectSocket         = 203,///< 连接socket失败
    LFLiveSocketError_Verification          = 204,///< 验证服务器失败
    LFLiveSocketError_ReConnectTimeOut      = 205///< 重新连接服务器超时
};

@interface LFLiveStreamInfo : NSObject

@property (nonatomic, copy) NSString *streamId;     ///< 流id
@property (nonatomic, copy) NSString *token;        ///< token
@property (nonatomic, copy) NSString *url;          ///< 上传地址 (RTMP用就好了)
@property (nonatomic, copy) NSString *host;         ///< 上传ip
@property (nonatomic, assign) NSInteger port;       ///< 上传端口号

#pragma mark ------------------ 为了服务器查找出错信息，尽量将一下两个字端传进来
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *roomId;

@end
