//
//  MECommonViewController.m
//  MagicEars_student
//
//  Created by 陈建才 on 2017/11/18.
//  Copyright © 2017年 陈建才. All rights reserved.
//

#import "MECommonViewController.h"
#import "MERoute.h"

@interface MECommonViewController ()

@end

@implementation MECommonViewController

- (instancetype)init {
    if (self = [super init]) {
        [[MERoute shareRoute] addObject:self];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"class %@",NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"class %@",NSStringFromClass([self class]));
    
}

- (BOOL)shouldAutorotate{
    //是否允许转屏
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //viewController所支持的全部旋转方向
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    //viewController初始显示的方向
//    return UIDeviceOrientationLandscapeRight;
//}

-(void)dealloc{
    
    [[MERoute shareRoute] removeObject:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
