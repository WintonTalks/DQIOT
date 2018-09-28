//
//  DQAddWorkUserController.h
//  WebThings
//
//  Created by winton on 2017/10/25.
//  Copyright © 2017年 machinsight. All rights reserved.
//  选择工作人员

#import "EMIBaseViewController.h"
typedef void (^DQAddWorkUserDataBlock) (NSMutableArray *userList);

typedef NS_ENUM(NSInteger, DQAddWorkUserType) {
    KDQAddWorkUserRadioStyle, //单选  负责人
    KDQAddWorkUserManyStyle  //多选  维修人员
};

@interface DQAddWorkUserController : EMIBaseViewController
@property (nonatomic, assign) NSInteger projectID;
@property (nonatomic) DQAddWorkUserType type;
@property (nonatomic,   copy) DQAddWorkUserDataBlock userDataBlock;
@end
