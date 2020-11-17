//
//  RedViewController.m
//  MERouterDemo
//
//  Created by 陈建才 on 2018/11/30.
//  Copyright © 2018年 mmear. All rights reserved.
//

#import "RedViewController.h"
#import "MERouteHeader.h"

typedef void(^testHandle)(void);

@interface RedViewController ()

@property (nonatomic ,strong) UIButton *pushButton;

@property (nonatomic ,copy) testHandle handle;

@property (nonatomic ,assign) int index;

@end

@implementation RedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor redColor];
    
    UIButton *pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    pushBtn.frame = CGRectMake(0, 300, 200, 50);
    pushBtn.center = CGPointMake(self.view.center.x, self.view.center.y-50);
    
    [pushBtn setTitle:@"push" forState:UIControlStateNormal];
    
    pushBtn.backgroundColor = [UIColor greenColor];
    
    [pushBtn addTarget:self action:@selector(pushButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.pushButton = pushBtn;
    [self.view addSubview:pushBtn];
    
    self.handle = ^{
        
        [self.pushButton setTitle:@"cycle push" forState:UIControlStateNormal];
        
    };
    
}

-(void)testAction:(NSInteger)a{
    NSLog(@"route use string action : %d",a);
}

-(void)pushButtonDidClick{
    
    [[MERoute shareRoute] routeHandleWithType:MERouteActionType_push targetName:MROrangerViewController action:nil prama:nil andCallBack:nil];
}

-(void)dealloc{
    
    NSLog(@"dealloc : %@",NSStringFromClass([self class]));
}

@end
