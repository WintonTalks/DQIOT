//
//  DataCenterModel.h
//  WebThings
//
//  Created by machinsight on 2017/7/22.
//  Copyright © 2017年 machinsight. All rights reserved.
//  数据中心model

#import <Foundation/Foundation.h>
#import "WarningModel.h"
//"warnlist":[{
//    "warncode":"告警码",
//    "warndesc":"告警描述",
//    "num":"次数"
//}]，
//“lgt”:"经度" ， 120,E
//“lat":"纬度", 32,N
//"ont":"累计工作时间" 20：23：23
//"tdm":"变频器型号",int
//"frp"："工作频率",
//"pow":"输出功率",
//"spd":"运行速度",
//"vol":"输出电压",无
//"cur":"输出电流",
//"pmt":"变频累计工作时间",
//"cmt":"工频累计工作时间",
//"nld":"载重量",
//"olt":"超载数",
//"olw":"超载量",
//"utt":"上行操作杆",
//"dtt":"下行操作杆",
//"est":"内外急停",无
//"ult":"上限位置",
//"dlt":"下限位"，
//"uel":"极限冲顶或限速保护",
//"ovh":"电机过热"
//}
@interface DataCenterModel : NSObject
@property (nonatomic, strong) NSArray <WarningModel *> *warnlist;
@property (nonatomic, strong) NSString *lgt;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *ont;
@property (nonatomic, strong) NSString *tdm;
@property (nonatomic, strong) NSString *frp;
@property (nonatomic, strong) NSString *pow;
@property (nonatomic, strong) NSString *spd;
@property (nonatomic, strong) NSString *vol;
@property (nonatomic, strong) NSString *cur;
@property (nonatomic, strong) NSString *pmt;
@property (nonatomic, strong) NSString *cmt;
@property (nonatomic, strong) NSString *nld;
@property (nonatomic, strong) NSString *olt;
@property (nonatomic, strong) NSString *olw;
@property (nonatomic, strong) NSString *utt;
@property (nonatomic, strong) NSString *dtt;
@property (nonatomic, strong) NSString *est;
@property (nonatomic, strong) NSString *ult;
@property (nonatomic, strong) NSString *dlt;
@property (nonatomic, strong) NSString *uel;
@property (nonatomic, strong) NSString *ovh;


@property (nonatomic, assign) NSInteger orderid;
@end
