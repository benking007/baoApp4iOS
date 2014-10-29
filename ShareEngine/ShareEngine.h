//
//  ShareEngine.h
//  ShareEngineExample
//
//  Created by 陈欢 on 13-10-8.
//  Copyright (c) 2013年 陈欢. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ROConstants.h"
#import "WXApi.h"

@protocol ShareEngineDelegate;

@interface ShareEngine : NSObject<WXApiDelegate>
{
}
@property (nonatomic, assign) id<ShareEngineDelegate> delegate;

+ (ShareEngine *) sharedInstance;

- (BOOL)handleOpenURL:(NSURL *)url;

- (void)registerApp;

/**
 *@description 判断是否登录
 *@param weibotype:微博类型
 */
- (BOOL)isLogin:(WeiboType)weiboType;

/**
 *@description 发送微信消息
 *@param message:文本消息 url:分享链接 weibotype:微信消息类型
 */
- (void)sendWeChatMessage:(NSString*)message WithUrl:(NSString*)url WithType:(WeiboType)weiboType;

/**
 *@description 发送微博成功
 *@param message:文本消息 weibotype:微博类型
 */
- (void)sendShareMessage:(NSString*)message WithType:(WeiboType)weiboType;

@end

/**
 * @description 微博登录及发送微博类容结果的回调
 */
@protocol ShareEngineDelegate <NSObject>
@optional
/**
 *@description 发送微博成功
 *@param weibotype:微博类型
 */
- (void)shareEngineDidLogIn:(WeiboType)weibotype;

/**
 *@description 发送微博成功
 *@param weibotype:微博类型
 */
- (void)shareEngineDidLogOut:(WeiboType)weibotype;

/**
 *@description 发送微博成功
 */
- (void)shareEngineSendSuccess;

/**
 *@descrition 发送微博失败
 *@param error:失败代码
 */
- (void)shareEngineSendFail:(NSError *)error;
@end
