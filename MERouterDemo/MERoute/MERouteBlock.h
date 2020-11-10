//
//  MEBlock.h
//  MagicEars_student_ipad
//
//  Created by wangshuguang on 2018/7/4.
//  Copyright © 2018年 mmear. All rights reserved.
//

#ifndef MEBlock_h
#define MEBlock_h

typedef void(^MERetryBloak)(void);

typedef void(^MEJionClassroomErrorBlock)(MEJionClassState state,BOOL isNetWork,MERetryBloak retryBlock);


#endif /* MEBlock_h */
