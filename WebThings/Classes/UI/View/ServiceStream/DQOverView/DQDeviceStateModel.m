//
//  DQDeviceStateModel.m
//  WebThings
//
//  Created by Eugene on 25/09/2017.
//  Copyright © 2017 machinsight. All rights reserved.
//

#import "DQDeviceStateModel.h"

@implementation DQDeviceStateModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
    
        if (self = [super init]) {
            
            [self setValuesForKeysWithDictionary:dictionary];
        }
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    
    if ([value isKindOfClass:[NSNull class]]) {
        return;
    }
    
    [super setValue:value forKey:key];
}


@end
