//
//  DQServiceBaseModel.m
//  WebThings
//  管理服务流子节点的父类
//  Created by Heidi on 2017/9/26.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

#import "DQLogicServiceBaseModel.h"
#import "DQLogicBusinessContractModel.h"
#import "DQLogicFixModel.h"
#import "DQLogicMaintainModel.h"
#import "DQLogicHeightenModel.h"

#import "DQScannerDocController.h"

#import "DQAlert.h"
#import "DQPhotoActionSheetManager.h"

#import "DQBaseAPIInterface.h"

@interface DQLogicServiceBaseModel () {
    DQAlert *_alert;
}

@property (nonatomic, copy) DQResultBlock finishedUpload;
@property (nonatomic, strong) NSMutableArray<PHAsset *> *lastSelectAssets;
@property (nonatomic, strong) NSMutableArray<UIImage *> *lastSelectPhotos;

@end

@implementation DQLogicServiceBaseModel

/// 子类可根据业务重写，用来指定显示的Cell
- (NSString *)cellIdentifier {
    NSInteger stateID = _cellData.enumstateid;
    if (stateID > 150) {    // Button Cell
        return @"DQServiceBtnCell";
    }
    return @"DQServiceStationBaseCell";
}

/// 子类需要根据业务重写，计算cell高度
- (CGFloat)cellHeight {
    CGFloat height = 50.f;
    NSInteger stateID = _cellData.enumstateid;
    if (stateID > 150) {
        return 29 + 16;
    }
    return height;
}

- (DQDirection)direction {
    // 商务往来
    if (_nodeType == DQFlowTypeBusinessContact) {
        // 登录用户和发送者为同一人，因为目前PM只有一个人
        if ([_cellData.senduserid integerValue] == [AppUtils readUser].userid) {
            return DQDirectionRight;
        }
    }
    // 登录用户和发送者为同一方
    else  if ([_cellData.type isEqualToString:[AppUtils readUser].type]) {
            return DQDirectionRight;
        }
    return DQDirectionLeft;
}

- (BOOL)showRefuteBackButton {
    // 最后一行的状态为已提交，增加确认和驳回按钮
    NSArray *array = @[@"11", @"14", @"17", @"20", @"23",
                       @"26", @"29", @"1", @"32", @"35", @"37",
                       @"39", @"41", @"43", @"45", @"", @"48",@"61"];
    
    BOOL canConfirm = ![AppUtils readUser].isZuLin;  // 承租方执行确认／驳回操作
    // 停租单／维保／维护／加高由租赁方确认或者驳回
    if (_cellData.enumstateid == DQEnumStateRemoveSubmitted ||
        _cellData.enumstateid == DQEnumStateFixSubmitted ||
        _cellData.enumstateid == DQEnumStateHeightenSubmitted ||
        _cellData.enumstateid == DQEnumStateMaintainSubmitted ||
        // 维保／维护／加高完成单
        _cellData.enumstateid == DQEnumStateHeightenDoneSubmitted ||
        _cellData.enumstateid == DQEnumStateMaintainDoneSubmitted) {
        canConfirm = [AppUtils readUser].isZuLin;
    }
    return [array containsObject:[NSString stringWithFormat:@"%ld", _cellData.enumstateid]]
    && self.isLast && canConfirm;
}

#pragma mark - UI
/// 边框颜色
- (UIColor *)hexBorderColor {
    BOOL other = self.direction == DQDirectionLeft;
    if (self.nodeType == DQFlowTypeBusinessContact) {
        return [UIColor colorWithHexString:other ? @"#ADADAD" : COLOR_BLUE];
    } else if (self.cellData.enumstateid == DQEnumStateRemoveRefuse) {
        return [UIColor colorWithHexString:COLOR_RED];
    }
    //  确认还是驳回，驳回显示红色，确认显示(我发的显示绿色，别人发的显示蓝色）
    return [UIColor colorWithHexString:other ? COLOR_BLUE : COLOR_GREEN];
}

/// 有色标题的颜色
- (UIColor *)hexTitleColor {
    BOOL other = self.direction == DQDirectionLeft;
    if (self.nodeType == DQFlowTypeBusinessContact) {
        return [UIColor colorWithHexString:other ? COLOR_BLACK : COLOR_BLUE];
    } else if (self.cellData.enumstateid == DQEnumStateRemoveRefuse) {
        return [UIColor colorWithHexString:COLOR_RED];
    }
    //  确认还是驳回，驳回显示红色，确认显示(我发的显示绿色，别人发的显示蓝色）
    return [UIColor colorWithHexString:other ? COLOR_BLUE : COLOR_GREEN];
}

/// 背景颜色
- (UIColor *)hexBgColor {
    BOOL other = self.direction == DQDirectionLeft;
    if (self.nodeType == DQFlowTypeBusinessContact) {
        return [UIColor colorWithHexString:other ? @"#E6E5EB" : COLOR_BLUE_LIGHT];
    } else if (self.cellData.enumstateid == DQEnumStateRemoveRefuse) {
        return [UIColor colorWithHexString:COLOR_RED_LIGHT];
    }

    //  确认还是驳回，驳回显示红色，确认显示(我发的显示绿色，别人发的显示蓝色）
    return [UIColor colorWithHexString:other ? COLOR_BLUE_LIGHT : COLOR_GREEN_LIGHT];
}

