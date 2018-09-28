//
//  DQSubSetupModel.h
//  WebThings
//  设备安装
//  Created by Heidi on 2017/9/25.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQSubSetupModel_h
#define DQSubSetupModel_h
#import "DQEnum.h"

#import "DQServiceSubNodeModel.h"

@interface DQSubSetupModel : DQServiceSubNodeModel

@property (nonatomic, strong) NSArray *msgattachmentList; //图片集合

@end

#endif /* DQSubSetupModel_h */
