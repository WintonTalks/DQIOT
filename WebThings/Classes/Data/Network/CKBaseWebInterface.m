//
//  CKBaseWebInterface.m
//  WebThings
//
//  Created by machinsight on 2017/7/11.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "CKBaseWebInterface.h"

@implementation CKBaseWebInterface
- (id)unBox:(id)param{
    NSMutableArray *arr = [NSMutableArray array];
    NSInteger suc = [[param objectForKey:@"success"] integerValue];
    [arr addObject:@(suc)];
    if (suc == 1) {
        //成功
        
    }else{
        NSString *failinfor = [param objectForKey:@"failinfor"];
        if (failinfor) {
            [arr addObject:failinfor];
            MDSnackbar *t = [[MDSnackbar alloc] initWithText:failinfor actionTitle:@"" duration:3.0];
            [t show];
        }
        
    }
    return arr;
}

@end
