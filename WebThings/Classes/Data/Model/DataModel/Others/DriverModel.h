//
//  DriverModel.h
//  WebThings
//
//  Created by machinsight on 2017/7/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//  司机信息

#import <Foundation/Foundation.h>

/*
 ”userid”:”用户id”,
 ”type”:”用户类型”,
 “usertype”:””,
 “projectid”:“项目id”,
 
 ---------------------------
 “data”:{
 “name”:”姓名”,
 “sex”:”性别”,
 “no”:”编号”,
 “age”:” 年龄”,
 “dn”:”手机号码”,
 “idcard”:”身份证号”,
 “workcategory”:”工种”，
 “workcategoryid”:”工种ID”,
 “entertime”:”进驻项目时间”,
 “notes”:”备注”,
 “renttype”:”工资类型,月工资\包干工资”,
 “rent”:”工资”,
 ”issafeteach”:”是否安全教育”,
 “authpermission”:”是否拥有操作权限,0-无 1有”
 */

@interface DriverModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *no;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *dn;
@property (nonatomic, strong) NSString *idcard;
@property (nonatomic, strong) NSString *workcategory;
@property (nonatomic, assign) NSInteger workcategoryid;
@property (nonatomic, strong) NSString *entertime;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) NSString *renttype;
@property (nonatomic, assign) double rent;
@property (nonatomic, assign) NSInteger issafeteach;
@property (nonatomic, assign) NSInteger authpermission;
@property (nonatomic, strong) NSString *credentials; //证件照片地址， 逗号隔开
@property (nonatomic, assign) NSInteger workerid; //人员的ID
@property (nonatomic, assign) NSInteger driverrentid;//": 8,
@property (nonatomic, assign) NSInteger ID;//": 31,

@property (nonatomic, assign) NSInteger projectid;//": 1,
@property (nonatomic, strong) NSMutableArray *photoList;
@end
