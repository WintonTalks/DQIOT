//
//  DeviceTypeModel.h
//  WebThings
//
//  Created by machinsight on 2017/7/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//  设备型号

#import <Foundation/Foundation.h>
//型号id:modelid
//型号名称:model

@interface DeviceTypeModel : NSObject
@property (nonatomic, assign) NSInteger modelid;
@property (nonatomic, copy) NSString *model;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, copy) NSString *brand;

// 概览接口新增
@property (nonatomic, assign) NSInteger deviceid;       // 设备id
@property (nonatomic, copy) NSString *deviceno;         // 设备名
@property (nonatomic, assign) NSInteger detailstate;    // 状态
@property (nonatomic, copy) NSString *installationsite; // 设备安装地点
@property (nonatomic, copy) NSString *state;            // 设备阶段
@property (nonatomic, copy) NSString *fidstate;         // 主状态阶段
@property (nonatomic, copy) NSString *statedesc;        // 设备阶段说明
@property (nonatomic, copy) NSString *price;            // 租赁价格
@property (nonatomic, copy) NSString *beforehanddate;   // 预安装时间
@property (nonatomic, copy) NSString *high;             // 安装高度
@property (nonatomic, copy) NSString *handdate;         // 安装时间
@property (nonatomic, copy) NSString *starttime;        // 使用时间
@property (nonatomic, copy) NSString *iswarn;           // 是否告警，接口返回数据
@property (nonatomic, assign) BOOL isreport;            // 是否有日报
@property (nonatomic, copy) NSString *runtime;          // 运行时间

// 自定义属性，方便实用
@property (nonatomic, assign) BOOL isWarning;           

@end
