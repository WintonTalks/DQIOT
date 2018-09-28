//
//  DeviceProjectModel.h
//  WebThings
//
//  Created by machinsight on 2017/7/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//  新增设备

//{
//    用户id:userid
//    用户类型:type
//    usertype
//data:[{
//    项目id:projectid
//    租赁价格:price
//    设备品牌:brand
//    设备型号:modelid
//    预埋安装时间:beforehanddate
//    安装高度:high
//    安装时间:handdate
//    安装地点:address
//    使用时间:starttime
//    设备ID：deviceid
//}]
//}

#import <Foundation/Foundation.h>

@interface DeviceProjectModel : NSObject
@property (nonatomic, assign) NSInteger userid;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *usertype;
@property (nonatomic, assign) NSInteger projectid;

@property (nonatomic, strong) NSArray *data;
@end
