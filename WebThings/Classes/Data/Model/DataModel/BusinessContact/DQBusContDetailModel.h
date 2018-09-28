//
//  DQBusContDetailModel.h
//  WebThings
//  商务往来详情数据Model
//  Created by Heidi on 2017/10/20.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQBusContDetailModel_h
#define DQBusContDetailModel_h

#import "DQServiceSubNodeModel.h"
#import "DQBusContListModel.h"

@interface DQBusContDetailModel : NSObject

@property (nonatomic, copy) NSString *enumstatedesc;    // 当前说明
@property (nonatomic, copy) NSString *content;          // 提交的内容
@property (nonatomic, assign) NSInteger enumstateid;
@property (nonatomic, copy) NSString *headimg;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *userid;
@property (nonatomic, copy) NSString *date;         // 检查日期
@property (nonatomic, copy) NSString *ctime;

@property (nonatomic, strong) DQBusContListModel *data;

@end

#endif /* DQBusContDetailModel_h */
