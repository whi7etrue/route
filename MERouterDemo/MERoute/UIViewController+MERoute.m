//
//  UIViewController+MERoute.m
//  METestRoute
//
//  Created by 陈建才 on 2018/5/12.
//  Copyright © 2018年 mmear. All rights reserved.
//

#import "UIViewController+MERoute.h"
#import <objc/runtime.h>
#import "MERouteRequest.h"

@implementation UIViewController (MERoute)

-(MERouteRequest *)receiveMessage{
    
    MERouteRequest * dict = objc_getAssociatedObject(self, "receiveMessage");
    return dict;
}

-(void)setReceiveMessage:(MERouteRequest *)receiveMessage{
    
    objc_setAssociatedObject(self, "receiveMessage", receiveMessage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
