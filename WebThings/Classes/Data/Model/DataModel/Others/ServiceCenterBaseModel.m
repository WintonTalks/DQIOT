//
//  ServiceCenterBaseModel.m
//  WebThings
//
//  Created by machinsight on 2017/6/30.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ServiceCenterBaseModel.h"
#import "MsgattachmentListModel.h"

@implementation ServiceCenterBaseModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
/* 实现该方法，说明数组中存储的模型数据类型 */
+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"msgattachmentList" : @"MsgattachmentListModel",
              @"dirverrenthistoryList":@"DriverModel"
              };
    
}

- (NSInteger)returnIndex{
    if ([self.flowtype isEqualToString:@"前期沟通"]) {
        return 1;
    }else if([self.flowtype isEqualToString:@"设备报装"]){
        return 2;
    }else if([self.flowtype isEqualToString:@"设备安装"]){
        return 3;
    }else if([self.flowtype isEqualToString:@"设备启租"]){
        return 4;
    }else if([self.flowtype isEqualToString:@"司机确认"]){
        return 5;
    }else if([self.flowtype isEqualToString:@"设备维保"]){
        return 6;
    }else if([self.flowtype isEqualToString:@"设备维修"]){
        return 7;
    }else if([self.flowtype isEqualToString:@"设备加高"]){
        return 8;
    }else if([self.flowtype isEqualToString:@"拆除设备"]){
        return 9;
    }else if([self.flowtype isEqualToString:@"服务评价"]){
        return 10;
    }else{
        return 0;
    }
}


