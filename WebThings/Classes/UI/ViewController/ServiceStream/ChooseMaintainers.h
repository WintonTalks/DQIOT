//
//  ChooseMaintainers.h
//  WebThings
//
//  Created by machinsight on 2017/7/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMIBaseViewController.h"
#import "DeviceModel.h"
@class ChooseMaintainers;

//@protocol ChooseMaintainersDelegate <NSObject>
//
//- (void)didPopWithMaintainersModel:(UserModel *)model;
//
//@end
@interface ChooseMaintainers : EMIBaseViewController
//@property (nonatomic,strong)id<ChooseMaintainersDelegate> delegate;

@property NSString *thistitle;

@property NSInteger projectid;
@property (nonatomic,strong)DeviceModel *dm;


@property (nonatomic, assign) NSInteger billid;//单据id

@property (nonatomic,assign) NSInteger deviceid;
@end