/// 展示图片的View的高度
- (CGFloat)heightForImageCount:(NSInteger)count {
//    if (count > 6) {
//        count = 6;
//    }
    CGFloat height = 76;
    if (count > 0) {
        NSInteger margin = 5;
        NSInteger imgWidth = (screenWidth-75 - (margin * 4)) / 3;// 图片宽度
        NSInteger imgHeight = imgWidth*1.25;   // 图片高度
        height += (ceil(count/3.0) * imgHeight) + (margin * (ceil(count/3.0) + 1));
    }
    
    // 提交之后的状态，增加和驳回按钮
    if (self.showRefuteBackButton) {
        height += 70;
    } else {
        height += 16;   // 若没有图片，则底部多留16
    }
    return height;
}

/** 表单数据 */
- (NSArray *)arrayForBill {
    return [NSArray array];
}

/** 表单高度 */
- (CGFloat)heightForBill {
    CGFloat height = 0;
    NSArray *array = [self arrayForBill];
    for (NSDictionary *dict in array) {
        CGSize size = [AppUtils
                       textSizeFromTextString:dict[@"value"]
                       width:kWIDTH_BILLCELL
                       height:1000
                       font:[UIFont dq_semiboldSystemFontOfSize:14]];
        if (size.height < 20) {
            height += 30;
        } else {
            height += size.height + 16;
        }
    }
    return height;
}

/** 按钮标题 */
- (NSString *)titleForButton {
    return @"";
}

/** 按钮icon */
- (NSString *)iconNameForButton {
    return @"ic_create";
}

- (NSString *)billID {
    return [NSString stringWithFormat:@"%ld", _cellData.linkid];
}

#pragma mark - Actions 在子类中实现
/// ServiceBtnCell中按钮的事件处理
- (void)btnClicked {
    
}

/// 确认／驳回 confirm:1.确认 0.驳回 调用接口，并回调刷新
- (void)btnConfirmOrRefuteBack:(BOOL)confirm {
    DQEventType event = DQEventTypeNone;
    switch (self.nodeType) {
        case DQFlowTypeCommunicate:
            event = DQEventTypeCommunicate;
            break;
        case DQFlowTypePack:
            event = DQEventTypePack;
            break;
        case DQFlowTypeSetup:
        {
            NSInteger stateID = _cellData.enumstateid;

            event = DQEventTypeSetup;
            if (stateID == DQEnumStateSetupTechSubmitted) {
                event = DQEventTypeSetupTech;
            } else if (stateID == DQEnumStateSetupEvidenceSubmitted) {
                event = DQEventTypeSetupCheck;
            }
        }
            break;
        case DQFlowTypeRent:
            event = DQEventTypeRent;
            break;
        case DQFlowTypeMaintain:
            event = DQEventTypeMaintain;
            break;
        case DQFlowTypeFix:
            event = DQEventTypeFix;
            break;
        case DQFlowTypeHeighten:
            event = DQEventTypeHeighten;
            break;
        case DQFlowTypeRemove:
            event = DQEventTypeRemove;
            break;
        default:
            break;
    }
    [MBProgressHUD showHUDAddedTo:self.navCtl.view animated:YES];
    [[DQServiceInterface sharedInstance]
     dq_confirmOrRefuseWithProject:@(_projectid)
     deviceID:@(_device.deviceid)
     eventtype:event
     yesorno:confirm
     billid:[NSObject changeType:_billID]
     projectdeviceid:@(_device.projectdeviceid)
     success:^(id result) {
         
         [self hideHud];
         if ([result boolValue]) {
             [self reloadTableData];
         }
         
     } failture:^(NSError *error) {
         [self showMessage:@"请求失败"];
     }];
}

#pragma mark -
- (void)showMessage:(NSString *)msg {
    [MBProgressHUD hideAllHUDsForView:self.navCtl.view animated:YES];
    MDSnackbar *t = [[MDSnackbar alloc] initWithText:msg actionTitle:@"" duration:3.0];
    [t show];
}

- (void)hideHud {
    [MBProgressHUD hideAllHUDsForView:self.navCtl.view animated:YES];
}

- (void)reloadTableData {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dq_needReloadData)]) {
        [self.delegate dq_needReloadData];
    }
}

- (void)showUploadPicker:(DQResultBlock)finishUpload {
    self.finishedUpload = finishUpload;
    
    [self showImagePicker];
//    if (!_alert) {
//        _alert = [[DQAlert alloc] init];
//    }
//
//    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:0];
//    //    if (@available(iOS 11.0, *)) {
//    //        [titles addObject:@"上传文档"];
//    //    }
//    [titles addObject:@"上传照片"];
//    [_alert showActionSheetWithTitle:nil
//                               okBtn:titles
//                           cancelBtn:@"取消" block:^(NSInteger index) {
//                               if (@available(iOS 11.0, *)) {
//                                   if (index == 0) { // 上传文档
//                                       DQScannerDocController *ctl = [[DQScannerDocController alloc] init];
//                                       ctl.logicModel = self;
//                                       [self.navCtl pushViewController:ctl animated:YES];
//                                   } else {  // 上传照片
//                                       [self showImagePicker];
//                                   }
//                               } else {  // 上传照片
//                                   [self showImagePicker];
//                               }
//                           } cancelClick:^(NSInteger index) {
//
//                           }];
}

#pragma mark -
/** 显示图片选择器 */
- (void)showImagePicker {
    
    DQPhotoActionSheetManager *manager = [[DQPhotoActionSheetManager alloc] init];
    [manager dq_showPhotoActionSheetWithController:self.navCtl
                                  showPreviewPhoto:YES
                                    maxSelectCount:6
                                 didSelectedImages:^(NSArray<UIImage *> *images) {
                                     [manager dq_uploadImageApi:^(NSArray *images) {
                                         self.finishedUpload(images);
                                     }];
                                 }];
}

@end
