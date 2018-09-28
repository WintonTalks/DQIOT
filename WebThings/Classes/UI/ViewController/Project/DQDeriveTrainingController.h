//
//  DQDeriveTrainingController.h
//  WebThings
//
//  Created by winton on 2017/9/30.
//  Copyright © 2017年 machinsight. All rights reserved.
//  培训

#import "EMIBaseViewController.h"

@interface DQDeriveTrainingController : EMIBaseViewController
@property (nonatomic, strong) NSString *name; //培训人的姓名
@property (nonatomic, assign) NSInteger projectID; //项目ID
@property (nonatomic, assign) NSInteger workerid; //工种ID
@end
