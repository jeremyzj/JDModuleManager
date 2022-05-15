//
//  JDModuleManager.m
//  JDModuleManager
//
//  Created by Mac on 2022/5/15.
//

#import "JDModuleManager.h"
#import "JDModuleRegisterProtocol.h"
#import "JDRouterManager.h"
#import "JDModuleServeManager.h"
#import "JDModuleServiceInfo.h"

static NSString *const kModulesKey = @"modules";

@implementation JDModuleManager


+ (instancetype)sharedInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 加载Modules
    [self loadModules];
    
    return YES;
}

- (void)loadModules {
    NSArray *moduleArray = [self moduleArray];
    for (NSString *moduleStr in moduleArray) {
        id<JDModuleRegisterProtocol> instance = [NSClassFromString(moduleStr) new];
        if (![instance conformsToProtocol:@protocol(JDModuleRegisterProtocol)]) {
            continue;
        }
        
        /// 注册路由
        if ([instance respondsToSelector:@selector(registModuleRoutes)]) {
            NSArray *routers = [instance registModuleRoutes];
            for (NSString *router in routers) {
                [[JDRouterManager oneInstance] registerRouter:router forModule:instance];
            }
        }
        
        /// 注册服务
        if ([instance respondsToSelector:@selector(registModuleServices)]) {
            NSArray *services = [instance registModuleServices];
            for (JDModuleServiceInfo *info in services) {
                [[JDModuleServeManager oneInstance] registService:info];
            }
        }
    }
}


- (NSArray *)moduleArray {
    NSDictionary *moduleDic = [self modulesFromFile];
    return moduleDic[kModulesKey];
}

- (NSDictionary *)modulesFromFile
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"modules" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

@end
