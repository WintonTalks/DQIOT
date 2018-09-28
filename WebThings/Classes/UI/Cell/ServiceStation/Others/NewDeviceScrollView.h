//
//  NewDeviceScrollView.h
//  WebThings
//
//  Created by machinsight on 2017/7/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewDeviceScrollView;
@class DeviceModel;

@protocol  NewDeviceScrollViewDelegate<NSObject>
- (void)didSelectValue:(id)value withSelf:(NewDeviceScrollView *)sender witnIndex:(NSInteger)index;
@end

@interface NewDeviceScrollView : UIView

@property (nonatomic, weak) id<NewDeviceScrollViewDelegate> delegate;

- (void)showWithFatherV:(UIView *)fatherV;

- (void)disshow;

- (void)setData:(NSMutableArray *)data;
@property (nonatomic, strong) NSMutableArray  *dataList;
@end

//tag
//0 NewDeviceDetailCell 品牌
//1 NewDeviceDetailCell 编号
//1000  DriversWriteDiaryViewController 设备
//2000 DriverDiaryDetailCell （正常，已修复，待修复）
///3000 DriverBaoGuZViewController (项目经理)
///4000 DriverBaoGuZViewController (故障列表)

///5000 AddProjectViewController 新增项目 承租方项目经理列表
///7000  添加人员-工种 
///9527 项目管理-下拉权限允许
///9566 项目管理-培训

