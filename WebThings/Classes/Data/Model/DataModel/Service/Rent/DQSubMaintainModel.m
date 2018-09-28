//
//  DQSubMaintainModel.m
//  WebThings
//  设备维保
//  Created by Heidi on 2017/9/25.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQSubMaintainModel.h"

@implementation DQSubMaintainModel

- (id)copyWithZone:(NSZone *)zone {
    
    DQSubMaintainModel *model= [super copyWithZone:zone];
    model.devicerepairorder = self.devicerepairorder;
    model.deivieaddheight = self.deivieaddheight;
    model.deviceMaintainorder = self.deviceMaintainorder;
    
    return model;
}

@end
