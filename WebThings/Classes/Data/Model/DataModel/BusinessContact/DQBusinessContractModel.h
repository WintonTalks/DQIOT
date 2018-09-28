//
//  DQBusinessContractModel.h
//  WebThings
//  接口返回的商务往来数据Model
//  Created by Heidi on 2017/10/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQBusinessContractModel_h
#define DQBusinessContractModel_h

#import "DQBusContDetailModel.h"

@interface DQBusinessContractModel : NSObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *businessID;
@property (nonatomic, copy) NSString *headimg;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *ctime;
@property (nonatomic, strong) NSArray *detail;

@end

#endif /* DQBusinessContractModel_h */
