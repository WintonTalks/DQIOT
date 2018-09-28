//
//  DQLogicSetupModel.m
//  WebThings
//  管理服务流子节点的父类
//  Created by Heidi on 2017/9/26.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQLogicSetupModel.h"
#import "DQSubSetupModel.h"

#import "DQServiceInterface.h"

@implementation DQLogicSetupModel

#pragma mark - Getter
- (NSString *)cellIdentifier {
    NSInteger stateID = self.cellData.enumstateid;

    if (stateID == DQEnumStateSetupPass ||
        stateID == DQEnumStateSetupRefuse ||
        stateID == DQEnumStateSetupEvidencePass ||
        stateID == DQEnumStateSetupEvidenceRefuse ||
        stateID == DQEnumStateSetupTechPass ||
        stateID == DQEnumStateSetupTechRefuse) {    // 通过或者驳回的样式
        return @"DQRefuteBackCell";
    } else if (stateID == DQEnumStateSetupSubmitted ||
               stateID == DQEnumStateSetupEvidenceSubmitted) {    // 图片／文档浏览
        return @"DQSourceBrowerCell";
    } else if (stateID == DQEnumStateDeviceReport) {    // 安装报告
        return @"DQDeviceSetupCell";
    } else if (stateID == DQEnumStateSetupTechSubmitted) { // 现场技术已交底
        return @"DQSetupTechSubmitedCell";
    }
    return [super cellIdentifier];
}

// 当前业务展示界面的高度
- (CGFloat)cellHeight {
    DQSubSetupModel *setup = (DQSubSetupModel *)self.cellData;
    NSInteger stateID = setup.enumstateid;
    
    if (stateID == DQEnumStateSetupPass ||
        stateID == DQEnumStateSetupRefuse ||
        stateID == DQEnumStateSetupEvidencePass ||
        stateID == DQEnumStateSetupEvidenceRefuse ||
        stateID == DQEnumStateSetupTechPass ||
        stateID == DQEnumStateSetupTechRefuse) {
        return 76 + 16;
    } else if (stateID == DQEnumStateSetupSubmitted ||
               stateID == DQEnumStateSetupEvidenceSubmitted) {
        return [self heightForImageCount:[setup.msgattachmentList count]];
    } else if (stateID == DQEnumStateDeviceReport) {    // 安装报告
        return kHEIHGT_REPORTCELL * 3 + 52 + 25 + 16;
    } else if (stateID == DQEnumStateSetupTechSubmitted) {
        CGFloat height = 76 + 16;
        if (self.showRefuteBackButton) {
            height += 54;
        }
        return height;
    }
    return 44.0f;
}

/** 按钮标题 */
- (NSString *)titleForButton {
    NSString *str = @"";
    switch (self.cellData.enumstateid) {
        case DQEnumStateApplyForSubmit:
            str = @"申请现场技术交底";
            break;
        case DQEnumStateSetupEvidence:
            str = @"上传安装凭证";
            break;
        case DQEnumStateCheckEvidence:
            str = @"上传第三方验收凭证";
            break;
        default:
            break;
    }
    return str;
}

/** 按钮icon */
- (NSString *)iconNameForButton {
    
    return self.cellData.enumstateid == 154 ? @"flow_of_service_ic_send" : @"ic_photo";
}

#pragma mark -
/// ServiceBtnCell中按钮的事件处理
- (void)btnClicked {
    DQSubSetupModel *setup = (DQSubSetupModel *)self.cellData;
    NSInteger stateID = setup.enumstateid;

    if (stateID == DQEnumStateApplyForSubmit) { // 申请现场技术交底
        [MBProgressHUD showHUDAddedTo:self.navCtl.view animated:YES];

        [[DQServiceInterface sharedInstance]
         dq_getConfigDisclosure:@(self.projectid)
         deviceid:@(self.device.deviceid)
         projectdeviceid:@(self.device.projectdeviceid)
         success:^(id result) {
            
             [MBProgressHUD hideAllHUDsForView:self.navCtl.view animated:YES];
             if ([result boolValue]) {
                 MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"申请现场技术交底成功" actionTitle:@"" duration:3.0];
                 [t show];
                 [self reloadTableData];
             }
             
         } failture:^(NSError *error) {
             [MBProgressHUD hideAllHUDsForView:self.navCtl.view animated:YES];
         }];
    } else if (stateID == DQEnumStateSetupEvidence) {   // 上传安装凭证
        [self showUploadPicker:^(id result) {

            [[DQServiceInterface sharedInstance]
             dq_getUploadDocument:@(self.projectid)
             deviceid:@(self.device.deviceid)
             imgs:result
             projectdeviceid:@(self.device.projectdeviceid)
             success:^(id result) {
                 [MBProgressHUD hideAllHUDsForView:self.navCtl.view animated:YES];
                 
                 if (result) {
                     [self reloadTableData];
                 }
             } failture:^(NSError *error) {
                 [self showMessage:@"上传失败"];
             }];
        }];
    }
    else if (stateID == DQEnumStateCheckEvidence) {     // 上传第三方验收凭证
        [self showUploadPicker:^(id result) {
            
            [[DQServiceInterface sharedInstance]
             dq_getUploadOtherCheckDocumnet:@(self.projectid)
             deviceid:@(self.device.deviceid)
             imgs:result
             projectdeviceid:@(self.device.projectdeviceid)
             success:^(id result) {
                 [MBProgressHUD hideAllHUDsForView:self.navCtl.view animated:YES];
                 
                 if (result) {
                     [self reloadTableData];
                 }
             } failture:^(NSError *error) {
                 [self showMessage:@"上传失败"];
             }];
        }];
    }
}

@end
