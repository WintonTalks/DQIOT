//
//  CheckModel.m
//  WebThings
//
//  Created by machinsight on 2017/7/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "CheckModel.h"

@implementation CheckModel
- (UIColor *)getColor{
    if ([self.checkstate isEqualToString:@"正常"]) {
        return [UIColor colorWithHexString:@"#5F91F1"];
    }else if([self.checkstate isEqualToString:@"待修复"]){
        return [UIColor colorWithHexString:@"#D92700"];
    }else if([self.checkstate isEqualToString:@"已修复"]){
        return [UIColor colorWithHexString:@"#90A722"];
    }else{
        return [UIColor colorWithHexString:@"#8F9091"];
    }
}

- (CGFloat)cellForHeight
{
    if (!self.checktype) {
        return 46.f;
    }
    CGSize size = [AppUtils textSizeFromTextString:self.checktype width:183 height:150 font:[UIFont dq_semiboldSystemFontOfSize:14]];
    return size.height > 46 ? size.height : 46;
}

@end
