//
//  DQLogicCommunicateModel.m
//  WebThings
//  管理服务流子节点的父类
//  Created by Heidi on 2017/9/26.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQLogicCommunicateModel.h"

#import "DQSubCommunicateModel.h"
#import "AddProjectModel.h"
#import "DeviceModel.h"

#import "EditDeviceViewController.h"
#import "EMIBaseViewController.h"

#import "DQServiceInterface.h"

@interface DQLogicCommunicateModel ()
<EMIBaseViewControllerDelegate>

@end

@implementation DQLogicCommunicateModel

#pragma mark - Getter
- (NSString *)cellIdentifier {
    NSInteger stateID = self.cellData.enumstateid;
    if (stateID == DQEnumStateCommunicateSubmitted) {    // 沟通单
        return @"DQCommunicateCell";
    }
    // 确认|驳回
    else if (stateID == DQEnumStateCommunicatePass
             || stateID == DQEnumStateCommunicateRefuse) {
        return @"DQRefuteBackCell";
    }
    return [super cellIdentifier];
}

// 当前业务展示界面的高度
- (CGFloat)cellHeight {
    NSInteger stateID = self.cellData.enumstateid;
    if (stateID == DQEnumStateCommunicateSubmitted) {    // 沟通单
        
        // header中说明自动换行，计算动态高度
        CGFloat headerHeight = 0;
        CGFloat width = screenWidth - 58 - 16 - 112;
        CGSize size = [AppUtils
                       textSizeFromTextString:self.cellData.text
                       width:width
                       height:100
                       font:[UIFont dq_semiboldSystemFontOfSize:14]];
        headerHeight = 62 + size.height;
        
        CGFloat height = [self heightForBill] + headerHeight + 16;
        if (self.showRefuteBackButton) { // 承租方最后一条前期沟通单据，多出 确认／驳回 高度
            height += 54;
        }
        
        if (self.arrayForBill.count > 5) { // 表单展开时要加上header and footer Section的高度
            height += (kHEIHGT_BILLCELL + 8)*2 + 16 + 8;
        } else {
            height += 16; // 表单折叠时要加上header and footer Section的高度
        }
        
        return height;
    }
    // 确认|驳回
    else if (stateID == DQEnumStateCommunicatePass
             || stateID == DQEnumStateCommunicateRefuse) {
        return 76 + 16;
    }
    
    return 44.0f;
}

- (NSArray *)arrayForBill {
    DQSubCommunicateModel *model = (DQSubCommunicateModel *)self.cellData;
    AddProjectModel *projectModel = model.projecthistory;
    DeviceModel *deviceModel = projectModel.projectDevicehistory;
    self.billID = [NSString stringWithFormat:@"%ld", model.linkid];
    NSArray *array = nil;
    if (self.isOpen) { /** 展开状态沟通表数据 */
        NSString *dirction = (self.direction == DQDirectionLeft) ? @"left" : @"right";
        array = @[@{@"key" : @"项目名称", @"value" : [NSObject changeType:projectModel.projectname]},// 项目信息
                       @{@"key" : @"确认订单编号", @"value" : [NSObject changeType:projectModel.no]},
                       @{@"key" : @"出租方", @"value" : [NSObject changeType:projectModel.providename]},
                       @{@"key" : @"承租方", @"value" : [NSObject changeType:projectModel.needorgname]},
                       @{@"key" : @"工程地点", @"value" : [NSObject changeType:projectModel.projectaddress]},
                       @{@"key" : @"总包单位", @"value" : [NSObject changeType:projectModel.contractor]},
                       @{@"key" : @"监理单位", @"value" : [NSObject changeType:projectModel.supervisor]},
                       @{@"key" : @"预计进场时间", @"value" : [NSObject changeType:projectModel.indate]},
                       @{@"key" : @"预计出场时间", @"value" : [NSObject changeType:projectModel.outdate]},
                       @{@"key" : @"设备数量", @"value" : [NSString stringWithFormat:@"%ld",projectModel.devicenum]},
                       @{@"key" : @"租金", @"value" : [NSString stringWithFormat:@"%ld",projectModel.rent]},
                       @{@"key" : @"进出场费", @"value" : [NSString stringWithFormat:@"%ld",projectModel.intoutprice]},
                       @{@"key" : @"司机工资", @"value" : [NSString stringWithFormat:@"%ld",projectModel.driverrent]},
                       @{@"key" : @"项目负责人", @"value" : [NSObject changeType:projectModel.dn], @"addition" : [NSString stringWithFormat:@"%@",dirction]},
                       @{@"key" : @"总金额", @"value" : [NSString stringWithFormat:@"%ldf",projectModel.totalprice]},
                       @{@"key" : @"设备品牌", @"value" : [NSObject changeType:deviceModel.brand]},// 设备信息
                       @{@"key" : @"设备型号", @"value" : [NSObject changeType:deviceModel.model]},
                       @{@"key" : @"预埋件安装时间", @"value" : [NSObject changeType:deviceModel.beforehanddate]},
                       @{@"key" : @"安装高度", @"value" : [NSString stringWithFormat:@"%ld",deviceModel.high]},
                       @{@"key" : @"安装时间", @"value" : [NSObject changeType:deviceModel.handdate]},
                       @{@"key" : @"租赁价格", @"value" : [NSString stringWithFormat:@"%ld",deviceModel.rent]},
                       @{@"key" : @"安装地点", @"value" : [NSObject changeType:deviceModel.installationsite]},
                       @{@"key" : @"使用时间", @"value" : [NSObject changeType:deviceModel.starttime]}
                       ];
    }
    else { /** 折叠状态沟通表数据 */
        array =  @[@{@"key" : @"项目名称", @"value" : [NSObject changeType:projectModel.projectname]},// 项目信息
                       @{@"key" : @"总金额", @"value" : [NSString stringWithFormat:@"%ld",projectModel.totalprice]},
                       
                       @{@"key" : @"设备品牌", @"value" : [NSObject changeType:deviceModel.brand]},// 设备信息
                       @{@"key" : @"设备型号", @"value" : [NSObject changeType:deviceModel.model]},
                       @{@"key" : @"安装时间", @"value" : [NSObject changeType:deviceModel.handdate]}
                   ];
    }
    return array;
}

/** 按钮标题 */
- (NSString *)titleForButton {
    return @"编辑设备信息";
}

/** 按钮icon */
- (NSString *)iconNameForButton {
    return @"ic_create";
}

#pragma mark - Actions
/// 编辑设备信息
- (void)btnClicked {
    [MobClick event:@"business_device_edit"];
    EditDeviceViewController *ctl = [[EditDeviceViewController alloc] init];
    ctl.projectid = self.projectid;
    ctl.dm = self.device;
    ctl.basedelegate = self;
    ctl.fromWho = 0;
    ctl.state = self.cellData.enumstateid;
    [self.navCtl pushViewController:ctl animated:YES];
}

#pragma mark -
- (void)didPopFromNextVC {
    [self reloadTableData];
}

@end
