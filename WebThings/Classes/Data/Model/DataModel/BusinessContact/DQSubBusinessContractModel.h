//
//  DQSubBusinessContractModel.h
//  WebThings
//  按照业务站组织的商务往来数据Model
//  Created by Heidi on 2017/10/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQSubBusinessContractModel_h
#define DQSubBusinessContractModel_h

#import "DQBusContDetailModel.h"
#import "DQServiceSubNodeModel.h"
#import "DQBusinessContractModel.h"

@interface DQSubBusinessContractModel : DQServiceSubNodeModel

@property (nonatomic, copy) NSString *telephone;/** 电话 */
@property (nonatomic, copy) NSString *startDate;/** 开始日期 */
@property (nonatomic, copy) NSString *endDate;/** 结束日期*/

@property (nonatomic, copy) NSString *expend;/** 配件消耗 */
@property (nonatomic, copy) NSString *reuslt;/** 整改结果 */
@property (nonatomic, copy) NSString *desc;/** 整改描述*/

@property (nonatomic, strong) NSArray *imgLists;            // 图片集合, [@"", @""]
@property (nonatomic, strong) NSArray *works;               // 人员列表

@end

#endif /* DQSubBusinessContractModel_h */
