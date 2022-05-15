//
//  JDModuleServiceProtocol.h
//  JDModuleManager
//
//  Created by Mac on 2022/5/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JDModuleServiceInfo;
@protocol JDModuleServiceProtocol <NSObject>

- (void)registService:(JDModuleServiceInfo *)serviceInfo;


- (nullable id)serviceOfProtocol:(Protocol *)protocol;


@end

NS_ASSUME_NONNULL_END
