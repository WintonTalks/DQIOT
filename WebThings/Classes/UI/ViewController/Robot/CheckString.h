//
//  CheckString.h
//  WebThings
//
//  Created by Henry on 2017/7/31.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatModel.h"
@protocol OnCheckValueDelegate <NSObject>

-(void)returnValue:(ChatModel *) robotBean;

@end


@interface CheckString : NSObject
+(void)checkValue:(NSString *)message delegate:(id<OnCheckValueDelegate>) delegate;
@end
