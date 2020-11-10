//
//  MERouteMethod.h
//  MagicEars_student_ipad
//
//  Created by wangshuguang on 2018/7/6.
//  Copyright © 2018年 mmear. All rights reserved.
//

#ifndef MERouteMethod_h
#define MERouteMethod_h

#pragma mark - MECourseSyllabusVC

#define AppEnterBackgroundSyllabusHandler @"appEnterBackgroundSyllabusHandler"

#pragma mark - MEInCourseVC

#define LeaveChannelAndDismissController @"leaveChannelAndDismissController"

/**
 取消进入课堂

 @return canceJionClassroom
 */
#define CanceJoinClassroom @"canceJionClassroom"

/**
 preview进入课堂

 @return jionClassFromProviewWithParam
 */
#define JoinClassFromPreviewWithParam @"jionClassFromProviewWithParam:"

/**
 取消注册一分钟倒计时事件

 @return cancelActionClosePerformSelector
 */
#define CancelActionClosePerformSelector @"cancelActionClosePerformSelector"

#pragma mark - MECoureListVC

/**
 刷新课表

 @return reloadData
 */
#define ReloadData @"refreshButtonClick"

#define RegisterCourseAction @"registerCourseMarkAction:"

#define ShowCourseLoadingViewWithDict   @"showCourseLoadingViewWithDict:"

#endif /* MERouteMethod_h */
