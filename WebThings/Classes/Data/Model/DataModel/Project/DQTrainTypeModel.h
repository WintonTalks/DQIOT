//
//  DQTrainTypeModel.h
//  WebThings
//
//  Created by winton on 2017/10/21.
//  Copyright © 2017年 machinsight. All rights reserved.
//  人员培训类型列表

#import <Foundation/Foundation.h>

@interface DQTrainTypeModel : NSObject
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) NSInteger typeid;

@end

/*
 “typeid”:”培训类型id”,
 “type”:”培训类型”
 */
