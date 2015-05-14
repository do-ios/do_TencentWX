//
//  doIAppDelegate.h
//  DoCore
//
//  Created by 刘吟 on 15/4/9.
//  Copyright (c) 2015年 DongXian. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol doIAppDelegate <NSObject>
@property (nonatomic,strong) NSString* ThridPartyID;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void)applicationWillResignActive:(UIApplication *)application ;
- (void)applicationDidEnterBackground:(UIApplication *)application ;
- (void)applicationWillEnterForeground:(UIApplication *)application ;
- (void)applicationDidBecomeActive:(UIApplication *)application ;
- (void)applicationWillTerminate:(UIApplication *)application ;
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation fromThridParty:(NSString*)_id;
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url fromThridParty:(NSString*)_id;
@end
