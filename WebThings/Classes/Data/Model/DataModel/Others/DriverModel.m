//
//  DriverModel.m
//  WebThings
//
//  Created by machinsight on 2017/7/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DriverModel.h"

@implementation DriverModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _photoList = [NSMutableArray new];
    }
    return self;
}

//- (void)setPhotoList:(NSMutableArray *)photoList
//{
//    for (id obj in photoList) {
//        [_photoList safeAddObject:obj];
//    }
//}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}

/**
 *  当字典转模型完毕时调用
 */
- (void)mj_keyValuesDidFinishConvertingToObject
{
    if (!self.credentials.length) {
        return;
    }
    NSMutableString *picString = [NSMutableString stringWithFormat:@"%@",self.credentials];
    if ([picString dq_rangeOfStringWithLocation:@","]) {
        NSArray *compleArr = [picString componentsSeparatedByString:@","];
        _photoList = compleArr.mutableCopy;
    } else {
        [_photoList safeAddObject:picString];
    }
}

@end
