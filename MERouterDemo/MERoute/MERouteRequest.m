//
//  MERouteRequest.m
//  METestRoute
//
//  Created by 陈建才 on 2018/6/29.
//  Copyright © 2018年 mmear. All rights reserved.
//

#import "MERouteRequest.h"

@implementation MERouteRequest

-(instancetype)initWithRequestType:(MERouteRequestType)requestType ActionType:(MERouteActionType)actionType targetName:(NSString *)targetName action:(NSString *)action prama:(NSDictionary *)prama andCallBack:(void(^)(id response))callBack{
    
    if (self == [super init]) {
        
        self.requestID = [NSString stringWithFormat:@"%@%@",targetName,action];
        self.requestType = requestType;
        self.actionType = actionType;
        self.targetName = targetName;
        self.actionName = action;
        self.prama = prama;
        self.returnHandle = callBack;
    }
    
    return self;
}

@end
