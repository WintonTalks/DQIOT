//
//  NSObject+NSNullExpande.m
//  JPSDK
//
//  Created by 孙文强 on 17/3/14.
//  Copyright © 2017年 com.eju.jp. All rights reserved.
//

#import "NSObject+NSNullExpande.h"

@implementation NSObject (NSNullExpande)

+(id)changeType:(id)obj
{
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return [self nullDic:obj];
    } else if ([obj isKindOfClass:[NSArray class]]) {
        return [self nullArr:obj];
    } else if ([obj isKindOfClass:[NSString class]]) {
        return [self stringToString:obj];
    } else if ([obj isKindOfClass:[NSNull class]] || !obj) {
        return [self nullToString];
    } else {
        return obj;
    }
}

+ (NSDictionary *)nullDic:(NSDictionary *)infoDic
{
    NSArray *keyArr = [infoDic allKeys];
    NSMutableDictionary *resDic = [NSMutableDictionary new];
    for (int i = 0; i < keyArr.count; i++) {
        id obj = [infoDic objectForKey:[keyArr safeObjectAtIndex:i]];
        obj = [self changeType:obj];
        [resDic setObject:obj forKey:[keyArr safeObjectAtIndex:i]];
    }
    return resDic;
}

+ (NSArray *)nullArr:(NSArray *)infoArr
{
    NSMutableArray *resArr = [NSMutableArray new];
    for (int i = 0; i < infoArr.count; i++) {
        id obj = [infoArr safeObjectAtIndex:i];
        obj = [self changeType:obj];
        [resArr safeAddObject:obj];
    }
    return resArr;
}

+ (NSString *)stringToString:(NSString *)string
{
    if ([string isKindOfClass:[NSNull class]] ||
        string == nil) {
        return @"";
    }
    return string;
}

+ (NSString *)nullToString
{
  return @"";
}

@end
