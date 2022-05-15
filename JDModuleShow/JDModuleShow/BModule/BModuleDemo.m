//
//  BModuleDemo.m
//  JDModuleShow
//
//  Created by Mac on 2022/5/15.
//

#import "BModuleDemo.h"
#import "Router.h"
#import "BModuleTask.h"

@implementation BModuleDemo

- (NSArray<NSString *> *)registModuleRoutes {
    return @[kBRouter1, kBRouter2, kBRouter3];
}

- (BOOL)handleRouteWithScheme:(NSString *)scheme
                         host:(NSString *)host
                         path:(NSString *)path
                       params:(NSDictionary *)params {
    if ([host isEqualToString:kBRouter1]) {
        NSLog(@"kBRouter1");
    } else if ([host isEqualToString:kBRouter2]) {
        NSLog(@"kBRouter2");
    } else if ([host isEqualToString:kBRouter3]) {
        NSLog(@"kBRouter3");
    }
    return YES;
}


- (NSArray<Class<JDLaunchTaskProtocol>> *)registLaunchTasks {
    return @[[BModuleTask class]];
}

@end
