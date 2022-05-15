//
//  JDModuleRouterRegisterProtocol.h
//  JDModuleManager
//
//  Created by Mac on 2022/5/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 模块路由协议
@protocol JDModuleRouterRegisterProtocol <NSObject>

@optional
// 注册路由
- (NSArray<NSString *> *)registModuleRoutes;

// 处理路由事件
- (BOOL)handleRouteWithScheme:(NSString *)scheme
                         host:(NSString *)host
                         path:(NSString *)path
                       params:(NSDictionary *)params;
@end

NS_ASSUME_NONNULL_END
