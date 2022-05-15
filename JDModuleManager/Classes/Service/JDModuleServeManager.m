//
//  JDModuleServeManager.m
//  JDModuleManager
//
//  Created by Mac on 2022/5/15.
//

#import "JDModuleServeManager.h"
#import <pthread.h>
#import "JDModuleServiceInfo.h"


static pthread_mutex_t ty_instanceCacheLock;

@interface JDModuleServeManager()

@property (nonatomic, strong) NSMutableDictionary<NSString *, JDModuleServiceInfo *> *servicesMapping;

@property (nonatomic, strong) NSMutableDictionary<NSString *, id> *singleInstanceCache;

@end

@implementation JDModuleServeManager

+ (instancetype)oneInstance {
    static JDModuleServeManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [JDModuleServeManager new];
    });
    return instance;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        _servicesMapping = [NSMutableDictionary new];
        _singleInstanceCache = [NSMutableDictionary new];
        pthread_mutex_init(&ty_instanceCacheLock, NULL);
    }
    return self;
}


- (void)registService:(JDModuleServiceInfo *)serviceInfo {
    if (!serviceInfo || ![serviceInfo isKindOfClass:[JDModuleServiceInfo class]] || !serviceInfo.protocol || !serviceInfo.implClass) {
        return;
    }
    NSString *protStr = NSStringFromProtocol(serviceInfo.protocol);
    
    if (![serviceInfo.implClass conformsToProtocol:serviceInfo.protocol]) {
        NSString *msg = [NSString stringWithFormat:@"%@ must conforms to service protocol <%@>", NSStringFromClass(serviceInfo.implClass), NSStringFromProtocol(serviceInfo.protocol)];
        NSLog(@"%@", msg);
    }
    
    JDModuleServiceInfo *existInfo = self.servicesMapping[protStr];
    if (existInfo && existInfo.implClass != serviceInfo.implClass) {
            NSString *msg = [NSString stringWithFormat:@"%@ registers <%@> , already registered by %@", NSStringFromClass(serviceInfo.implClass), protStr, NSStringFromClass(existInfo.implClass)];
        NSLog(@"%@", msg);
    } else if (!existInfo) {
        [self.servicesMapping setObject:[serviceInfo copy] forKey:protStr];
    }
}

- (nullable id)serviceOfProtocol:(nonnull Protocol *)protocol {
    JDModuleServiceInfo *info = self.servicesMapping[NSStringFromProtocol(protocol)];
    Class cls = info.implClass;
    id implInstance = [self singleInstanceOfClass:cls];

    return implInstance;
}

- (id)singleInstanceOfClass:(Class)cls {
    NSString *key = NSStringFromClass(cls);
    if (![key isKindOfClass:[NSString class]] || key.length == 0) {
        return nil;
    }
    
    pthread_mutex_lock(&ty_instanceCacheLock);
    id instance = self.singleInstanceCache[key];
    pthread_mutex_unlock(&ty_instanceCacheLock);
    if (!instance || ![instance isKindOfClass:cls]) {
        instance = nil;
        if ([cls respondsToSelector:@selector(oneInstance)]) {
            instance = [cls oneInstance];
        } else {
            instance = [cls new];
        }
        
        if (instance && [instance isKindOfClass:cls]) {
            pthread_mutex_lock(&ty_instanceCacheLock);
            [_singleInstanceCache setObject:instance forKey:key];
            pthread_mutex_unlock(&ty_instanceCacheLock);
        }
    }
    
    return instance;
}

@end
