//
//  ViewController.m
//  JDModuleShow
//
//  Created by Mac on 2022/5/14.
//

#import "ViewController.h"
#import <JDModuleManager/JDRouterManager.h>
#import <JDModuleManager/JDModuleServeManager.h>
#import "Router.h"
#import "AModuleServiceProtocol.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *openA1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 200, 50)];
    [self.view addSubview:openA1];
    [openA1 setTitle:@"open A1 router" forState:UIControlStateNormal];
    [openA1 setBackgroundColor:[UIColor redColor]];
    [openA1 addTarget:self action:@selector(openA1Action) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *openA1Servie = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, 200, 50)];
    [self.view addSubview:openA1Servie];
    [openA1Servie setTitle:@"call A1 service" forState:UIControlStateNormal];
    [openA1Servie setBackgroundColor:[UIColor redColor]];
    [openA1Servie addTarget:self action:@selector(openA1ServiceAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)openA1Action {
    [[JDRouterManager oneInstance] openRouter:kARouter1 withParams:@{}];
}

- (void)openA1ServiceAction {
    id<AModuleServiceProtocol> service = [[JDModuleServeManager oneInstance] serviceOfProtocol:@protocol(AModuleServiceProtocol)];
    [service aService1];
    
}

@end
