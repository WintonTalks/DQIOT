//
//  ProjectStartRentHistoryModel.h
//  WebThings
//
//  Created by machinsight on 2017/8/4.
//  Copyright © 2017年 machinsight. All rights reserved.
//  设备启租

#import <Foundation/Foundation.h>

@interface ProjectStartRentHistoryModel : NSObject
@property (nonatomic, assign) NSInteger ID;//": 5,
@property (nonatomic, assign) NSInteger projectstartrentid;//": 17,
@property (nonatomic, strong) NSString  *deviceno;//": "ST0003",
@property (nonatomic, assign) NSInteger projectid;//": 1,
@property (nonatomic, assign) NSInteger projcetdeviceid;//": 11,
@property (nonatomic, strong) NSString  *chargeperson;//": "赵永飞",
@property (nonatomic, strong) NSString  *linkman;//": "18921676125",
@property (nonatomic, strong) NSString  *startdate;//": "2017/07/31 04:46:00",
@property (nonatomic, strong) NSString  *recordno;//": "001",
@property (nonatomic, strong) NSString  *checkcompany;//": "jiangsu",
@property (nonatomic, assign) NSInteger checkcompanyorgid;//": 0,
@property (nonatomic, strong) NSString  *chckreportid;//": "001001"
@end