- (CGFloat)returnCellHeight{
    if (self.enumstateid == 11 && self.iszulin && self.isLastCommit) {
        //租赁方最后一条前期沟通单据
        self.cellHeight = 910;
        return self.cellHeight;
    }
    if (self.enumstateid == 11 && !self.iszulin && self.isLastCommit) {
        //承租方最后一条前期沟通单据，多出40的按钮（确认驳回Btn）高度
        self.cellHeight = 950;
        return self.cellHeight;
    }
    if (self.enumstateid == 11 && !self.isLastCommit) {
        //非最后一条前期沟通单据
        self.cellHeight = 895;
        return self.cellHeight;
    }
    if (self.enumstateid == 12 || self.enumstateid == 15 || self.enumstateid == 18|| self.enumstateid == 21|| self.enumstateid == 24 || self.enumstateid == 27 || self.enumstateid == 30 || self.enumstateid == 33|| self.enumstateid == 38|| self.enumstateid == 42|| self.enumstateid == 46) {
        //确认
        self.cellHeight = 118;
        return self.cellHeight;
    }
    if (self.enumstateid == 36 || self.enumstateid == 40 || self.enumstateid == 44) {
        if (!self.isCEO && self.iszulin && !self.isNextCommit) {
            //带按钮确认
            self.cellHeight = 158;
            return self.cellHeight;
        }else{
            //确认
            self.cellHeight = 118;
            return self.cellHeight;
        }
        
    }
    if (self.enumstateid == 31) {
        if (!self.isCEO && self.iszulin && self.isLast){
            //带按钮驳回
            self.cellHeight = 158;
            return self.cellHeight;
        }else{
            //不带按钮驳回
            self.cellHeight = 118;
            return self.cellHeight;
        }
        
    }
    
    if (self.enumstateid == 13 || self.enumstateid == 16 || self.enumstateid == 19|| self.enumstateid == 22|| self.enumstateid == 25 || self.enumstateid == 28 || self.enumstateid == 34 || self.enumstateid == 50|| self.enumstateid == 51|| self.enumstateid == 52) {
        //驳回
        self.cellHeight = 88;
        return self.cellHeight;
    }
    if (self.enumstateid == 153 || self.enumstateid == 154 || self.enumstateid == 155 || self.enumstateid == 156 || self.enumstateid == 158 || self.enumstateid == 159|| self.enumstateid == 160 || self.enumstateid == 161 || self.enumstateid == 162 || self.enumstateid == 163|| self.enumstateid == 164 || self.enumstateid == 167||self.enumstateid == 168||self.enumstateid == 169) {
        //上传。新增按钮
        self.cellHeight = 46;
        return self.cellHeight;
    }
    if (self.enumstateid == 14 || self.enumstateid == 20 || self.enumstateid == 23) {
        NSMutableArray *imgArrs = [NSMutableArray array];
        for (MsgattachmentListModel *item in self.msgattachmentList) {
            [imgArrs addObject:appendUrl(imgUrl, item.fileurl)];
            if (imgArrs.count == 6) {
                break;//最多展示6条
            }
        }
        self.cellHeight = 84+15;
        switch (imgArrs.count) {
            case 0:
                self.cellHeight = self.cellHeight+0;
                break;
            case 1:
                self.cellHeight = self.cellHeight+154;
                break;
            case 2:
                self.cellHeight = self.cellHeight+(245*autoSizeScaleX-12)/2;
                break;
            case 3:
                self.cellHeight = self.cellHeight+(245*autoSizeScaleX-16)/3;
                break;
            default:
                self.cellHeight = self.cellHeight+(245*autoSizeScaleX-16)/3*2+5;
                break;
        }
    }
    if ((self.enumstateid == 14 || self.enumstateid == 20 || self.enumstateid == 23) && self.iszulin && self.isLastCommit) {
        //租赁方最后一条报装资料单据 或 安装凭证 或 第三方凭证
        self.cellHeight = self.cellHeight+15;
        return self.cellHeight;
    }
    
    if ((self.enumstateid == 14 || self.enumstateid == 20 || self.enumstateid == 23) && !self.iszulin && self.isLastCommit) {
        //承租方最后一条报装资料单据 或 安装凭证 或 第三方凭证，有40的按钮高度
        self.cellHeight = self.cellHeight+40+15;
        return self.cellHeight;
    }
    if ((self.enumstateid == 14 || self.enumstateid == 20 || self.enumstateid == 23) && !self.isLastCommit) {
        //非最后一条报装资料单据 或 安装凭证 或 第三方凭证
        return self.cellHeight;
    }

    if ((self.enumstateid == 17) && self.iszulin && self.isLastCommit) {
        //租赁方最后一条现场技术交底单据
        self.cellHeight = 111;
        return self.cellHeight;
    }
    
    if ((self.enumstateid == 17) && !self.iszulin && self.isLastCommit) {
        //承租方最后一条现场技术交底单据，有40的按钮高度
        self.cellHeight = 151;
        return self.cellHeight;
    }
    if ((self.enumstateid == 17) && !self.isLastCommit) {
        //非最后一条现场技术交底单据
        self.cellHeight = 98;
        return self.cellHeight;
    }
    
    if ((self.enumstateid == 37 || self.enumstateid == 41 || self.enumstateid == 45) && self.iszulin && (self.isNextForm || self.isLastCommit)) {
        //租赁方最后一条维保、维修、加高完成提交单据
        self.cellHeight = 111;
        return self.cellHeight;
    }
    
    if ((self.enumstateid == 37 || self.enumstateid == 41 || self.enumstateid == 45) && !self.iszulin && (self.isNextForm || self.isLastCommit)) {
        //承租方最后一条维保、维修、加高完成提交单据，有40的按钮高度
        self.cellHeight = 151;
        return self.cellHeight;
    }
    if ((self.enumstateid == 37|| self.enumstateid == 41 || self.enumstateid == 45) && (!self.isNextForm && !self.isLastCommit)) {
        //非最后一条维保、维修、加高完成提交单据
        self.cellHeight = 98;
        return self.cellHeight;
    }
    if (self.enumstateid == 157) {
        //安装报告
        self.cellHeight = 320;
        return self.cellHeight;
    }
    if (self.enumstateid == 26 && self.iszulin && self.isLastCommit) {
        //租赁方最后一条启租单单据
        self.cellHeight = 407;
        return self.cellHeight;
    }
    
    if (self.enumstateid == 26 && !self.iszulin && self.isLastCommit) {
        //承租方最后一条启租单单据，有40的按钮高度
        self.cellHeight = 447;
        return self.cellHeight;
    }
    if (self.enumstateid == 26 && !self.isLastCommit) {
        //非最后一条启租单单据
        self.cellHeight = 394;
        return self.cellHeight;
    }
    if (self.enumstateid == 35) {
        //设备维保单提交";//35
        if (!self.isNextSure) {
            if (self.iszulin && !self.isCEO) {
                //多出15间隙与40按钮高度
                self.cellHeight = 465;
                return self.cellHeight;
            }else{
                //多出15间隙
                self.cellHeight = 425;
                return self.cellHeight;
            }
            
        }else{
            
            self.cellHeight = 410;
            return self.cellHeight;
        }
    }
    if (self.enumstateid == 43) {
        //加高单提交
        if (!self.isNextSure) {
            if (self.iszulin && !self.isCEO) {
                //多出15间隙与40按钮高度
                self.cellHeight = 417;
                return self.cellHeight;
            }else{
                //多出15间隙
                self.cellHeight = 377;
                return self.cellHeight;
            }
            
        }else{
            self.cellHeight = 362;
            return self.cellHeight;
        }
    }
    
    if (self.enumstateid == 29 && !self.iszulin && self.isLastCommit) {
        //承租方最后一条停租单单据
        self.cellHeight = 311;
        return self.cellHeight;
    }
    
    if (self.enumstateid == 29 && self.iszulin && self.isLastCommit) {
        if (self.isCEO) {
            self.cellHeight = 311;
            return self.cellHeight;
        }else{
            //租赁方最后一条停租单单据，有40的按钮高度
            self.cellHeight = 353;
            return self.cellHeight;
        }
        
    }
    if (self.enumstateid == 29 && !self.isLastCommit) {
        //非最后一条停租单单据
        self.cellHeight = 300;
        return self.cellHeight;
    }
    
    if (self.enumstateid == 165) {
        //费用清算
        self.cellHeight = 330;
        return self.cellHeight;
    }
    return 0;
}


