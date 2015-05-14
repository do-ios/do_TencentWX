//
//  do_TencentWX_SM.h
//  DoExt_SM
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "do_TencentWX_ISM.h"
#import "doSingletonModule.h"

@interface do_TencentWX_SM : doSingletonModule<do_TencentWX_ISM>
{
@private
    NSString* appId;
    id<doIScriptEngine> scritEngine;
    NSString * callBackName;
}
@end