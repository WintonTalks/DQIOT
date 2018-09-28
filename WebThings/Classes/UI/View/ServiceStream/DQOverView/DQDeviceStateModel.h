//
//  DQDeviceStateModel.h
//  WebThings
//
//  Created by Eugene on 25/09/2017.
//  Copyright © 2017 machinsight. All rights reserved.
//  设备的运行状态，故障、正常以及总设备数模型

#import <Foundation/Foundation.h>

@interface DQDeviceStateModel : NSObject

@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger failureCount;
@property (nonatomic, assign) NSInteger normalCount;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