#pragma geter
- (BOOL)iszulin{
    UserModel *m = [AppUtils readUser];
    if ([m.type isEqualToString:@"租赁商"]) {
        _iszulin = YES;
    }else{
        _iszulin = NO;
    }
    return _iszulin;
}
- (BOOL)isCEO{
    UserModel *user = [AppUtils readUser];
    if ([user.usertype isEqualToString:@"CEO"]) {
        _isCEO = YES;
    }else{
        _isCEO = NO;
    }
    return _isCEO;
}

- (int)direction {
    
    UserModel *user = [AppUtils readUser];
    if ([user.type isEqualToString:self.type]) {
        _direction = 1;
    }else{
        _direction = 0;
    }
    
    //假如是驳回的话，反方向
    if (self.enumstateid == 13 || self.enumstateid == 16 || self.enumstateid == 19|| self.enumstateid == 22|| self.enumstateid == 25|| self.enumstateid == 28 || self.enumstateid == 34|| self.enumstateid == 50|| self.enumstateid == 51|| self.enumstateid == 52) {
        _direction = 1-_direction;
    }
    return _direction;
}

//isLastCommit 决定是否高度+15
- (BOOL)isLastCommit{
    if ((self.enumstateid == 11 || self.enumstateid == 14 || self.enumstateid == 17|| self.enumstateid == 20|| self.enumstateid == 23|| self.enumstateid == 26|| self.enumstateid == 29|| self.enumstateid == 32|| self.enumstateid == 35|| self.enumstateid == 37|| self.enumstateid == 39|| self.enumstateid == 41|| self.enumstateid == 43|| self.enumstateid == 45|| self.enumstateid == 48) && self.isLast) {
        _isLastCommit = YES;
    }else{
        _isLastCommit = NO;
    }
    return _isLastCommit;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\nID=[%ld],isread=[%ld],enumstateid=[%ld],sendusertypename=[%@],type=[%@],name=[%@],isNextForm=[%d],ishaveattach=[%d],msgattachmentList=[%@],isserviceflow=[%d]\n",
            _ID, _isread, _enumstateid, _sendusertypename,
            _type, _name, _isNextForm ? 1 : 0,
            _ishaveattach ? 1 : 0,
            _msgattachmentList,
            _isserviceflow ? 1 : 0];
}

