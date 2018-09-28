//
//  DeviceTypeModel.m
//  WebThings
//
//  Created by machinsight on 2017/7/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DeviceTypeModel.h"

@implementation DeviceTypeModel

- (NSString *)description {
    return [NSString stringWithFormat:@"\nmodelid=[%ld],model=[%@],count=[%ld],brand=[%@],deviceid=[%ld],price=[%@],iswarn=[%@]\n",
            _modelid, _model, _count, _brand, _deviceid, _price, _iswarn];
}

- (BOOL)isWarning {
    BOOL isBroken = NO;
    if ([NSObject changeType:_iswarn]) {
        isBroken = [_iswarn isEqualToString:@"是"];
    }
    return isBroken;
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([NSString isEmpty:oldValue]) {// 以字符串类型为例
        return  @"";
    }
    return oldValue;
}

@end
