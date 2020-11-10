//
//  MERouteProperty.h
//  MagicEars_student_ipad
//
//  Created by wangshuguang on 2018/7/6.
//  Copyright © 2018年 mmear. All rights reserved.
//

#ifndef MERouteProperty_h
#define MERouteProperty_h

// MEAboutClassController
/**
 约课类

 @return BackBlock
 */
#define BackBlock @"backBlcok"


#pragma mark -  MEInCourseVC

/**
 进入课堂回调

 @return 回调的block
 */
#define JoinClassroomErrorBlock @"jionClassroomErrorBlock"

/**
 重启教室回调

 @return restartClassroomActionBlock
 */
#define RestartClassroomActionBlock @"restartClassroomActionBlock"

/**
 进入课堂是否成功

 @return bool YES NO
 */
#define IsJionClassFinish @"isJionClassFinish"

#endif /* MERouteProperty_h */
