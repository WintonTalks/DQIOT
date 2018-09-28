//
//  AddDriverViewController.h
//  WebThings
//
//  Created by machinsight on 2017/6/22.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMIBaseViewController.h"
#import "NewDriverDetailCell.h"
#import "DeviceModel.h"
@class AddDriverViewController;
@protocol AddDriverViewControllerDelegate <NSObject>
- (void)didPopWithDriverDics:(NSArray <DriverModel *> *)drivers;

@end
@interface AddDriverViewController : EMIBaseViewController

/**
 0新增司机
 1修改司机
 */
@property (nonatomic, assign) int isNew;

@property (nonatomic,strong) NewDriverDetailCell *detailCell;

@property (nonatomic,  weak) id<AddDriverViewControllerDelegate> delegate;

@property (nonatomic, strong) NSMutableArray <DriverModel *> *dataArr;

@property (nonatomic, assign) NSInteger isfromServiceStream;//是否来自服务流 1是

@property (nonatomic, strong) DeviceModel *dm;
@property (nonatomic, assign) NSInteger projectid;
@end
