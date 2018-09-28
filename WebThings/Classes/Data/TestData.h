//
//  TestData.h
//  WebThings
//
//  Created by Henry on 2017/8/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DailyModel.h"
#import "DeviceModel.h"
@interface TestData : NSObject

+(DailyModel *)getDailyModel;
+(NSArray *)getIves;
+(DeviceModel *)getDeviceModel;
@end
