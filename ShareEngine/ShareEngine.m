//
//  ShareEngine.m
//  ShareEngineExample
//
//  Created by 陈欢 on 13-10-8.
//  Copyright (c) 2013年 陈欢. All rights reserved.
//

#import "ShareEngine.h"

@implementation ShareEngine

static ShareEngine *sharedSingleton_ = nil;

+ (ShareEngine *) sharedInstance
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        sharedSingleton_ = [[ShareEngine alloc] init];
        
    }
    return sharedSingleton_;
}

- (BOOL)handleOpenURL:(NSURL *)url
{
    BOOL weiboRet = [WXApi handleOpenURL:url delegate:self];
    return weiboRet;
}

#pragma mark - weibo method

/**
 * @description 存储内容读取
 */
- (void)registerApp
{
    //向微信注册
    [WXApi registerApp:kWeChatAppId];
}

- (BOOL)isLogin:(WeiboType)weiboType
{
    return NO;
}

- (void)sendWeChatMessage:(NSString*)message WithUrl:(NSString*)url WithType:(WeiboType)weiboType
{
    if(weChat == weiboType)
    {
        [self sendAppContentWithMessage:message WithUrl:url WithScene:WXSceneSession];
        return;
    }
    else if(weChatFriend == weiboType)
    {
        [self sendAppContentWithMessage:message WithUrl:url WithScene:WXSceneTimeline];
        return;
    }
}

- (void)sendShareMessage:(NSString*)message WithType:(WeiboType)weiboType
{
    /*
    if (NO == [self isLogin:weiboType])
    {
        [self loginWithType:weiboType];
        return;
    }*/
}

#pragma mark - weibo respon
- (void)loginSuccess:(WeiboType)weibotype
{
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(shareEngineDidLogIn:)])
    {
        [self.delegate shareEngineDidLogIn:weibotype];
    }
}

- (void)logOutSuccess:(WeiboType)weibotype
{
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(shareEngineDidLogOut:)])
    {
        [self.delegate shareEngineDidLogOut:weibotype];
    }
}

- (void)weiboSendSuccess
{
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(shareEngineSendSuccess)])
    {
        [self.delegate shareEngineSendSuccess];
    }
}

- (void)weiboSendFail:(NSError *)error
{
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(shareEngineSendFail:)])
    {
        [self.delegate shareEngineSendFail:error];
    }
}

#pragma mark - wechat delegate
- (void)weChatPostStatus:(NSString*)message
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = YES;
    req.text = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}

- (void)weChatFriendPostStatus:(NSString*)message
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = YES;
    req.text = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
}

- (void)sendAppContentWithMessage:(NSString*)appMessage WithUrl:(NSString*)appUrl WithScene:(int)scene
{
    // 发送内容给微信
    
    WXMediaMessage *message = [WXMediaMessage message];
    if (WXSceneTimeline == scene)
    {
        message.title = appMessage;
    }
    else
    {
        message.title = kShareTitle;
    }
    message.description = appMessage;
    [message setThumbImage:[UIImage imageNamed:@"iTunesArtwork.png"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = appUrl;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    [WXApi sendReq:req];
}

-(void) onSentTextMessage:(BOOL) bSent
{
    if (YES == bSent)
    {
        [self weiboSendSuccess];
    }
    else
    {
        [self weiboSendFail:nil];
    }
}

-(void) onSentMediaMessage:(BOOL) bSent
{
    // 通过微信发送消息后， 返回本App
    NSString *strTitle = [NSString stringWithFormat:@"发送结果"];
    NSString *strMsg = [NSString stringWithFormat:@"发送媒体消息结果:%u", bSent];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

-(void) onSentAuthRequest:(NSString *) userName accessToken:(NSString *) token expireDate:(NSDate *) expireDate errorMsg:(NSString *) errMsg
{
    
}

-(void) onShowMediaMessage:(WXMediaMessage *) message
{
    // 微信启动， 有消息内容。
    //    WXAppExtendObject *obj = message.mediaObject;
    
    //    shopDetailViewController *sv = [[shopDetailViewController alloc] initWithNibName:@"shopDetailViewController" bundle:nil];
    //    sv.m_sShopID = obj.extInfo;
    //    [self.navigationController pushViewController:sv animated:YES];
    //    [sv release];
    
    //    NSString *strTitle = [NSString stringWithFormat:@"消息来自微信"];
    //    NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%u bytes\n\n", message.title, message.description, obj.extInfo, message.thumbData.length];
    //
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //    [alert show];
    //    [alert release];
}

-(void) onRequestAppMessage
{
    // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
}

-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        [self onRequestAppMessage];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        [self onShowMediaMessage:temp.message];
    }
    
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        if (0 == resp.errCode)
        {
            [self weiboSendSuccess];
        }
        else
        {
            [self weiboSendFail:nil];
        }
    }
}

- (void)createSuccess:(NSDictionary *)dict {
    NSLog(@"%s %@", __FUNCTION__,dict);
    if ([[dict objectForKey:@"ret"] intValue] == 0)
    {
        [self weiboSendSuccess];
        NSLog(@"发送成功！");
    }
    else
    {
        [self weiboSendFail:nil];
        NSLog(@"发送失败！");
    }
}

- (void)createFail:(NSError *)error
{
    [self weiboSendFail:nil];
    NSLog(@"发送失败!error is %@",error);
}

@end
