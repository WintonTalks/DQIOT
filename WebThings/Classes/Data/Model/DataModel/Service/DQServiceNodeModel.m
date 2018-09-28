//
//  DQServiceNodeModel.m
//  WebThings
//  服务流(业务站)根节点数据
//  Created by Heidi on 2017/9/25.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQServiceNodeModel.h"

@implementation DQServiceNodeModel

- (DQFlowType)nodeIndex {
    
    return [AppUtils nodeIndexWithTypeName:_flowtype];
}

- (NSString *)name {
    return _flowtype;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\nname=[%@],canClick=[%d],isfinish=[%d]\n",
            _name, _canclick ? 1 : 0, _isfinish ? 1 : 0];
}

@end
