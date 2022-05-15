//
//  JDModuleRegisterProtocol.h
//  JDModuleManager
//
//  Created by Mac on 2022/5/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JDModuleServiceInfo;
@protocol JDLaunchTaskProtocol;

/// 模块路由协议
@protocol JDModuleRegisterProtocol <NSObject>

@optional
// 注册路由
- (NSArray<NSString *> *)registModuleRoutes;

// 处理路由事件
- (BOOL)handleRouteWithScheme:(NSString *)scheme
                         host:(NSString *)host
                         path:(NSString *)path
                       params:(NSDictionary *)params;

// 注册服务
- (NSArray<JDModuleServiceInfo *> *)registModuleServices;

// 注册启动任务
- (NSArray<Class<JDLaunchTaskProtocol>> *)registLaunchTasks;
@end

NS_ASSUME_NONNULL_END
