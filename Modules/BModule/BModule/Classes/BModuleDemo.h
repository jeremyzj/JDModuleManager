//
//  BModuleDemo.h
//  JDModuleShow
//
//  Created by Mac on 2022/5/15.
//

#import <Foundation/Foundation.h>
#import <JDModuleManager/JDModuleRegisterProtocol.h>
#import <JDModuleService/BModuleServiceProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface BModuleDemo : NSObject<JDModuleRegisterProtocol, BModuleServiceProtocol>

@end

NS_ASSUME_NONNULL_END
