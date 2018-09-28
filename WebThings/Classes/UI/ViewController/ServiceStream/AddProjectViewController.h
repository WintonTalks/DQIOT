//
//  AddProjectViewController.h
//  WebThings
//
//  Created by machinsight on 2017/6/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMIBaseViewController.h"
#import "AddProjectModel.h"

@interface AddProjectViewController : EMIBaseViewController
/**
 0新增项目
 1修改醒目
 */
@property (nonatomic, assign) int isNew;

@property (nonatomic, strong) AddProjectModel *pmodel;//传过来的项目
@property (nonatomic, assign) NSInteger newProjectId;//新项目id
@end
