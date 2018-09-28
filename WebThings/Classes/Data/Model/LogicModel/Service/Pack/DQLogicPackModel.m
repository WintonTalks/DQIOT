//
//  DQLogicPackModel.m
//  WebThings
//  管理服务流子节点的父类
//  Created by Heidi on 2017/9/26.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "ZLDefine.h"

#import "DQLogicPackModel.h"
#import "DQSubPackModel.h"

#import "ZLPhotoActionSheet.h"
#import "DQAlert.h"

#import "DQScannerDocController.h"

#import "DQBaseAPIInterface.h"

@interface DQLogicPackModel () {
    
}

@property (nonatomic, strong) NSMutableArray<PHAsset *> *lastSelectAssets;
@property (nonatomic, strong) NSMutableArray *arrDataSources;
@property (nonatomic, strong) NSMutableArray<UIImage *> *lastSelectPhotos;

@end

@implementation DQLogicPackModel

#pragma mark - Getter
- (NSString *)cellIdentifier {
    NSInteger stateID = self.cellData.enumstateid;
    if (stateID == DQEnumStatePackSubmitted) {    // 资料展示
        return @"DQSourceBrowerCell";
    }
    // 确认|驳回结果
    else if (stateID == DQEnumStatePackPass ||
             stateID == DQEnumStatePackRefuse) {
        return @"DQRefuteBackCell";
    }
    return [super cellIdentifier];
}

// 当前业务展示界面的高度
- (CGFloat)cellHeight {
    NSInteger stateID = self.cellData.enumstateid;
    DQSubPackModel *pack = (DQSubPackModel *)self.cellData;
    if (stateID == DQEnumStatePackSubmitted) {    // 资料
        return [self heightForImageCount:[pack.msgattachmentList count]];
    }
    // 确认|驳回
    else if (stateID == DQEnumStatePackPass ||
             stateID == DQEnumStatePackRefuse) {
        return 76 + 16;
    }

    return 44.0f;
}

/** 按钮标题 */
- (NSString *)titleForButton {
    return @"上传报装资料";
}

/** 按钮icon */
- (NSString *)iconNameForButton {
    return @"ic_photo";
}

#pragma mark -
/// 上传报装资料
- (void)btnClicked {
    [self showUploadPicker:^(id result) {
        
        [[DQServiceInterface sharedInstance] dq_getUploadNoticeInstall: @(self.projectid) deviceid:@(self.device.deviceid) upLoadImgs:result projectID:@(self.device.projectdeviceid) success:^(id result) {
            [MBProgressHUD hideAllHUDsForView:self.navCtl.view animated:YES];
            
            if (result) {
                [self reloadTableData];
            }
            [_arrDataSources removeAllObjects];
        } failture:^(NSError *error) {
            [_arrDataSources removeAllObjects];
            [self showMessage:@"上传失败"];
        }];
    }];
}

@end
