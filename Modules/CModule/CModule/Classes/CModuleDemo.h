//
//  AModuleDemo.h
//  JDModuleShow
//
//  Created by Mac on 2022/5/15.
//

#import <Foundation/Foundation.h>
#import <JDModuleManager/JDModuleRegisterProtocol.h>
#import <JDModuleService/CModuleServiceProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface CModuleDemo : NSObject<JDModuleRegisterProtocol, CModuleServiceProtocol>

@end

NS_ASSUME_NONNULL_END
