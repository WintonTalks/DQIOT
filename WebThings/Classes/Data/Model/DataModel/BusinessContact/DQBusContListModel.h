//
//  DQBusContListModel.h
//  WebThings
//  商务往来整改完成单数据Model
//  Created by Heidi on 2017/10/20.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQBusContListModel_h
#define DQBusContListModel_h

#import "DQServiceSubNodeModel.h"

@interface DQBusContListModel : NSObject

//  imgs: "/upload/c602971d-986e-4425-a3c4-19d60cf7cf55.jpg,/upload/e90b0330-8bf8-455c-89c2-90efd5db0d39.jpg"
@property (nonatomic, copy) NSString *busID;
@property (nonatomic, copy) NSString *imgs;
@property (nonatomic, copy) NSString *result;
@property (nonatomic, copy) NSString *des;
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *expend;
@property (nonatomic, copy) NSString *type;     // “租赁商”
@property (nonatomic, copy) NSString *usertype; // “项目经理”
@property (nonatomic, copy) NSString *start;   // 开始时间
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *dn;   // 电话号码
@property (nonatomic, copy) NSString *end;  // 结束时间

@property (nonatomic, strong) NSArray *workers;

@end

#endif /* DQBusContListModel_h */
