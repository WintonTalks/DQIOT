//
//  DQServiceSubNodeModel.h
//  WebThings
//  服务流(业务站)子节点数据父类
//  Created by Heidi on 2017/9/25.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQServiceSubNodeModel_h
#define DQServiceSubNodeModel_h
#import "DQEnum.h"

#import "ProjectStartRentHistoryModel.h"

@interface DQServiceSubNodeModel : NSObject <NSCopying>

@property (nonatomic, strong) NSNumber *subID;
@property (nonatomic, assign) NSInteger confirm;        //0无需处理 1需处理,
@property (nonatomic, assign) NSInteger confirmresult;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSNumber *deviceid;
@property (nonatomic, strong) NSNumber *projectid;
@property (nonatomic, assign) NSInteger dritoryid;
@property (nonatomic, assign) NSInteger enumstateid;
@property (nonatomic, copy) NSString *headimg;
@property (nonatomic, assign) NSInteger isdel;          // 0未删除  1已删除
@property (nonatomic, assign) NSInteger ishaveattach;   // 是否有附件 0没有 1有
@property (nonatomic, assign) NSInteger isread;         // 0未读，1已读
@property (nonatomic, assign) NSInteger isserviceflow;  // 是否关联服务流 0关联 1未关联
@property (nonatomic, assign) NSInteger linkid;         // 0无关联  1前期沟通项详情  2启租单  3司机清单 4设备维保 5设备维修 6设备加高 7设备故障 8设备拆除
@property (nonatomic, assign) NSInteger linktype;
@property (nonatomic, assign) NSInteger msgtype;
@property (nonatomic, copy) NSString *name;             // 客户项目经理",
@property (nonatomic, strong) NSNumber *orderid;
@property (nonatomic, copy) NSString *projcetdeviceid;  // 关联id

@property (nonatomic, copy) NSString *sendheadimg;      // 头像
@property (nonatomic, copy) NSString *sendname;
@property (nonatomic, copy) NSString *sendtime;         // 2017/07/25 08:54:06
@property (nonatomic, strong) NSNumber *senduserid;
@property (nonatomic, strong) NSString *sendusertypename;// 项目经理
@property (nonatomic, strong) NSNumber *stateid;
@property (nonatomic, assign) NSInteger statetype;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;       // "租赁商"
@property (nonatomic, strong) NSNumber *userid;
@property (nonatomic, copy) NSString *usertypename;

@property (nonatomic, strong) NSString *deviceaddress;//设备安装地点

// 商务往来接口新增字段
@property (nonatomic, copy) NSString *checkDate;    // 2017-07-25 检查日期
@property (nonatomic, copy) NSString *content;     // 检查内容

// --------------自定义字段，方便使用
/// 是否是CEO
@property (nonatomic, assign)BOOL isCEO;
/// 是否是租赁
@property(nonatomic, assign) BOOL isZulin;

/// 是button cell
@property (nonatomic, assign) BOOL isButtonCell;
/// 是报告清算Cell
@property (nonatomic, assign) BOOL isReportCell;
@property (nonatomic, assign) BOOL isLast;

- (id)copyWithZone:(NSZone *)zone;

@end

#endif /* DQServiceSubNodeModel_h */
