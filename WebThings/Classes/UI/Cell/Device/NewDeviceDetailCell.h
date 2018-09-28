//
//  NewDeviceDetailCell.h
//  WebThings
//
//  Created by machinsight on 2017/6/23.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMIBaseTableViewCell.h"
#import "DeviceModel.h"
@class NewDeviceDetailCell;
@protocol NewDeviceDetailCellDelegate <NSObject>

@required
- (void)cellBtnClicked:(DeviceModel *)model;//保存按钮点击


@end
@interface NewDeviceDetailCell : EMIBaseTableViewCell

@property (weak, nonatomic) IBOutlet MDButton *saveBtn;/**< 保存按钮*/
@property (nonatomic,weak) id<NewDeviceDetailCellDelegate> delegate;

@property (nonatomic,strong)DeviceModel *m;

@property (nonatomic,assign)NSInteger projectid;//项目id，VC传来
/**
 给设备品牌列表赋值

 @param dataArray 值
 */
- (void)setSbppData:(NSMutableArray *)dataArray;

/**
 给设备型号列表赋值
 
 @param dataArray 值
 */
- (void)setSbxhData:(NSMutableArray *)dataArray;

- (void)setViewWithDeviceValues:(DeviceModel *)model;

- (BOOL)judgeIsInfoFull;
@end
