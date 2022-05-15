//
//  JSRouterManager.h
//  Pods-JDModuleShow
//
//  Created by Mac on 2022/5/15.
//

#import <Foundation/Foundation.h>
#import "JDModuleRouteProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface JDRouterManager : NSObject<JDModuleRouteProtocol>

+ (instancetype)oneInstance;

@end

NS_ASSUME_NONNULL_END
