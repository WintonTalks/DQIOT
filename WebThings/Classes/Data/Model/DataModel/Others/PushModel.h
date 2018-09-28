//
//  PushModel.h
//  WebThings
//
//  Created by machinsight on 2017/8/12.
//  Copyright © 2017年 machinsight. All rights reserved.
//  推送实体

#import <Foundation/Foundation.h>

@interface PushModel : NSObject
@property (nonatomic, assign) NSInteger projectid;//":项目id
@property (nonatomic, assign) NSInteger projectdeviceid;//":
@property (nonatomic, assign) NSInteger deviceid;//":"设备ID"
@property (nonatomic, assign) NSInteger state;//":""//故障的话值为99，其他事根据服务流各自状态，如果有其他可再另加值
@property (nonatomic, strong) NSString *title;//":"标题"，
@property (nonatomic, strong) NSString *msg;//":"消息内容"，
@property (nonatomic, strong) NSString *time;//":时间
@property (nonatomic, assign) NSInteger devicewarnid;//":故障单ID
@property (nonatomic, strong) NSArray *ivedata;//":[data1,data2]//小维分析数据
@property (nonatomic, strong) NSString *deviceno;//”：“”
@property (nonatomic, strong) NSString *address;//”：“”
@property (nonatomic, strong) NSString *warnname;//“：“”

@property (nonatomic, strong) NSString *drivertype;//司机类型

@property (nonatomic, strong) NSString *usertype;
@end
