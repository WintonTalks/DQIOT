//
//  EditDeviceViewController.h
//  WebThings
//
//  Created by machinsight on 2017/7/22.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMIBaseViewController.h"
#import "DeviceModel.h"
@class EditDeviceViewController;

@protocol EditDeviceViewControllerDelegate <NSObject>
- (void)didPopWithDevice:(DeviceModel *)device WithIndex:(NSInteger)index;

@end
@interface EditDeviceViewController : EMIBaseViewController
@property (nonatomic,   weak)  id<EditDeviceViewControllerDelegate> delegate;
@property (nonatomic, assign) NSInteger projectid;
//detailstate = 11 需要发送设备确认接口，否则的话不需要
@property (nonatomic, assign) DQEnumState state;
//0有网络请求   1从addDevice过来，无网络请求
@property (nonatomic, assign) NSInteger fromWho;
@property (nonatomic, strong) DeviceModel *dm;
@property (nonatomic, assign) NSInteger index;//记录修改的第几个
@end
