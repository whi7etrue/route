//
//  ViewController.m
//  MERouterDemo
//
//  Created by 陈建才 on 2018/11/30.
//  Copyright © 2018年 mmear. All rights reserved.
//

#import "ViewController.h"
#import "MERouteHeader.h"

static NSInteger classIndex;

@interface ViewController ()

@property (nonatomic ,assign) NSInteger currentIndex;

@property (nonatomic ,strong) UIButton *pushButton;

@end

@implementation ViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.testStr = @"ViewController";
        
        classIndex ++;
        
        self.currentIndex = classIndex;
    }
    return self;
}

-(NSString *)indexClassName{
    
    return [NSString stringWithFormat:@"%@_%zd",NSStringFromClass([self class]),self.currentIndex];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    pushBtn.frame = CGRectMake(0, 300, 200, 50);
    pushBtn.center = CGPointMake(self.view.center.x, self.view.center.y-50);
    
    [pushBtn setTitle:@"push" forState:UIControlStateNormal];
    
    pushBtn.backgroundColor = [UIColor greenColor];
    
    [pushBtn addTarget:self action:@selector(pushButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.pushButton = pushBtn;
    [self.view addSubview:pushBtn];
}

-(void)pushButtonDidClick{
    
    [[MERoute shareRoute] routeHandleWithType:MERouteActionType_push targetName:MRRedViewController action:nil prama:nil andCallBack:nil];
}

-(void)dealloc{
    
    NSLog(@"dealloc : %@",NSStringFromClass([self class]));
}

@end
