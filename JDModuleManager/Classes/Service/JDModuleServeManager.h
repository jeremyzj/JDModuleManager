//
//  JDModuleServeManager.h
//  JDModuleManager
//
//  Created by Mac on 2022/5/15.
//

#import <Foundation/Foundation.h>
#import "JDModuleServiceProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface JDModuleServeManager : NSObject<JDModuleServiceProtocol>

+ (instancetype)oneInstance;

@end

NS_ASSUME_NONNULL_END
