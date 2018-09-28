//
//  DQSubRentModel.m
//  WebThings
//  设备启租
//  Created by Heidi on 2017/9/25.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQSubRentModel.h"
#import "ProjectStartRentHistoryModel.h"

@implementation DQSubRentModel

- (id)copyWithZone:(NSZone *)zone {
    DQSubRentModel *model= [super copyWithZone:zone];
    model.projectstartrenthistory = self.projectstartrenthistory;
    model.devicerepairorder = self.devicerepairorder;
    model.deivieaddheight = self.deivieaddheight;
    model.dismantledevice = self.dismantledevice;

    return model;
}

@end
