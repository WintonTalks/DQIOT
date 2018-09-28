//
//  DQAddNewUserController.h
//  WebThings
//
//  Created by winton on 2017/9/30.
//  Copyright © 2017年 machinsight. All rights reserved.
//  添加人员

#import "EMIBaseViewController.h"
@class DriverModel;
@class DQAddNewUserController;
@protocol DQAddNewUserControllerDelegate <NSObject>
- (void)didConfigUserClicked:(DQAddNewUserController *)newUserVC;
@end

typedef NS_ENUM(NSInteger, DQAddNewUserWithType) {
    KDQAddNewUserAddNewStyle, //新增用户
    KDQModifyUserAddNewStyle  //修改用户
};

@interface DQAddNewUserController : EMIBaseViewController
@property (nonatomic,   weak) id<DQAddNewUserControllerDelegate>delegate;
@property (nonatomic, assign) NSInteger projectID;
@property (nonatomic) DQAddNewUserWithType type;
@property (nonatomic, strong) NSString *projectname; //所属项目
@property (nonatomic, strong) DriverModel *userModel;
@end
