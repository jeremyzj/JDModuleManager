//
//  JDModuleTaskManager.h
//  JDModuleManager
//
//  Created by Mac on 2022/5/15.
//

#import <Foundation/Foundation.h>
#import "JDModuleLaunchTaskProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface JDModuleTaskManager : NSObject<JDModuleLaunchTaskProtocol>

+ (instancetype)oneInstance;

@end

NS_ASSUME_NONNULL_END
