//
//  OperationFactory.h
//  WebThings
//
//  Created by Henry on 2017/7/31.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OperationDelegate.h"

@interface OperationFactory : NSObject

+(id <OperationDelegate>)factory:(NSString *)type;
@end
