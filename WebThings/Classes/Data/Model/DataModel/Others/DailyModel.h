//
//  DailyModel.h
//  WebThings
//
//  Created by machinsight on 2017/7/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CheckModel.h"
//data:[{
//    检查项目的类型:checktype
//    状态：checkstate
//}]
//reportid:日报id
//是否已读:isread//已读、未读
//设备安全情况:safestate 0安全 ，其他数字代表几个故障
//载重量:deadweight
//累积工作时间:workingtime
@interface DailyModel : NSObject
@property (nonatomic, strong) NSArray <CheckModel *> *data;
@property (nonatomic, assign) NSInteger reportid;
@property (nonatomic, strong) NSString *isread;
@property (nonatomic, assign) NSInteger safestate;
@property (nonatomic, assign) double deadweight;
@property (nonatomic, strong) NSString *workingtime;
@property (nonatomic, strong) NSString *date;
@end
