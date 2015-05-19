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

@implementation do_TencentWX_App
@synthesize ThridPartyID;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}
- (void)applicationWillTerminate:(UIApplication *)application
{
    
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation fromThridParty:(NSString*)_id
{
    if([_id isEqualToString:self.ThridPartyID]){
        return [WXApi handleOpenURL:url delegate:( (id<WXApiDelegate>)[doScriptEngineHelper ParseSingletonModule:nil :@"do_TencentWX"])];
    }
    return NO;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url fromThridParty:(NSString*)_id
{
    if([_id isEqualToString:self.ThridPartyID]){
    return [WXApi handleOpenURL:url delegate:( (id<WXApiDelegate>)[doScriptEngineHelper ParseSingletonModule:nil :@"do_TencentWX"])];
    }
    return NO;
}
@end
