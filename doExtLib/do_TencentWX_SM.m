//
//  do_TencentWX_SM.m
//  DoExt_SM
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "do_TencentWX_SM.h"

#import "doScriptEngineHelper.h"
#import "doIScriptEngine.h"
#import "doInvokeResult.h"
#import "doJsonHelper.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import <UIKit/UIKit.h>
#import "do_TencentWX_App.h"
#import "AppDelegate.h"
#import "doIOHelper.h"
#import "doIPage.h"

@interface do_TencentWX_SM (WeChat)<WXApiDelegate>
{
    
}
@end
@implementation do_TencentWX_SM
#pragma mark -
#pragma mark - 同步异步方法的实现
//同步
- (void)isWXAppInstalled:(NSArray *)parms
{
    id<doIScriptEngine> _scritEngine = [parms objectAtIndex:1];
    //自己的代码实现
    
    doInvokeResult *_invokeResult = [parms objectAtIndex:2];
    //_invokeResult设置返回值
    BOOL isInstalled = [WXApi isWXAppInstalled];
    [_invokeResult SetResultBoolean:isInstalled];
}
//异步
- (void)login:(NSArray *)parms
{
    NSDictionary *_dictParas = [parms objectAtIndex:0];
    scritEngine = [parms objectAtIndex:1];
    callBackName = [parms objectAtIndex:2];
    //自己的代码实现
    appId = [doJsonHelper GetOneText: _dictParas :@"appId" :@""];
    if(appId.length<=0){
        [NSException raise:@"wechat" format:@"wechat的appId无效!",nil];
    }
    [WXApi registerApp:appId];
    do_TencentWX_App* _app = [do_TencentWX_App Instance];
    _app.OpenURLScheme = appId;
    
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init ] ;
    req.scope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact" ;
    req.state = appId ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

- (void)pay:(NSArray *)parms
{
    //异步耗时操作，但是不需要启动线程，框架会自动加载一个后台线程处理这个函数
    NSDictionary *_dictParas = [parms objectAtIndex:0];
    
    //参数字典_dictParas
    scritEngine = [parms objectAtIndex:1];
    //自己的代码实现
    
    callBackName = [parms objectAtIndex:2];
    PayReq *req = [[PayReq alloc]init];
    appId = [doJsonHelper GetOneText:_dictParas :@"appId" :@""];
    do_TencentWX_App* _app = [do_TencentWX_App Instance];
    _app.OpenURLScheme = appId;
    req.openID = appId;
    [WXApi registerApp:appId];
    req.partnerId = [doJsonHelper GetOneText:_dictParas :@"partnerId" :@""];
    req.prepayId = [doJsonHelper GetOneText:_dictParas :@"prepayId" :@""];
    req.package = [doJsonHelper GetOneText:_dictParas :@"package" :@""];
    req.nonceStr = [doJsonHelper GetOneText:_dictParas :@"nonceStr" :@""];
    req.timeStamp = [doJsonHelper GetOneInteger:_dictParas :@"timeStamp" :0];
    req.sign = [doJsonHelper GetOneText:_dictParas :@"sign" :@""];
    [WXApi sendReq:req];
}

- (void)share:(NSArray *)parms
{
    NSDictionary *_dictParas = [parms objectAtIndex:0];
    //参数字典_dictParas
    scritEngine = [parms objectAtIndex:1];
    //自己的代码实现
    callBackName = [parms objectAtIndex:2];
    appId = [doJsonHelper GetOneText:_dictParas :@"appId" :@""];
    [WXApi registerApp:appId];
    do_TencentWX_App* _app = [do_TencentWX_App Instance];
    _app.OpenURLScheme = appId;
    int scene = [doJsonHelper GetOneInteger:_dictParas :@"scene" :0];
    int type = [doJsonHelper GetOneInteger:_dictParas :@"type" :0];
    NSString *title = [doJsonHelper GetOneText:_dictParas :@"title" :@""];
    NSString *content = [doJsonHelper GetOneText:_dictParas :@"content" :@""];
    NSString *url = [doJsonHelper GetOneText:_dictParas :@"url" :@""];
    NSString *image = [doJsonHelper GetOneText:_dictParas :@"image" :@""];
    NSString *audio = [doJsonHelper GetOneText:_dictParas :@"audio" :@""];
    SendMessageToWXReq *req = [self getMessage:type withScene:scene withTitle:title withContent:content withUrl:url withImage:image withAudio:audio];
    [WXApi sendReq:req];
}

