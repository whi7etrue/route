//
//  MERouteRequest.h
//  METestRoute
//
//  Created by 陈建才 on 2018/6/29.
//  Copyright © 2018年 mmear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MERoute.h"

typedef NS_ENUM(NSUInteger, MERouteRequestType) {
    MERouteRequestType_controller,
    MERouteRequestType_view,
    MERouteRequestType_module,
};

typedef void(^MERouteReturnHandle)(id prama);

@interface MERouteRequest : NSObject

@property (nonatomic ,assign) MERouteRequestType requestType;

@property (nonatomic ,assign) MERouteActionType actionType;

@property (nonatomic ,copy) NSString *requestID;

@property (nonatomic ,copy) NSString *targetName;

@property (nonatomic ,weak) id target;

@property (nonatomic ,assign) BOOL isExist;

@property (nonatomic ,copy) NSString *actionName;

@property (nonatomic ,strong) id prama;

@property (nonatomic ,copy) MERouteReturnHandle returnHandle;

-(instancetype)initWithRequestType:(MERouteRequestType)requestType ActionType:(MERouteActionType)actionType targetName:(NSString *)targetName action:(NSString *)action prama:(NSDictionary *)prama andCallBack:(void(^)(id response))callBack;

@end
