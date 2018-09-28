//
//  DQUserQualificationModel.m
//  WebThings
//
//  Created by winton on 2017/10/22.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DQUserQualificationModel.h"

@implementation DQUserQualificationModel

/**
 *  当字典转模型完毕时调用
 */
- (void)mj_keyValuesDidFinishConvertingToObject
{
    if (!self.credentials.length) {
        return;
    }
    NSMutableString *picString = [NSMutableString stringWithFormat:@"%@",self.credentials];
    if ([picString dq_rangeOfStringWithLocation:@","]) {
        NSArray *compleArr = [picString componentsSeparatedByString:@","];
        NSInteger count = (compleArr.count%2==0) ? compleArr.count/2 : compleArr.count/2+1;
        _height = 94*(count-1);
    } else {
        _height = 0;
    }
}

@end
