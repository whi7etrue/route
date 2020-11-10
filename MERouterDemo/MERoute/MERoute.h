//
//  MERoute.h
//  METestRoute
//
//  Created by 陈建才 on 2018/6/29.
//  Copyright © 2018年 mmear. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UINavigationController,MERouteRequest;

@protocol MEViewControllerInitDelegate <NSObject>

@optional
-(instancetype)initWithPrama:(MERouteRequest *)prama;

@end

typedef NS_ENUM(NSUInteger, MERouteActionType) {
    MERouteActionType_push,           // push 默认有动画
    MERouteActionType_pushNoanimation, // push 没有动画
    MERouteActionType_present,          // present 有动画 不带导航栏
    MERouteActionType_presentNavigation, // present 有动画 带导航栏
    MERouteActionType_action,            // 不跳转 调用方法
    MERouteActionType_getObject,        //不跳转 获取类 如果没有创建
};

@interface MERoute : NSObject

+(instancetype)shareRoute;

//用于跳转  如果根控制器是tabbarController 切换item的时候 更换naviVC
@property (nonatomic ,weak) UINavigationController *naviVC;

//以类名作为key  以类的实例对象作为值   只考虑route中的对象是单一的情况  如果类有多个实例  通过继承 生成多个子类 达成多个实例的过程
-(void)addObject:(id)object;
-(void)removeObject:(id)object;

//多个实例需要通过route解耦时  可以自己将实例的生命周期加到route中
-(void)addObject:(id)object withId:(NSString *)ID;
-(void)removeObject:(id)object withId:(NSString *)ID;

/**
 根据类名查找类对象

 @param className 类名
 @return 类对象
 */
-(id)queryObjectWithClassName:(NSString *)className;

-(void)cacheObjectRemoveWithID:(NSString *)ID;

-(id)routeHandleWithType:(MERouteActionType)type targetName:(NSString *)targetName action:(NSString *)action prama:(id)prama andCallBack:(void(^)(id response))callBack;

-(void)recevieCallBackWith:(NSString *)Id withResponse:(id)response idDele:(BOOL)dele;

//给实例的属性赋值   block是一种特殊的属性
-(void)routeSetPropertyWithTargetName:(NSString *)targetName propretyName:(NSString *)propretyName and:(id)proprety;
-(void)routeBlockHandleWithTargetName:(NSString *)targetName blockName:(NSString *)blockName and:(id)handle;

/**
 获取setter方法

 @param targetName 类 name
 @param propretyName 属性 name
 @return getter方法的返回值 返回值是OC对象
 */
-(id)routeGetPropertyWithTargetName:(NSString *)targetName propretyName:(NSString *)propretyName;

@end
