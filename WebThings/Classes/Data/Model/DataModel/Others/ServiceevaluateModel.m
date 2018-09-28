//
//  ServiceevaluateModel.m
//  WebThings
//
//  Created by machinsight on 2017/8/8.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ServiceevaluateModel.h"

@implementation ServiceevaluateModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}

- (NSDictionary *)dq_apiParams {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setObject:[NSString stringWithFormat:@"%ld", _type] forKey:@"type"];
    [dict setObject:[NSObject changeType:_note] forKey:@"assess"];
    [dict setObject:[NSObject changeType:_projectid] forKey:@"projectid"];
    [dict setObject:[NSObject changeType:_deviceid] forKey:@"deviceid"];
    [dict setObject:[NSObject changeType:_linkid] forKey:@"linkid"];
    if (_workerid.length > 0) {
        [dict setObject:[NSObject changeType:_workerid] forKey:@"workerid"];
    }
    if (_pleased > 0) {
        [dict setObject:[NSString stringWithFormat:@"%ld", _pleased] forKey:@"pleased"];
    }
    if (_complete > 0) {
        [dict setObject:[NSString stringWithFormat:@"%ld", _complete] forKey:@"complete"];
    }
    if (_skill > 0) {
        [dict setObject:[NSString stringWithFormat:@"%ld", _skill] forKey:@"skill"];
    }
    if (_service > 0) {
        [dict setObject:[NSString stringWithFormat:@"%ld", _service] forKey:@"service"];
    }
    if (_state > 0) {
        [dict setObject:[NSString stringWithFormat:@"%ld", _state] forKey:@"state"];
    }
    if (_old > 0) {
        [dict setObject:[NSString stringWithFormat:@"%ld", _old] forKey:@"old"];
    }

    return dict;
}

@end
