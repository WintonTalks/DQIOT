//
//  DQBaseModel.m
//  WebThings
//
//  Created by Heidi on 2017/9/7.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQBaseModel.h"

@implementation DQBaseModel

// 空值异常处理
- (void)setValue:(id)value forKey:(NSString *)key {
    
    if (!key || [key isEqualToString:@""]) {
        NSAssert((nil == key || [key isEqualToString:@""]), @"key->为空，或不存在");
        return;
    }
    
    if (value == nil) {
        [super setValue:@"" forKey:key];
        NSAssert((value == nil), @"value->不存在");
        
    } else {
        
        [super setValue:value forKey:key];
    }
}

@end
