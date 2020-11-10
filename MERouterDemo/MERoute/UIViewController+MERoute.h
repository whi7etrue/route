//
//  UIViewController+MERoute.h
//  METestRoute
//
//  Created by 陈建才 on 2018/5/12.
//  Copyright © 2018年 mmear. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MERouteRequest;

@interface UIViewController (MERoute)

@property (nonatomic ,strong) MERouteRequest *receiveMessage;

@end
