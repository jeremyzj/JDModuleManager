//
//  AModuleDemo.m
//  JDModuleShow
//
//  Created by Mac on 2022/5/15.
//

#import "AModuleDemo.h"
#import <JDModuleRouter/Router.h>
#import <JDModuleManager/JDModuleServiceInfo.h>

@implementation AModuleDemo

- (NSArray<NSString *> *)registModuleRoutes {
    return @[kARouter1, kARouter2];
}

- (BOOL)handleRouteWithScheme:(NSString *)scheme
                         host:(NSString *)host
                         path:(NSString *)path
                       params:(NSDictionary *)params {
    NSString *router = [NSString stringWithFormat:@"%@://%@", scheme, host];
    if ([router isEqualToString:kARouter1]) {
        NSLog(@"kARouter1");
    } else if ([router isEqualToString:kARouter2]) {
        NSLog(@"kARouter2");
    }
    return YES;
}


- (NSArray<JDModuleServiceInfo *> *)registModuleServices {
    JDModuleServiceInfo *info = [JDModuleServiceInfo new];
    info.protocol = @protocol(AModuleServiceProtocol);
    info.implClass = AModuleDemo.class;
    
    return @[info];
}

- (void)aService1 {
    NSLog(@"a service 1");
}

- (void)aService2 {
    NSLog(@"a service 2");
}

@end
