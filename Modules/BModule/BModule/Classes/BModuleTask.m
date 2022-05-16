//
//  BModuleTask.m
//  JDModuleShow
//
//  Created by Mac on 2022/5/15.
//

#import "BModuleTask.h"

@implementation BModuleTask

- (void)start {
    NSLog(@"b module task");
}

+ (JDLaunchTaskRunMode)runMode {
    return JDLaunchTaskRunMode_AsyncOnMain;// 必须保证在启动完成请求
}

/**
 优先级，默认为 TYLaunchTaskPriority_Default
 */
+ (JDLaunchTaskPriority)priority {
    return JDLaunchTaskPriority_Low;
}

@end
