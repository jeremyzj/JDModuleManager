//
//  JDLaunchTaskProtocol.h
//  JDModuleManager
//
//  Created by Mac on 2022/5/15.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    JDLaunchTaskRunMode_AsyncOnGlobal   = 0,      /**< 异步到全局队列执行 */
    JDLaunchTaskRunMode_AsyncOnMain     = 1,      /**< 异步到主队列执行 */
    // 在主线程串行由于对启动时间影响较大，为内部保留类型，有需要请打call
} JDLaunchTaskRunMode;

typedef enum : NSUInteger {
    JDLaunchTaskPriority_Low = 250,
    JDLaunchTaskPriority_Default = 750,
    JDLaunchTaskPriority_Hight = 1000,
} JDLaunchTaskPriority;


@protocol JDLaunchTaskProtocol <NSObject>

@required
/*
 开始执行, 请把需要执行的任务写在此回调下
 */
- (void)start;

@optional
/*
 执行方式  [Default: TYLaunchTaskRunMode_AsyncOnGlobal]
 */
+ (JDLaunchTaskRunMode)runMode;

/**
 优先级，默认为 TYLaunchTaskPriority_Default
 */
+ (JDLaunchTaskPriority)priority;

@end

