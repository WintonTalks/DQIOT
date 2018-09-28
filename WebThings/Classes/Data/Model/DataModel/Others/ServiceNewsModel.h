//
//  ServiceNewsModel.h
//  WebThings
//
//  Created by machinsight on 2017/7/14.
//  Copyright © 2017年 machinsight. All rights reserved.
//  服物流消息

#import <Foundation/Foundation.h>

@interface ServiceNewsModel : NSObject


@property (nonatomic,assign) NSInteger confirm;//0无需处理 1需处理,
@property (nonatomic,assign) NSInteger enumstateid;//状态id
@property (nonatomic,assign) NSInteger ID;//120,
@property (nonatomic,assign) NSInteger isdel;//0未删除  1已删除
@property (nonatomic,assign) NSInteger ishaveattach;//是否有附件 0没有 1有
@property (nonatomic,assign) NSInteger isread;//0未读，1已读
@property (nonatomic,assign) NSInteger isserviceflow;//是否关联服务流 0关联 1未关联
@property (nonatomic,assign) NSInteger linkid;//0无关联  1前期沟通项详情  2启租单  3司机清单 4设备维保 5设备维修 6设备加高 7设备故障 8设备拆除
@property (nonatomic,strong) NSString *name;//客户项目经理",
@property (nonatomic,strong) NSString *projcetdeviceid;//关联id
@property (nonatomic,strong) NSArray *msgattachmentList;//图片集合
@property (nonatomic,strong) NSArray *project;//":{//有就不为空

@property (nonatomic,strong) NSString *sendname;//":"赵永飞",
@property (nonatomic,strong) NSString *sendtime;//":"2017/07/25 08:54:06",
@property (nonatomic,assign) NSInteger senduserid;//":257,
@property (nonatomic,strong) NSString *sendusertypename;//":"项目经理",
@property (nonatomic,assign) NSInteger stateid;//":7,
@property (nonatomic,assign) NSInteger statetype;//":0,
@property (nonatomic,strong) NSString *text;//":"进场沟通单",
@property (nonatomic,strong) NSString *title;//":"进场沟通单",
@property (nonatomic,strong) NSString *type;//":"租赁商",
@property (nonatomic,assign) NSInteger userid;//":256,
@property (nonatomic,strong) NSString *usertypename;//":"项目经理"

@end
