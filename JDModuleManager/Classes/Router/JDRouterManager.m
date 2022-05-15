//
//  JSRouterManager.m
//  Pods-JDModuleShow
//
//  Created by Mac on 2022/5/15.
//

#import "JDRouterManager.h"
#import "JDModuleRegisterProtocol.h"

@implementation NSString (JDRoute)

- (NSString *)jd_routeUrlEncode {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    unsigned long sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

@end


static NSString * const kJDModuleRouteFakeScheme = @"kJDModuleRouteFakeScheme";


@implementation NSURL (JDRoute)

+ (NSURL *)jd_URLWithRoute:(NSString *)route {
    if (![route isKindOfClass:[NSString class]] || route.length == 0) {
        return nil;
    }

    NSRange queryRange = [route rangeOfString:@"?"];
    if (queryRange.location != NSNotFound && queryRange.length > 0) {
        // 对参数进行 url encode
        NSMutableString *str = [NSMutableString stringWithString:[route substringToIndex:queryRange.location]];
        NSDictionary<NSString *, NSString *> *query = [self _jd_dictionaryFromRouteQuery:[route substringFromIndex:queryRange.location + 1]];
        NSArray<NSString *> *keyArr = [query allKeys];
        for (NSInteger idx = 0; idx < keyArr.count; idx ++) {
            [str appendString:(idx == 0 ? @"?" : @"&")];
            NSString *key = keyArr[idx];
            NSString *value = [[query valueForKey:key] jd_routeUrlEncode];
            [str appendFormat:@"%@=%@", key, value];
        }
        route = str;
    }
    
    // 根据情况拼接fakeScheme，帮助url解析
    NSRange schemeRange = [route rangeOfString:@"://"];
    if (schemeRange.length == 0 || (queryRange.length > 0 && schemeRange.location > queryRange.location)) {
        route = [kJDModuleRouteFakeScheme stringByAppendingFormat:@"://%@", route];
    } else if (schemeRange.location == 0) {
        route = [kJDModuleRouteFakeScheme stringByAppendingString:route];
    }
    
    return [NSURL URLWithString:route];
}

+ (NSDictionary *)_jd_dictionaryFromRouteQuery:(NSString *)query {
    if (![query isKindOfClass:[NSString class]] || query.length == 0) {
        return nil;
    }
    NSCharacterSet *delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary *pairs = [NSMutableDictionary dictionary];
    NSScanner *scanner = [[NSScanner alloc] initWithString:query];
    while (![scanner isAtEnd]) {
        NSString *pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray *kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 2) {
            NSString *key = [[kvPair objectAtIndex:0]
                             stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *value = [[kvPair objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [pairs setObject:value forKey:key];
        }
    }
    
    return [pairs copy];
}

@end

@interface JDRouterManager()

@property (nonatomic, strong) NSMapTable<NSString *, id<JDModuleRegisterProtocol>> *routeMapping;

@end

@implementation JDRouterManager

+ (instancetype)oneInstance {
    static JDRouterManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [JDRouterManager new];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _routeMapping = [NSMapTable strongToStrongObjectsMapTable];
    }
    return self;
}

- (void)canOpenRouter:(nonnull NSString *)router {
    
}

- (BOOL)openRouter:(nonnull NSString *)router withParams:(nonnull NSDictionary *)params {
    if (!([router isKindOfClass:[NSString class]] && router.length > 0)) {
        return NO;
    }
   
    NSURL *targetUrl = [NSURL jd_URLWithRoute:router];
    if (!targetUrl) {
        return NO;
    }
    NSString *scheme = [targetUrl.scheme stringByRemovingPercentEncoding];
    NSString *host = [targetUrl.host stringByRemovingPercentEncoding];
    NSString *path = [targetUrl.path stringByRemovingPercentEncoding];
    NSString *query = targetUrl.query;
   
    NSDictionary *dic = [JDRouterManager dictionaryFromQuery:query];
    NSMutableDictionary *queryDic = [NSMutableDictionary new];
    if ([dic isKindOfClass:[NSDictionary class]] && dic.count > 0) {
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSString *value = [obj stringByRemovingPercentEncoding];
            [queryDic setValue:value forKey:key];
        }];
    }
       
    /// TODO: deep link 跳转
//       if ([[TYModule applicationService] respondsToSelector:@selector(shouldOpenRouteWithScheme:host:path:params:)]) {
//           NSMutableDictionary *params = [NSMutableDictionary new];
//           [params setValuesForKeysWithDictionary:queryDic];
//           [params setValuesForKeysWithDictionary:userInfo];
//
//           if (![[TYModule applicationService] shouldOpenRouteWithScheme:[[scheme lowercaseString] isEqualToString:[kTYModuleRouteFakeScheme lowercaseString]] ? nil : scheme host:host path:path params:params]) {
//               return NO;
//           }
//       }
    
    /// TODO: web 跳转
       
//       if ([[scheme lowercaseString] isEqualToString:@"https"] || [[scheme lowercaseString] isEqualToString:@"http"]) {
//           NSMutableDictionary *params = userInfo ? userInfo.mutableCopy : @{}.mutableCopy;
//           params[@"url"] = targetUrl.absoluteString;
//           return [self openRoute:@"tuyaweb" withParams:params.copy];
//       }
       return [self openRouteWithScheme:[[scheme lowercaseString] isEqualToString:[kJDModuleRouteFakeScheme lowercaseString]] ? nil : scheme
                                   host:host
                                   path:path
                            queryParams:queryDic
                                 params:params];
       
}


- (BOOL)openRouteWithScheme:(NSString *)scheme
                       host:(NSString *)host
                       path:(NSString *)path
                queryParams:(NSDictionary *)queryDic
                     params:(NSDictionary *)userInfo {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValuesForKeysWithDictionary:queryDic];
    [params setValuesForKeysWithDictionary:userInfo];
    
    id<JDModuleRegisterProtocol> module = [self.routeMapping objectForKey:[host lowercaseString]];
    
    if ([module respondsToSelector:@selector(handleRouteWithScheme:host:path:params:)]) {
        [module handleRouteWithScheme:scheme host:host path:path params: params];
    }
    
    return YES;
}

- (void)registerRouter:(nonnull NSString *)router forModule:(nonnull id<JDModuleRegisterProtocol>)module {
    if (![module conformsToProtocol:@protocol(JDModuleRegisterProtocol)]) {
        NSLog(@"必须遵循JDModuleRegisterProtocol协议");
        return;
    }
    
    NSURL *url = [NSURL jd_URLWithRoute:router];
    NSString *host = [url.host lowercaseString];
    if (!module || !host) {
        return;
    }
    
    [_routeMapping setObject:module forKey:host];
}


+ (NSDictionary *)dictionaryFromQuery:(NSString *)query {
    return [self dictionaryFromQuery:query usingEncoding:NSUTF8StringEncoding];
}

+ (NSDictionary *)dictionaryFromQuery:(NSString *)query usingEncoding:(NSStringEncoding)encoding {
    if (!([query isKindOfClass:[NSString class]] && query.length > 0)) {
        return nil;
    }
    NSCharacterSet *delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:query];
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 2) {
            NSString* key = [[kvPair objectAtIndex:0]
                             stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSString* value = [[kvPair objectAtIndex:1]
                               stringByReplacingPercentEscapesUsingEncoding:encoding];
            [pairs setObject:value forKey:key];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:pairs];
}

@end