- (SendMessageToWXReq *)getMessage:(int)type withScene:(int)scene withTitle:(NSString *)title withContent:(NSString *)content withUrl:(NSString *)url withImage:(NSString *)image withAudio:(NSString *)audio
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.scene = scene;
    switch (type) {
        case 0:
        {
            //支持网络图片
            WXMediaMessage *message = [WXMediaMessage message];
            if ([image hasPrefix:@"http"]) {
                [message setThumbData:[NSData dataWithContentsOfURL:[NSURL URLWithString:image]]];
            }
            else
            {
                NSString *imagePath = [doIOHelper GetLocalFileFullPath:scritEngine.CurrentPage.CurrentApp :image];
                message.thumbData = [NSData dataWithContentsOfFile:imagePath];
            }

            
            message.title = title;
            message.description = content;
            WXWebpageObject *ext = [WXWebpageObject object];
            ext.webpageUrl =url;
            
            message.mediaObject = ext;
            req.bText = NO;
            req.message = message;
            req.scene = scene;
        }
            break;
        case 1:
        {
            WXMediaMessage *message = [WXMediaMessage message];
//            message.title = title;
//            message.description = content;
            WXImageObject *ext = [WXImageObject object];
            NSString *imagePath = [doIOHelper GetLocalFileFullPath:scritEngine.CurrentPage.CurrentApp :image];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imagePath]];
            ext.imageData = [NSData dataWithContentsOfFile:imagePath];
            message.thumbData = UIImageJPEGRepresentation(image, 0.5);
            message.mediaObject = ext;
            req.bText = NO;
            req.message = message;

        }
            break;
        case 2:
        {
            WXMediaMessage *message = [WXMediaMessage message];
            NSString *imagePath;
            if ([image hasPrefix:@"http"]) {
                imagePath = image;
                [message setThumbData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]]];
            }
            else
            {
                imagePath = [doIOHelper GetLocalFileFullPath:scritEngine.CurrentPage.CurrentApp :image];
                message.thumbData = [NSData dataWithContentsOfFile:imagePath];

            }
            message.title = title;
            message.description = content;
            WXMusicObject *ext = [WXMusicObject object];
            ext.musicUrl = audio;
            if(audio.length<=0){
                [NSException raise:@"TencentWX" format:@"WX分享的audio的无效!",nil];
            }
            message.mediaObject = ext;
            req.bText = NO;
            req.message = message;

        }
            break;

        default:
            break;
    }
    return req;
}

/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        GetMessageFromWXReq *temp = (GetMessageFromWXReq *)req;
        
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = [NSString stringWithFormat:@"openID: %@", temp.openID];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n附加消息:%@\n", temp.openID, msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length, msg.messageExt];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        LaunchFromWXReq *temp = (LaunchFromWXReq *)req;
        WXMediaMessage *msg = temp.message;
        
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = [NSString stringWithFormat:@"openID: %@, messageExt:%@", temp.openID, msg.messageExt];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        int resultCode = resp.errCode;
        doInvokeResult* result = [[doInvokeResult alloc]init];
        if (resultCode) {
            [result SetResultBoolean:NO];
        }
        else
        {
            [result SetResultBoolean:YES];
        }
        [scritEngine Callback:callBackName :result ];
        scritEngine = nil;
    }
    else if ([resp isKindOfClass:[PayResp class]])
    {
        int result = 1;
        switch (resp.errCode) {
            case WXSuccess:
                result = 0;
                break;
            case WXErrCodeCommon:
                result = -1;
                break;
            case WXErrCodeUserCancel:
                result = -2;
                break;
            default:
                [NSException raise:@"微信支付" format:@"微信支付失败",nil];
                break;
        }
        doInvokeResult *invokeResult = [[doInvokeResult alloc]init:self.UniqueKey];
        [invokeResult SetResultInteger:result];
        [scritEngine Callback:callBackName :invokeResult];
    }
    else if([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp *temp = (SendAuthResp*)resp;
        
        //        NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
        //        NSString *strMsg = [NSString stringWithFormat:@"code:%@,state:%@,errcode:%d", temp.code, temp.state, temp.errCode];
        //
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [alert show];
        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
        if(temp.code!=nil)
            [dict setObject:temp.code forKey:@"code"];
        if(temp.state!=nil)
            [dict setObject:temp.state forKey:@"state"];
        if(temp.lang!=nil)
            [dict setObject:temp.lang forKey:@"lang"];
        if(temp.country!=nil)
            [dict setObject:temp.country forKey:@"country"];
        [dict setObject:[NSNumber numberWithInt:temp.errCode ] forKey:@"errcode"];
        if(temp.code!=nil)
            [dict setObject:temp.code forKey:@"code"];
        doInvokeResult* result = [[doInvokeResult alloc]init];
        [result SetResultNode:dict];
        [scritEngine Callback:callBackName :result ];
        scritEngine = nil;
    }
    else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]])
    {
        AddCardToWXCardPackageResp* temp = (AddCardToWXCardPackageResp*)resp;
        NSMutableString* cardStr = [[NSMutableString alloc] init];
        for (WXCardItem* cardItem in temp.cardAry) {
            [cardStr appendString:[NSString stringWithFormat:@"cardid:%@ cardext:%@ cardstate:%u\n",cardItem.cardId,cardItem.extMsg,(unsigned int)cardItem.cardState]];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"add card resp" message:cardStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        scritEngine = nil;
    }
}
-(UIImage *)downImage:(NSString *)url
{
    NSURLSession *session = [NSURLSession sharedSession];
    [session downloadTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
    }];
    return nil;
}
@end