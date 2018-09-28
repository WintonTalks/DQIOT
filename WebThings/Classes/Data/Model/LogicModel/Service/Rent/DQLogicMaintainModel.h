//
//  DQLogicMaintainModel.h
//  WebThings
//  服务流维修逻辑处理类
//  Created by Heidi on 2017/9/26.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQLogicMaintainModel_h
#define DQLogicMaintainModel_h

#import "DQLogicServiceBaseModel.h"
#import "DeviceMaintainorderModel.h"// 设备维保单,维修单，加高单，拆除单

@interface DQLogicMaintainModel : DQLogicServiceBaseModel 

/** 是否显示箭头 */
@property (nonatomic, assign) BOOL canExpend;

/** 是否可编辑 */
@property (nonatomic, assign) BOOL isFoldWorkerList;

/** 工作人员个数 */
@property (nonatomic, strong) NSArray *workerAry;

/** 维保、维修、加高等申请表的高度 */
@property (nonatomic, assign) NSInteger applyFormHeight;


/** 设备订单 维修、维保、加高单数据（三者合一） */
@property (nonatomic, strong) DeviceMaintainorderModel *devieceOrderModel;

@end

#endif /* DQLogicMaintainModel_h */
