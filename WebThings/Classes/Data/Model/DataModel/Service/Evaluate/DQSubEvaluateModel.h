//
//  DQSubEvaluateModel.h
//  WebThings
//  服务评价
//  Created by Heidi on 2017/9/25.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQSubEvaluateModel_h
#define DQSubEvaluateModel_h
#import "DQEnum.h"

#import "DQServiceSubNodeModel.h"
#import "ServiceevaluateModel.h"

@interface DQSubEvaluateModel : DQServiceSubNodeModel

@property (nonatomic, strong) NSArray<ServiceevaluateModel *> *serviceevaluate; //服务评价
/** 取一条评论来显示 */
@property (nonatomic, strong) ServiceevaluateModel *evaluate;

@end

#endif /* DQSubEvaluateModel_h */