//enumstateid
//public static class FlowEnum{
//    public static final String DTJ = "待提交";//id 0
//    public static final String QQGT = "前期沟通";//id 1
//    public static final String SBBZ = "设备报装";//2
//    public static final String SBAZ = "设备安装";//3
//    public static final String SBQZ = "设备启租";//4
//    public static final String SJQR = "司机确认";//5
//    public static final String SBWH = "设备维保";//6
//    public static final String SBWX = "设备维修";//7
//    public static final String SBJG = "设备加高";//8
//    public static final String SBCC = "设备拆除";//9
//    public static final String FWPJ = "服务评价";//10
//    public static final String FWDTJ = "服务单提交";//11
//    public static final String FWD_YMAZSJQR = "服务单预埋件时间确认";//12
//    public static final String FWD_YMAZSJBH = "服务单预埋件时间驳回";//13  用于进场沟通单
//    public static final String SBBZZLTJ = "设备报装资料提交";//14
//    public static final String SBBZZLQR = "设备报装资料确认";//15
//    public static final String SBBZZLBH = "设备报装资料驳回";//16
//    public static final String XCJSJTTJ = "现场技术交底提交";//17
//    public static final String XCJSJTQR = "现场技术交底确认";//18
//    public static final String XCJSJTBH = "现场技术交底驳回";//19
//    public static final String XCAZTJ = "现场安装提交";//20
//    public static final String XCAZQR = "现场安装确认";//21
//    public static final String XCAZBH = "现场安装驳回";//22
//    public static final String DSFPZTJ = "第三方凭证提交";//23
//    public static final String DSFPZQR = "第三方凭证确认";//24
//    public static final String DSFPZBH = "第三方凭证驳回";//25
//    public static final String SBQZDTJ = "设备启租单提交";//26
//    public static final String SBQZDQR = "设备启租单确认";//27
//    public static final String SBQZDBH = "设备启租单驳回";//28
//    public static final String TZDTJ = "停租单提交";//29
//    public static final String TZDQR = "停租单确认";//30
//    public static final String TZDBH = "停租单驳回";//31
//    public static final String SJQRTJ = "司机确认提交";//32
//    public static final String SJQRQR = "司机确认确认";//33
//    public static final String SJQRBH = "司机确认驳回";//34
//    public static final String SBWHDTJ = "设备维保单提交";//35
//    public static final String SBWHDQR = "设备维保单确认";//36   #
//    public static final String WHWCTJ = "维保完成提交";//37
//    public static final String WHWCQR = "维保完成确认";//38
//    public static final String SBWXDTJ = "设备维修单提交（故障通知）";//39
//    public static final String SBWXDQR = "设备修单确认";//40   #
//    public static final String WXWCTJ = "维修完成提交";//41
//    public static final String WXWCQR = "维修完成确认";//42
//    public static final String SBJGQQ = "设备加高请求";//43
//    public static final String SBJGQR = "设备加高确认";//44    #
//    public static final String SBJGWCTJ = "设备加高完成提交";//45
//    public static final String SBJGWCQR = "设备加高完成确认";//46
//    public static final String SBSJQ = "设备锁机器";//47
//    public static final String FWPJTJ = "服务评价提交";//48
//    public static final String FWPJHF = "服务评价回复";//49
//    public static final String WHWCBH = "维保完成驳回";//50
//    public static final String WXWCBH = "维修完成驳回";//51
//    public static final String SBJGBH = "设备加高驳回";//52

//    153:设备报装按钮
//    154:申请现场技术交底按钮
//    155:设备安装凭证按钮
//    156:第三方验收凭证按钮
//    157:设备安装报告
//    158:新增设备启租按钮
//    159:修改启租单按钮
//    160:新增设备维保单按钮
//    161:新增设备维修单
//    162:新增服务要求表
//    163:新增停租单
//    164:新增服务评价
//    165:费用清算
//    166:用户自己找司机
//    167:修改司机
//    168:设备锁机
    //169:修改项目
//  加#号的不是一般的确认，多出40的按钮高度
//}

@end
