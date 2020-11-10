//
//  MERoute.m
//  METestRoute
//
//  Created by 陈建才 on 2018/6/29.
//  Copyright © 2018年 mmear. All rights reserved.
//

#import "MERoute.h"
#import "MECommonViewController.h"
#import "MECommonView.h"
#import "MECommonModule.h"
#import "MERouteRequest.h"
#import "UIViewController+MERoute.h"

@interface MERoute ()

//strongToWeakObjectsMapTable       键值对是strong的  值是weak
//strongToStrongObjectsMapTable     键值对是strong的  值是strong
//weakToStrongObjectsMapTable       键值对是weak的  值是strong
//weakToWeakObjectsMapTable         键值对是weak的  值是weak
//键值对是weak时  键值对不会再table中保存    值为weak时  table不会对值强引用
//控制器的存储池
@property (nonatomic ,strong) NSMapTable *viewControllerCaches;

//view的存储池
@property (nonatomic ,strong) NSMapTable *viewCaches;

//模块的存储池
@property (nonatomic ,strong) NSMapTable *moduleCaches;

//请求的存储池  用于存储需要回调的请求
@property (nonatomic ,strong) NSMapTable *routeRequestCaches;

//用于对实例进行强引用   不需要的时候 需要调用cacheObjectRemoveWithID 移出  ID就是类名
@property (nonatomic ,strong) NSMapTable *getObjectHandleCaches;

@property (nonatomic ,weak) UIViewController *presentIngViewController;

@end

@implementation MERoute

+(instancetype)shareRoute{
    
    static MERoute *shareServe = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareServe = [[MERoute alloc] init];
        
//        shareServe.viewCaches = [NSMapTable strongToWeakObjectsMapTable];
//        shareServe.moduleCaches = [NSMapTable strongToWeakObjectsMapTable];
        shareServe.viewControllerCaches = [NSMapTable strongToWeakObjectsMapTable];
        shareServe.routeRequestCaches = [NSMapTable strongToStrongObjectsMapTable];
        shareServe.getObjectHandleCaches = [NSMapTable strongToStrongObjectsMapTable];
    });
    return shareServe;
}

-(void)addObject:(id)object{
    
    NSString *key = NSStringFromClass([object class]);
    
    [self.viewControllerCaches setObject:object forKey:key];
}

-(void)removeObject:(id)object{
    
    NSString *key = NSStringFromClass([object class]);
    [self.viewControllerCaches removeObjectForKey:key];
}

-(void)addObject:(id)object withId:(NSString *)ID{
    
    [self.viewControllerCaches setObject:object forKey:ID];
}

-(void)removeObject:(id)object withId:(NSString *)ID{
    
    [self.viewControllerCaches removeObjectForKey:ID];
}

- (id)queryObjectWithClassName:(NSString *)className {
    if (className.length == 0) {
        assert("className not nil");
        return nil;
    }
    return [self.viewControllerCaches objectForKey:className];
}

-(id)routeHandleWithType:(MERouteActionType)type targetName:(NSString *)targetName action:(NSString *)action prama:(id)prama andCallBack:(void(^)(id response))callBack{
    
    Class cla = NSClassFromString(targetName);
    
    if (!cla) {
        
        NSLog(@"class name is not correct");
        
        return nil;
    }
    
    MERouteRequestType requestType = MERouteRequestType_controller;
    
    MERouteRequest *request = [[MERouteRequest alloc] initWithRequestType:requestType ActionType:type targetName:targetName action:action prama:prama andCallBack:callBack];
    
//    if (callBack) {
//        [self.routeRequestCaches setObject:request forKey:request.requestID];
//    }
    
    return [self handleRequest:request];
}

