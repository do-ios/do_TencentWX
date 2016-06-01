//
//  do_TencentWX_App.m
//  DoExt_SM
//
//  Created by 刘吟 on 15/4/9.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "do_TencentWX_App.h"
#import "WXApi.h"
#import "doScriptEngineHelper.h"
static do_TencentWX_App* instance;

@implementation do_TencentWX_App


@synthesize OpenURLScheme;
+(id) Instance
{
    if(instance==nil)
        instance = [[do_TencentWX_App alloc]init];
    return instance;
}
-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //注册下个版本在加
//    [WXApi registerApp:@"wxc422eccce175b3e1"];
    
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:( (id<WXApiDelegate>)[doScriptEngineHelper ParseSingletonModule:nil :@"do_TencentWX"])];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:( (id<WXApiDelegate>)[doScriptEngineHelper ParseSingletonModule:nil :@"do_TencentWX"])];
}
@end
