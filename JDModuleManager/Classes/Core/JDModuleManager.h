//
//  JDModuleManager.h
//  JDModuleManager
//
//  Created by Mac on 2022/5/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDModuleManager : NSObject


+ (_Nonnull instancetype)sharedInstance;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

@end

NS_ASSUME_NONNULL_END
