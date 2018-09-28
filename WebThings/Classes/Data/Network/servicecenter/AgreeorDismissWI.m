//
//  AgreeorDismissWI.m
//  WebThings
//
//  Created by machinsight on 2017/7/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "AgreeorDismissWI.h"

@implementation AgreeorDismissWI
- (instancetype)init{
    self = [super init];
    if (self) {
        self.fullUrl = appendUrl(httpUrl, @"/agreeordismiss.do");
    }
    return self;
}

- (id)inBox:(id)param{
    NSDictionary *dic = @{@"userid":param[0],@"type":param[1],@"eventtype":param[2],@"yesorno":param[3],@"projectid":param[4],@"deviceid":param[5],@"billid":param[6],@"projectdeviceid":param[7],@"usertype":param[8]};
    //事件类型:eventtype:无关联  前期沟通项目详情 启租单 附件 司机清单 设备维保 加高
    //同意还是驳回:yesorno:通过   驳回//是或者否
    return dic;
}

- (id)unBox:(id)param{
    NSMutableArray *arr = [super unBox:param];
    if ([arr[0] integerValue] == 1) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"操作成功" actionTitle:@"" duration:3.0];
        [t show];
    }
    return arr;
    
}
@end
