//
//  DQSubCommunicateModel.m
//  WebThings
//  前期沟通
//  Created by Heidi on 2017/9/25.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQSubCommunicateModel.h"

@implementation DQSubCommunicateModel

- (BOOL)isUnfold {
    return NO;
}

- (id)copyWithZone:(NSZone *)zone {
    DQSubCommunicateModel *model= [super copyWithZone:zone];
    model.projecthistory = self.projecthistory;
    
    return model;
}

@end
