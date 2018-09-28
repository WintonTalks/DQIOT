//
//  DWMsgModel.h
//  WebThings
//
//  Created by machinsight on 2017/7/26.
//  Copyright © 2017年 machinsight. All rights reserved.
//  司机、工人 消息模型

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "AddProjectModel.h"
#import "IVEDataModel.h"
#import "UserModel.h"
//通知id:noticeid
//通知标题:title
//通知内容:msg
//通知时间:cdate
//通知类型:noticetype
//isread:是否已读 “已读”或“未读”
//isfinish:是否已完成 "已完成" 或 "未完成"
@interface DWMsgModel : NSObject
@property (nonatomic, assign) NSInteger noticeid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *cdate;
@property (nonatomic, copy) NSString *noticetype;
@property (nonatomic, copy) NSString *isread;
@property (nonatomic, copy) NSString *isfinish;

@property (nonatomic, assign) NSInteger msgcount;//消息数量


@property (nonatomic, strong) NSString *orgname;
@property (nonatomic, strong) NSString *projectname;
@property (nonatomic, strong) NSString *model;
@property (nonatomic, strong) NSString *deviceno;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) NSInteger projectid;
@property (nonatomic, assign) NSInteger deviceid;
@property (nonatomic, strong) NSString *descartion;

@property (nonatomic, assign) NSInteger projectdeviceid;

@property (nonatomic, strong) NSArray <UserModel *> *users;

@property (nonatomic, assign) NSInteger optid;//0.小维故障 1.司机故障

@property (nonatomic, assign) NSInteger linkid;//单据id

@property (nonatomic, strong) NSArray <IVEDataModel *> *ivedata;//小微分析

@property (nonatomic, strong) AddProjectModel *project;//项目信息

@property (nonatomic, strong) NSString *warnname;
@property (nonatomic, assign) NSInteger warnid;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSString *btnTitle;

@property (nonatomic, assign) CGFloat closeCellHeight;
@property (nonatomic, assign) CGFloat openCellHeight;
@property (nonatomic, assign) BOOL isOpen;

@property (nonatomic, assign) BOOL isnotSelected;//是否未被选中

@property (nonatomic, assign) BOOL isShowCekBtn;//是否显示勾选框

@property (nonatomic, assign) BOOL isFirst;//给司机查进度用的，网络请求中直接赋值
@property (nonatomic, assign) BOOL isLast;

- (UIColor *)returnColor;

- (UIImage *)returnImg;

- (NSString *)returnBtnTitle;
@end
