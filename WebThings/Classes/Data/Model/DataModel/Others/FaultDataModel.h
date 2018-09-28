//
//  FaultDataModel.h
//  WebThings
//
//  Created by machinsight on 2017/7/26.
//  Copyright © 2017年 machinsight. All rights reserved.
//  获取常规故障

#import <Foundation/Foundation.h>
#import "WarningModel.h"
//data:[{
//detail:[{
//warnid:
//warnname:
//}]
//    typeid:类型ID
//    typename：类型名称
//}]
@interface FaultDataModel : NSObject
@property (nonatomic, strong) NSArray *detail;
@property (nonatomic, assign) NSInteger typeid;
@property (nonatomic, strong) NSString *typename;

@end
