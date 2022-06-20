//
//  AModuleDemo.m
//  JDModuleShow
//
//  Created by Mac on 2022/5/15.
//

#import "CModuleDemo.h"
#import <JDModuleRouter/JDRouter.h>
#import <JDModuleManager/JDModuleServiceInfo.h>

@implementation CModuleDemo

- (NSArray<NSString *> *)registModuleRoutes {
    return @[kCRouter1];
}

- (BOOL)handleRouteWithScheme:(NSString *)scheme
                         host:(NSString *)host
                         path:(NSString *)path
                       params:(NSDictionary *)params {
    NSString *router = [NSString stringWithFormat:@"%@://%@", scheme, host];
    if ([router isEqualToString:kCRouter1]) {
        NSLog(@"kCRouter1");
    }
    return YES;
}


- (NSArray<JDModuleServiceInfo *> *)registModuleServices {
    JDModuleServiceInfo *info = [JDModuleServiceInfo new];
    info.protocol = @protocol(CModuleServiceProtocol);
    info.implClass = CModuleDemo.class;
    
    return @[info];
}

- (void)cService1 {
    NSLog(@"c service 1");
}

@end
