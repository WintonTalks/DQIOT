//
//  DQSubRemoveModel.m
//  WebThings
//  设备拆除
//  Created by Heidi on 2017/9/25.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQSubRemoveModel.h"

@implementation DQSubRemoveModel

- (id)copyWithZone:(NSZone *)zone {
    DQSubRemoveModel *model= [super copyWithZone:zone];
    model.pricelist = self.pricelist;
    model.dismantledevice = self.dismantledevice;
    
    return model;
}

@end
