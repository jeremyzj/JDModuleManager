//
//  JDModuleServeInfo.m
//  JDModuleManager
//
//  Created by Mac on 2022/5/15.
//

#import "JDModuleServiceInfo.h"

@implementation JDModuleServiceInfo

- (id)copy {
    return [self copyWithZone:nil];
}

- (id)copyWithZone:(NSZone *)zone {
    JDModuleServiceInfo *service;
    if (zone) {
        service = [JDModuleServiceInfo allocWithZone:zone];
    } else {
        service = [JDModuleServiceInfo new];
    }
    service.protocol = self.protocol;
    service.implClass = self.implClass;
    
    return service;
}

@end