-(id)handleRequest:(MERouteRequest *)request{
    
    switch (request.actionType) {
        case MERouteActionType_push:{
            
            return [self controllerPushSwitchWithType:request withAnimation:YES];
        }
            break;
            
        case MERouteActionType_pushNoanimation:{
            
            return [self controllerPushSwitchWithType:request withAnimation:NO];
        }
            break;
            
        case MERouteActionType_present:{
            
            return [self controllerPresentSwitchWithType:request withAnimation:YES];
        }
            break;
            
        case MERouteActionType_presentNavigation:{
            
            return [self controllerPresentSwitchWithType:request withAnimation:YES];
        }
            break;
            
        case MERouteActionType_action:{
            
            return [self objectResponseAction:request];
        }
            break;
            
        case MERouteActionType_getObject:{
            
            return [self getObjectWithRequest:request];
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}

-(id)getObjectWithRequest:(MERouteRequest *)request{
    
    UIViewController *targetVC;
    
    targetVC = (UIViewController *)[self.viewControllerCaches objectForKey:request.targetName];
    
    if (!targetVC) {
        
        targetVC = [self classInitWithRequest:request];
    }
    
    [self.getObjectHandleCaches setObject:targetVC forKey:request.targetName];
    
    NSLog(@"getObjectHandleCaches --%@",self.getObjectHandleCaches);
    
    return targetVC;
}

-(id)classInitWithRequest:(MERouteRequest *)request{
    
    Class cla = NSClassFromString(request.targetName);
    
    UIViewController *object;
    
    if ([cla conformsToProtocol:@protocol(MEViewControllerInitDelegate)]) {
        
        object = [[cla alloc] initWithPrama:request];
        
        object.receiveMessage = request;
        
    }else{
        
        object = [[cla alloc] init];
        
        object.receiveMessage = request;
    }
    
    return object;
}

-(void)cacheObjectRemoveWithID:(NSString *)ID{
    
    [self.getObjectHandleCaches removeObjectForKey:ID];
    
    if ([self.routeRequestCaches objectForKey:ID]) {
        
        [self.routeRequestCaches removeObjectForKey:ID];
    }
    
    NSLog(@"getObjectHandleCaches --%@",self.getObjectHandleCaches);
}

-(id)controllerPushSwitchWithType:(MERouteRequest *)request withAnimation:(BOOL)animation{
    
    if (request.requestType != MERouteRequestType_controller) {
        
        NSLog(@"switch object is not controller");
        
        return nil;
    }
    
    BOOL isExist = YES;
    UIViewController *targetVC;
    
    targetVC = (UIViewController *)[self.viewControllerCaches objectForKey:request.targetName];
    
    if (!targetVC) {
        
        isExist = NO;
        
        targetVC = [self classInitWithRequest:request];
    }
    
    if (isExist) {
        
        BOOL findTarget = NO;
        NSInteger vcIndex = 0;
        
        for (int i = 0; i< self.naviVC.viewControllers.count; i++) {
            
            UIViewController *tempVC = self.naviVC.viewControllers[i];
            
            if (tempVC == targetVC) {
                
                findTarget = YES;
                vcIndex = i;
            }
            
            if (findTarget) {
                
                if (i > vcIndex) {
                    
                    NSString *VCName = NSStringFromClass([tempVC class]);
                    
                    NSLog(@"pop viewcontroller dealloc : %@",VCName);
                    
                    [self.viewControllerCaches removeObjectForKey:VCName];
                }
            }
        }
        
        [self.naviVC popToViewController:targetVC animated:animation];
        
    }else{
        
        [self.naviVC pushViewController:targetVC animated:animation];
    }
    
    return nil;
}

-(id)controllerPresentSwitchWithType:(MERouteRequest *)request withAnimation:(BOOL)animation{
    
    if (request.requestType != MERouteRequestType_controller) {
        
        NSLog(@"switch object is not controller");
        
        return nil;
    }
    
    BOOL isExist = YES;
    UIViewController *targetVC;
    
    targetVC = (UIViewController *)[self.viewControllerCaches objectForKey:request.targetName];
    
    if (!targetVC) {
        
        isExist = NO;
        
        targetVC = [self classInitWithRequest:request];
        
        if (request.actionType == MERouteActionType_presentNavigation) {
            
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:targetVC];
            
            targetVC = navi;
        }
    }
    
    if (isExist) {
        
        [targetVC dismissViewControllerAnimated:animation completion:nil];
    }else{
        
        if (self.presentIngViewController) {
            
            if ([self.presentIngViewController isKindOfClass:[UINavigationController class]]) {
                
                NSLog(@"dont support navigation continue present");
                
                return nil;
            }
            
            [self.presentIngViewController presentViewController:targetVC animated:YES completion:^{
                
                self.presentIngViewController = targetVC;
            }];
        }else{
            
            UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
            
            UIViewController *presentVC = rootVC.presentedViewController;
            
            if (!presentVC) {
                
                [rootVC presentViewController:targetVC animated:animation completion:^{
                    
                    self.presentIngViewController = targetVC;
                }];
            }else{
                
                while (1) {
                    
                    UIViewController *tempVC = presentVC.presentedViewController;
                    
                    if (tempVC) {
                        
                        presentVC = presentVC.presentedViewController;
                        
                    }else{
                        
                        break;
                    }
                }
                
                [presentVC presentViewController:targetVC animated:animation completion:^{
                    
                    self.presentIngViewController = targetVC;
                }];
            }
        }
    }
    
    return nil;
}

-(id)objectResponseAction:(MERouteRequest *)request{
    
    SEL sele = NSSelectorFromString(request.actionName);
    
    BOOL isExist = NO;
    id object;
    
    if (request.requestType == MERouteRequestType_controller) {
        
        object = [self.viewControllerCaches objectForKey:request.targetName];
        
        if (object) {
            
            isExist = YES;
        }
    }else if (request.requestType == MERouteRequestType_view) {
        
        object = [self.viewCaches objectForKey:request.targetName];
        
        if (object) {
            
            isExist = YES;
        }
    }else if (request.requestType == MERouteRequestType_module) {
        
        object = [self.moduleCaches objectForKey:request.targetName];
        
        if (object) {
            
            isExist = YES;
        }
    }
    
    if (isExist) {
        
        return [self safePerformAction:sele target:object params:request.prama];
    }else{
        
        //调用不存在对象的方法  处理方法由业务决定
        NSLog(@"object has not creat");
        
//        Class cla = NSClassFromString(request.targetName);
//
//        //暂时写死初始化方法
//        object = [[cla alloc] init];
//
//        return [self safePerformAction:sele target:object params:request.prama];
    }
    
    return nil;
}

- (id)safePerformAction:(SEL)action target:(NSObject *)target params:(id)params
{
    NSMethodSignature* methodSig = [target methodSignatureForSelector:action];
    if(methodSig == nil) {
        return nil;
    }
    const char* retType = [methodSig methodReturnType];
    
    if (strcmp(retType, @encode(void)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:methodSig.numberOfArguments-1];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        return nil;
    }
    
    if (strcmp(retType, @encode(NSInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:methodSig.numberOfArguments-1];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(BOOL)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:methodSig.numberOfArguments-1];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        BOOL result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(CGFloat)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:methodSig.numberOfArguments-1];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        CGFloat result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(NSUInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:methodSig.numberOfArguments-1];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
}

-(void)recevieCallBackWith:(NSString *)Id withResponse:(id)response idDele:(BOOL)dele{
    
    MERouteRequest *request = [self.routeRequestCaches objectForKey:Id];
    
    if (request) {
        
        if (request.returnHandle) {
            
            if (dele) {
                
                [self.routeRequestCaches removeObjectForKey:Id];
            }
            
            NSLog(@"routeRequestCaches----%@",self.routeRequestCaches);
            
            request.returnHandle(response);
        }
    }
}

-(id)routeGetPropertyWithTargetName:(NSString *)targetName propretyName:(NSString *)propretyName{
    
    Class cla = NSClassFromString(targetName);
    
    if (!cla) {
        
        NSLog(@"class name is not correct");
        
        return nil;
    }
    
    id object = [self.viewControllerCaches objectForKey:targetName];
    
    SEL sele = NSSelectorFromString(propretyName);
    
    if (object) {
        
        return [self safePerformAction:sele target:object params:nil];
    }else{
        
        //调用不存在对象的方法  处理方法由业务决定
        
        NSLog(@"object has not creat");

        return nil;
    }
}

-(void)routeSetPropertyWithTargetName:(NSString *)targetName propretyName:(NSString *)propretyName and:(id)proprety{
    
    [self routeBlockHandleWithTargetName:targetName blockName:propretyName and:proprety];
}

-(void)routeBlockHandleWithTargetName:(NSString *)targetName blockName:(NSString *)blockName and:(id)handle{
    
    Class cla = NSClassFromString(targetName);
    
    if (!cla) {
        
        NSLog(@"class name is not correct");
        
        return;
    }
    
    id object = [self.viewControllerCaches objectForKey:targetName];
    
    blockName = [self firstCharUppercaseString:blockName];
    
    NSString *methodName = [NSString stringWithFormat:@"set%@:",blockName];
    
    SEL sele = NSSelectorFromString(methodName);
    
    if (object) {
        
        if ([handle isKindOfClass:[NSNumber class]]) {
            
            [self SetPropertyAction:sele target:object params:handle];
        }else{
            
            [self safePerformAction:sele target:object params:handle];
        }
        
    }else{
        
        //调用不存在对象的方法  处理方法由业务决定
        
        NSLog(@"object has not creat");
//        Class cla = NSClassFromString(targetName);
//
//        暂时写死初始化方法
//        object = [[cla alloc] init];
//
//        if ([handle isKindOfClass:[NSNumber class]]) {
//
//            [self SetPropertyAction:sele target:object params:handle];
//        }else{
//
//            [self safePerformAction:sele target:object params:handle];
//        }
    }
}

- (void)SetPropertyAction:(SEL)action target:(NSObject *)target params:(id)params
{
    NSMethodSignature* methodSig = [target methodSignatureForSelector:action];
    if(methodSig == nil) {
        return ;
    }
    
    const char* argument = [methodSig getArgumentTypeAtIndex:2];
    
    if (strcmp(argument, @encode(BOOL)) == 0) {
        
        NSNumber *number = (NSNumber *)params;
        
        BOOL index = number.boolValue;
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&index atIndex:methodSig.numberOfArguments-1];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        
        return;
    }
    
    if (strcmp(argument, @encode(NSInteger)) == 0) {
        
        NSNumber *number = (NSNumber *)params;
        
        NSInteger index = number.integerValue;
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&index atIndex:methodSig.numberOfArguments-1];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        
        return;
    }
    
    if (strcmp(argument, @encode(CGFloat)) == 0) {
        
        NSNumber *number = (NSNumber *)params;
        
        CGFloat index = number.floatValue;
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&index atIndex:methodSig.numberOfArguments-1];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        
        return;
    }
    
    if (strcmp(argument, @encode(int)) == 0) {
        
        NSNumber *number = (NSNumber *)params;
        
        int index = number.intValue;
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&index atIndex:methodSig.numberOfArguments-1];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        
        return;
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [target performSelector:action withObject:params];
#pragma clang diagnostic pop
    
}

-(NSString *)firstCharUppercaseString:(NSString *)str{
    
    NSString *first = [str substringWithRange:NSMakeRange(0, 1)];
    
    NSString *left = [str substringFromIndex:1];
    
    first = [first uppercaseString];
    
    return [NSString stringWithFormat:@"%@%@",first,left];
}

@end
