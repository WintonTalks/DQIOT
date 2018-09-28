//
//  DQAddProjectModel.h
//  WebThings
//
//  Created by 孙文强 on 2017/9/17.
//  Copyright © 2017年 machinsight. All rights reserved.
//  新增项目-设备型号model

#import <Foundation/Foundation.h>
@class DQDeviceModel;
@class DQSecondDeviceModel;

@interface DQAddProjectModel : NSObject
@property (nonatomic, strong) NSString *brand;
@property (nonatomic, strong) NSMutableArray<DQDeviceModel *>* deviceArray;
@property (nonatomic, strong) NSMutableArray<DQSecondDeviceModel *>* secondArray;
@end

//设备ID
@interface DQDeviceModel : NSObject
@property (nonatomic, assign) NSInteger deviceid;
@property (nonatomic, strong) NSString *deviceno;

@end

//设备型号
@interface DQSecondDeviceModel : NSObject
@property (nonatomic, strong) NSString *brand;
@property (nonatomic, strong) NSString *model;
@property (nonatomic, assign) NSInteger deviceID;
@property (nonatomic, assign) NSInteger orgid;

@end


