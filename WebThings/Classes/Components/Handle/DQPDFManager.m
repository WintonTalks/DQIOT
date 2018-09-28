//
//  DQPDFManager.m
//  WebThings
//
//  Created by Heidi on 2017/10/20.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQPDFManager.h"

@implementation DQPDFManager

+ (DQPDFManager *)sharedInstance
{
    static DQPDFManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DQPDFManager alloc] init];
    });
    return sharedInstance;
}


@end
