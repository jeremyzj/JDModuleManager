//
//  JDModuleLaunchTaskProtocol.h
//  JDModuleManager
//
//  Created by Mac on 2022/5/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JDLaunchTaskProtocol;
@protocol JDModuleLaunchTaskProtocol <NSObject>


- (void)registLaunchTask:(Class<JDLaunchTaskProtocol>)taskCls;

/*
 * 优先执行串行任务，然后 并发 asyncOnMain和asyncOnGlobal，同时此方法结束
 */
- (void)executeLaunchTasks;


@end

NS_ASSUME_NONNULL_END
