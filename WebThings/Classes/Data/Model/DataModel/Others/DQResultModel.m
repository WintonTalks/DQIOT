//
//  DQResultModel.m
//  WebThings
//
//  Created by Heidi on 2017/9/7.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQResultModel.h"

@implementation DQResultModel

- (BOOL)isRequestSuccess
{
    return self.success == 1;
}

- (NSString *)msg {
    return [NSObject changeType:_failinfor.length > 0 ? _failinfor : _msg];
}

// 打印此类对象时，现实的格式如下
- (NSString *)description
{
    return [NSString stringWithFormat:@"\nsuccess=[%ld], data=[%@], list=[%@]\n",
            (long)_success, _data, _list];
}

@end
