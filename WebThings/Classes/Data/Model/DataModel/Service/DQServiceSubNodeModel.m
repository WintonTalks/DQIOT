//
//  DQServiceSubNodeModel.m
//  WebThings
//  服务流(业务站)子节点数据父类
//  Created by Heidi on 2017/9/25.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQServiceSubNodeModel.h"

@implementation DQServiceSubNodeModel

#pragma mark - 映射处理
// Model字段和接口字段不同时做此处理
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"subID": @"id"};
}

- (id)copyWithZone:(NSZone *)zone {
    DQServiceSubNodeModel *model= [[[self class] allocWithZone:zone] init];
    model.subID = self.subID;
    model.confirm = self.confirm;
    model.confirmresult = self.confirmresult;
    model.count = self.count;
    model.deviceid = self.deviceid;
    model.projectid = self.projectid;
    model.dritoryid = self.dritoryid;
    model.enumstateid = self.enumstateid;
    model.headimg = self.headimg;
    model.isdel = self.isdel;
    model.ishaveattach = self.ishaveattach;
    model.isread = self.isread;
    model.isserviceflow = self.isserviceflow;
    model.linkid = self.linkid;
    model.linktype = self.linktype;
    model.msgtype = self.msgtype;
    model.name = self.name;
    model.orderid = self.orderid;
    model.projcetdeviceid = self.projcetdeviceid;
    model.sendheadimg = self.sendheadimg;
    model.sendname = self.sendname;
    model.sendtime = self.sendtime;
    model.senduserid = self.senduserid;
    model.sendusertypename = self.sendusertypename;
    model.stateid = self.stateid;
    model.statetype = self.statetype;
    model.text = self.text;
    model.title = self.title;
    model.type = self.type;
    model.userid = self.userid;
    model.usertypename = self.usertypename;
    model.deviceaddress = self.deviceaddress;
    model.checkDate = self.checkDate;
    model.content = self.content;
    
    return model;
}
    
#pragma mark - Getter
- (BOOL)isZulin {
    UserModel *m = [AppUtils readUser];
    if ([m.type isEqualToString:@"租赁商"]) {
        _isZulin = YES;
    }else{
        _isZulin = NO;
    }
    return _isZulin;
}

- (BOOL)isCEO {
    UserModel *user = [AppUtils readUser];
    if ([user.usertype isEqualToString:@"CEO"]) {
        _isCEO = YES;
    }else{
        _isCEO = NO;
    }
    return _isCEO;
}

// 时间格式按照kString_DateFormatter格式化
- (NSString *)sendtime {
    return [_sendtime dq_newTimeStringWithFormat:kString_DateFormatter];
}

- (NSString *)checkDate {
    return [_checkDate dq_newTimeStringWithFormat:@"yyyy年MM月dd日hh点"];
}

#pragma mark -
// 打印此model时显示的内容
- (NSString *)description {
    return [NSString stringWithFormat:@"\nID=[%@],isread=[%ld],enumstateid=[%ld],sendusertypename=[%@],type=[%@],name=[%@],ishaveattach=[%d],isserviceflow=[%d]\n",
            _subID, _isread, _enumstateid, _sendusertypename,
            _type, _name,_ishaveattach ? 1 : 0,
            _isserviceflow ? 1 : 0];
}

@end
