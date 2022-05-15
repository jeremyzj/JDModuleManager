//
//  JDModuleRouteProtocol.h
//  Pods-JDModuleShow
//
//  Created by Mac on 2022/5/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JDModuleRouterRegisterProtocol;
@protocol JDModuleRouteProtocol <NSObject>

/// 注册路由
- (void)registerRouter:(NSString *)router forModule:(id<JDModuleRouterRegisterProtocol>)module;

/// 是否已经注册路由
- (void)canOpenRouter:(NSString *)router;

/// 打开路由
- (BOOL)openRouter:(nonnull NSString *)router withParams:(nonnull NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
