//
//  BModuleDemo.m
//  JDModuleShow
//
//  Created by Mac on 2022/5/15.
//

#import "BModuleDemo.h"
#import <JDModuleRouter/Router.h>
#import <JDModuleManager/JDModuleServiceInfo.h>
#import "BModuleTask.h"

@implementation BModuleDemo

- (NSArray<NSString *> *)registModuleRoutes {
    return @[kBRouter1, kBRouter2, kBRouter3];
}

- (BOOL)handleRouteWithScheme:(NSString *)scheme
                         host:(NSString *)host
                         path:(NSString *)path
                       params:(NSDictionary *)params {
    NSString *router = [NSString stringWithFormat:@"%@://%@", scheme, host];
    if ([router isEqualToString:kBRouter1]) {
        NSLog(@"kBRouter1");
    } else if ([router isEqualToString:kBRouter2]) {
        NSLog(@"kBRouter2");
    } else if ([router isEqualToString:kBRouter3]) {
        NSLog(@"kBRouter3");
    }
    return YES;
}


- (NSArray<JDModuleServiceInfo *> *)registModuleServices {
    JDModuleServiceInfo *info = [JDModuleServiceInfo new];
    info.protocol = @protocol(BModuleServiceProtocol);
    info.implClass = BModuleDemo.class;
    
    return @[info];
}


- (NSArray<Class<JDLaunchTaskProtocol>> *)registLaunchTasks {
    return @[[BModuleTask class]];
}

- (void)bService1 {
    NSLog(@"b service 1");
}

- (void)bService2 {
    NSLog(@"b service 2");
}

@end
