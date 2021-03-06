//
//  ViewController.m
//  JDModuleShow
//
//  Created by Mac on 2022/5/14.
//

#import "ViewController.h"
#import <JDModuleManager/JDRouterManager.h>
#import <JDModuleManager/JDModuleServeManager.h>
#import <JDModuleRouter/JDRouter.h>
#import <JDModuleService/CModuleServiceProtocol.h>
#import <JDModuleService/BModuleServiceProtocol.h>
#import <JDModuleService/AModuleServiceProtocol.h>
#import <JDModuleService/DModuleServiceProtocol.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"github demo";

    id<AModuleServiceProtocol> protocolA = [[JDModuleServeManager oneInstance] serviceOfProtocol:@protocol(AModuleServiceProtocol)];
    if (protocolA) {
        UIButton *openA1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 200, 50)];
        [self.view addSubview:openA1];
        [openA1 setTitle:@"A 模块" forState:UIControlStateNormal];
        [openA1 setBackgroundColor:[UIColor colorNamed:@"CommonOperationColor"]];
        [openA1 addTarget:self action:@selector(openA1Action) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    id<BModuleServiceProtocol> protocolB = [[JDModuleServeManager oneInstance] serviceOfProtocol:@protocol(BModuleServiceProtocol)];
    if (protocolB) {
        UIButton *openBServie = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, 200, 50)];
        [self.view addSubview:openBServie];
        [openBServie setTitle:@"B 模块" forState:UIControlStateNormal];
        [openBServie setBackgroundColor:[UIColor colorNamed:@"CommonOperationColor"]];
        [openBServie addTarget:self action:@selector(openBServiceAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    id<CModuleServiceProtocol> protocolC = [[JDModuleServeManager oneInstance] serviceOfProtocol:@protocol(CModuleServiceProtocol)];
    if (protocolC) {
        UIButton *openC1Servie = [[UIButton alloc] initWithFrame:CGRectMake(0, 300, 200, 50)];
        [self.view addSubview:openC1Servie];
        [openC1Servie setTitle:@"C 模块" forState:UIControlStateNormal];
        [openC1Servie setBackgroundColor:[UIColor colorNamed:@"CommonOperationColor"]];
        [openC1Servie addTarget:self action:@selector(openC1ServiceAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    id<DModuleServiceProtocol> protocolD = [[JDModuleServeManager oneInstance] serviceOfProtocol:@protocol(DModuleServiceProtocol)];
    if (protocolD) {
        UIButton *openC1Servie = [[UIButton alloc] initWithFrame:CGRectMake(0, 400, 200, 50)];
        [self.view addSubview:openC1Servie];
        [openC1Servie setTitle:@"github demo" forState:UIControlStateNormal];
        [openC1Servie setBackgroundColor:[UIColor colorNamed:@"CommonOperationColor"]];
        [openC1Servie addTarget:self action:@selector(openDRouterAction) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)openA1Action {
    [[JDRouterManager oneInstance] openRouter:kARouter1 withParams:@{}];
}

- (void)openBServiceAction {
    [[JDRouterManager oneInstance] openRouter:kBRouter1 withParams:@{}];
}

- (void)openC1ServiceAction {
    id<CModuleServiceProtocol> protocol = [[JDModuleServeManager oneInstance] serviceOfProtocol:@protocol(CModuleServiceProtocol)];
    [protocol cService1];
}

- (void)openDRouterAction {
    id<DModuleServiceProtocol> protocol = [[JDModuleServeManager oneInstance] serviceOfProtocol:@protocol(DModuleServiceProtocol)];
    [protocol dService1];
}

@end
