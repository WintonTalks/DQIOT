//
//  DQSubCommunicateModel.h
//  WebThings
//  前期沟通
//  Created by Heidi on 2017/9/25.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQSubCommunicateModel_h
#define DQSubCommunicateModel_h
#import "DQEnum.h"

#import "DQServiceSubNodeModel.h"

@interface DQSubCommunicateModel : DQServiceSubNodeModel

@property (nonatomic, strong) AddProjectModel *projecthistory; // 项目信息

@end

#endif /* DQSubCommunicateModel_h */
