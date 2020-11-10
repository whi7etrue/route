//
//  MEEnum.h
//  MagicEars_student_ipad
//
//  Created by wangshuguang on 2018/7/3.
//  Copyright © 2018年 mmear. All rights reserved.
//

#ifndef MEEnum_h
#define MEEnum_h

#pragma mark - 课堂状态

typedef NS_ENUM(NSInteger,MEJionClassState) {
    MEJionClassState_loadCourseError = 0,//课件加载失败,声网初始化失败
    MEJionClassState_getClassroomTokenError = 1,//获取课堂信息失败
    MEJionClassState_getClassroomStateError = 2,//获取课堂内所有人动作失败
    MEJionClassState_jionClassroomSuccess = 3,//进入教室成功
    MEJionClassState_WSConnectError = 4,//WS连接失败
    MEJionClassState_getClassroomTokenSuccess = 5,//获取课堂信息成功
    MEJionClassState_getClassroomStateSuccess = 6//获取课堂状态信息成功
};

#endif /* MEEnum_h */
