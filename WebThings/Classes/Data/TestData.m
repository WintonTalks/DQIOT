//
//  TestData.m
//  WebThings
//
//  Created by Henry on 2017/8/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "TestData.h"

@implementation TestData

+ (DailyModel *)getDailyModel
{
    DailyModel *model = [[DailyModel alloc] init];
    model.date = @"2017/07/28";
    NSMutableArray *array = [NSMutableArray array];
    for(int i=0;i<10;i++){
        CheckModel *checkModel = [[CheckModel alloc] init];
        checkModel.checktype = @"检测项";
        checkModel.checkstate = @"正常";
        [array safeAddObject:checkModel];
    }
    model.data = array;
    return model;
}

+ (NSArray *)getIves
{
    NSArray *array = @[@"处理方法1",@"处理方法2",@"处理方法3",];
    return array;
}

+(DeviceModel *)getDeviceModel{
    DeviceModel *device = [[DeviceModel alloc] init];
    device.deviceno = @"TD0003";
    device.address = @"南通市中南世纪城";
    return device;
}
@end
