//
//  DQTranrecordListModel.h
//  WebThings
//
//  Created by winton on 2017/10/21.
//  Copyright © 2017年 machinsight. All rights reserved.
//  人员培训记录

#import <Foundation/Foundation.h>

/*
 “data”:[{
 “trainid”:”培训记录id”
 “workerid”:”参加培训人员id”,
 “name”:”参加培训人员姓名”
 “projectid”:“项目id”,
 “projectname”:”项目名称”,
 “organizer”:”组织者”,
 “typeid”:”培训类型id”,
 “type”:”培训类型”,
 “date”:”培训时间”,
 “recordno”:”记录表编号”,
 “traincount”:”参加人员人数”
 }…]
 */
@interface DQTranrecordListModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger trainid;
@property (nonatomic, assign) NSInteger workerid;
@property (nonatomic, assign) NSInteger projectid;
@property (nonatomic, strong) NSString *projectname;
@property (nonatomic, strong) NSString *organizer;
@property (nonatomic, assign) NSInteger typeid;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *recordno;
@property (nonatomic, assign) NSInteger traincount;


@end
