//
//  JDModuleTaskManager.m
//  JDModuleManager
//
//  Created by Mac on 2022/5/15.
//

#import "JDModuleTaskManager.h"
#import "JDLaunchTaskProtocol.h"
#import <objc/runtime.h>


static NSString *const kJDModuleTaskTimeLogKey = @"DEBUG_MODULE_TASK_TIME";


static NSString *const kJDLaunchTaskParentTaskKey = @"kJDLaunchTaskParentTaskKey";

static NSUInteger const JDLaunchTaskRunMode_SerialOnMain = 666;

@interface JDModuleTaskManager()

@property (nonatomic, strong) NSMutableArray<Class<JDLaunchTaskProtocol>> *serialMainTaskArr;
@property (nonatomic, strong) NSMutableArray<Class<JDLaunchTaskProtocol>> *asyncGlobalTaskArr;
@property (nonatomic, strong) NSMutableArray<Class<JDLaunchTaskProtocol>> *asyncMainTaskArr;

// 用来保存task实例，避免某个实例在复杂依赖中被反复创建   key: className   value: instance
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSObject<JDLaunchTaskProtocol> *> *taskInstanceCache;

@end

@implementation JDModuleTaskManager

+ (instancetype)oneInstance {
    static JDModuleTaskManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [JDModuleTaskManager new];
    });
    return instance;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        _serialMainTaskArr = [NSMutableArray new];
        _asyncGlobalTaskArr = [NSMutableArray new];
        _asyncMainTaskArr = [NSMutableArray new];
    }
    return self;
}

- (void)registLaunchTask:(Class<JDLaunchTaskProtocol>)taskCls {
    if (!object_isClass(taskCls)) {
        return;
    }
    
    JDLaunchTaskRunMode runMode = JDLaunchTaskRunMode_AsyncOnGlobal;
    if ([taskCls respondsToSelector:@selector(runMode)]) {
        runMode = [taskCls runMode];
    }
    
    if (runMode == JDLaunchTaskRunMode_SerialOnMain) {
        [_serialMainTaskArr addObject:taskCls];
    } else if (runMode == JDLaunchTaskRunMode_AsyncOnMain) {
        [_asyncMainTaskArr addObject:taskCls];
    } else {
        [_asyncGlobalTaskArr addObject:taskCls];
    }
}


- (void)executeLaunchTasks {
    _taskInstanceCache = [NSMutableDictionary new];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kJDModuleTaskTimeLogKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self executeTasksWithArray:_serialMainTaskArr];
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf executeTasksWithArray:weakSelf.asyncMainTaskArr];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakSelf executeTasksWithArray:weakSelf.asyncGlobalTaskArr];
    });
}


#pragma mark - Private
- (void)executeTasksWithArray:(NSArray<Class<JDLaunchTaskProtocol>> *)arr {
    NSArray<Class<JDLaunchTaskProtocol>> *sortedArr = [arr sortedArrayUsingComparator:^NSComparisonResult(Class<JDLaunchTaskProtocol>  _Nonnull obj1, Class<JDLaunchTaskProtocol>  _Nonnull obj2) {
        NSUInteger pri1 = [obj1 respondsToSelector:@selector(priority)] ? [obj1 priority] : JDLaunchTaskPriority_Default;
        NSUInteger pri2 = [obj2 respondsToSelector:@selector(priority)] ? [obj2 priority] : JDLaunchTaskPriority_Default;
        return pri1 == pri2 ? NSOrderedSame : (pri1 < pri2 ? NSOrderedDescending : NSOrderedAscending);
    }];
    
    NSMutableArray *taskArr = [NSMutableArray new];
    for (Class<JDLaunchTaskProtocol> taskCls in sortedArr) {
        NSObject<JDLaunchTaskProtocol> *task = [self taskInstanceWithClass:taskCls];
        [taskArr addObject:task];
    }
    
    for (NSObject<JDLaunchTaskProtocol> *task in taskArr) {
        
        
        NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
        
        NSLog(@"TYModuleTaskManager will start %@ time: %f", NSStringFromClass([task class]), startTime);
        
        [self startLaunchTask:task];
        
        NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval interval = endTime - startTime;
//        [_taskTimeLogDic setObject:[NSNumber numberWithFloat:interval] forKey:NSStringFromClass([task class])];
        
        
        NSLog(@"TYModuleTaskManager did finish %@ interval:%f", NSStringFromClass([task class]), interval);
    }
}

- (void)startLaunchTask:(NSObject<JDLaunchTaskProtocol> *)task {
    if ([task respondsToSelector:@selector(start)]) {
        NSLog(@"TYModuleTaskManager excute task %@ on %@", NSStringFromClass([task class]), [NSThread currentThread]);
        [task start];
    }
}

- (NSObject<JDLaunchTaskProtocol> *)taskInstanceWithClass:(Class<JDLaunchTaskProtocol>)cls {
    NSString *clsName = NSStringFromClass(cls);
    if (!clsName) {
        return nil;
    }
    
    NSObject<JDLaunchTaskProtocol> *instance = [_taskInstanceCache objectForKey:clsName];
    if (!instance) {
        instance = [(id)cls new];
        [_taskInstanceCache setObject:instance forKey:clsName];
    }
    return instance;
}

@end
