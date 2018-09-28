//
//  DQEvaluationViewController.h
//  WebThings
//
//  Created by 孙文强 on 2017/10/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//  人员评价/评价

#import "EMIBaseViewController.h"

typedef NS_ENUM(NSInteger, DQEvaluationType) {
  KDQEvaluationDeriveStyle, //评价
  KDQEvaluationPersonStyle  //人员评价
};

@interface DQEvaluationViewController : EMIBaseViewController
@property (nonatomic) DQEvaluationType type;
@property (nonatomic, assign) NSInteger projectID;
@property (nonatomic, assign) NSInteger workerid;
@property (nonatomic, strong) NSString *name; //人员评价 名字
@end
