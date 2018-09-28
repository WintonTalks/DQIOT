//
//  DQSubEvaluateModel.m
//  WebThings
//  服务评价
//  Created by Heidi on 2017/9/25.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQSubEvaluateModel.h"

@implementation DQSubEvaluateModel

+ (NSDictionary *)objectClassInArray {
    
    return @{@"serviceevaluate" : [ServiceevaluateModel class]};
}

- (ServiceevaluateModel *)evaluate {
    if ([_serviceevaluate count] > 0) {
        return _serviceevaluate[0];
    }
    return [[ServiceevaluateModel alloc] init];
}

@end
