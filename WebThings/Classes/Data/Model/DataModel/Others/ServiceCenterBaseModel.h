//
//  ServiceCenterBaseModel.h
//  WebThings
//
//  Created by machinsight on 2017/6/30.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddProjectModel.h"
#import "ProjectStartRentHistoryModel.h"
#import "DeviceMaintainorderModel.h"
#import "DeviceMaintainorderModel.h"
#import "PriceListModel.h"
#import "ServiceevaluateModel.h"
#import "DriverModel.h"

//flowtype: 前期沟通、设备报装…
//canclick: 是否可以点击 0不可以 1 可以
//isfinish:是否已完成    0未完成  1 已完成

@interface ServiceCenterBaseModel : NSObject<NSCopying>
/**0居左,1居右*/
@property(nonatomic,assign) int direction;
/**是否是租赁,YES Or NO*/
@property(nonatomic,assign) BOOL iszulin;

/**
 是否最后一条,该状态在网络请求时对数组最后一条赋值
 */
@property(nonatomic,assign) BOOL isLast;

/**
 是否最后一条且为提交状态,该状态在getter方法赋值
 */
@property(nonatomic,assign) BOOL isLastCommit;

@property(nonatomic,assign) BOOL isLastSecondSure;//是否是倒数第二个单据，且下一条为确认，才为YES

@property(nonatomic,assign) BOOL isNextSure;//用于维保，维修，加高的已确认按钮是否显示(满足条件，上一条id为35，39，43时，下一条状态id是否为36，40，44)
@property(nonatomic,assign) BOOL isNextCommit;//用于维保，维修，加高的已完成按钮是否显示(满足条件，上一条id为36，40，44时，下一条状态id是否为37，41，45)
@property(nonatomic,assign) BOOL isNextForm;//用于维保，维修，加高完成提交状态的确认驳回按钮 是否显示(满足条件，上一条id为37，41，45时，下一条状态id是否为35，39，43)
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) NSString *flowtype;
@property (nonatomic, assign) NSInteger canclick;
@property (nonatomic, assign) NSInteger isfinish;





@property (nonatomic,assign) NSInteger ID;//120,
@property (nonatomic,assign) NSInteger isread;//0未读，1已读
@property (nonatomic,assign) NSInteger enumstateid;//状态id
@property (nonatomic, strong) NSString *sendusertypename;//":"项目经理",
@property (nonatomic, strong) NSString *type;//":"租赁商",
@property (nonatomic, strong) NSString *name;//客户项目经理",
@property (nonatomic,assign) NSInteger userid;//":256,
@property (nonatomic, strong) NSString *projcetdeviceid;//关联id
@property (nonatomic,assign) NSInteger stateid;//":7,
@property (nonatomic,assign) NSInteger confirm;//0无需处理 1需处理,
@property (nonatomic,assign) NSInteger linktype;//
@property (nonatomic,assign) NSInteger isdel;//0未删除  1已删除
@property (nonatomic,assign) NSInteger fid;//
@property (nonatomic,assign) NSInteger senduserid;//":257,
@property (nonatomic, strong) NSString *sendtime;//":"2017/07/25 08:54:06",
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *usertypename;//":"项目经理"
@property NSInteger statetype;//":0,
@property NSInteger confirmresult;//
@property NSInteger msgtype;
@property NSInteger ishaveattach;//是否有附件 0没有 1有
@property NSInteger isserviceflow;//是否关联服务流 0关联 1未关联
@property NSInteger linkid;//0无关联  1前期沟通项详情  2启租单  3司机清单 4设备维保 5设备维修 6设备加高 7设备故障 8设备拆除
@property (nonatomic, strong) NSString *sendname;//":"赵永飞",
@property (nonatomic, strong) NSString *sendheadimg;//头像

@property (nonatomic, strong) NSArray *msgattachmentList;//图片集合
@property (nonatomic, strong) AddProjectModel *projecthistory;//项目信息
@property (nonatomic, strong) ProjectStartRentHistoryModel *projectstartrenthistory;//设备启租单
@property (nonatomic, strong) NSArray <DriverModel *> *dirverrenthistoryList;//司机列表
@property (nonatomic, strong) DeviceMaintainorderModel *deviceMaintainorder;//设备维保单
@property (nonatomic, strong) DeviceMaintainorderModel *devicerepairorder;//设备维修单
@property (nonatomic, strong) DeviceMaintainorderModel *deivieaddheight;//设备加高单
@property (nonatomic, strong) DeviceMaintainorderModel *dismantledevice;//设备拆除单
@property (nonatomic, strong) PriceListModel *pricelist;//费用
@property (nonatomic, strong) ServiceevaluateModel *serviceevaluate;//服务评价



@property (nonatomic, strong) NSString *deviceaddress;//设备安装地点


@property (nonatomic,assign)BOOL isCEO;//是否是ceo








- (NSInteger)returnIndex;

- (CGFloat)returnCellHeight;
@end
