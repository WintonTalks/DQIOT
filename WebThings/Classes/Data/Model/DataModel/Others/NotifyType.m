//
//  NotifyType.m
//  WebThings
//
//  Created by machinsight on 2017/7/5.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "NotifyType.h"

@implementation NotifyType
+ (NotifyType *)getType0Model{
    NotifyType *model = [[NotifyType alloc] init];
    model.noticetype = @"故障通知";
    model.image = [UIImage imageNamed:@"notice_ic_fault"];
    model.color = [UIColor colorWithHexString:@"dc4437"];
    return model;
}

+ (NotifyType *)getType1Model{
    NotifyType *model = [[NotifyType alloc] init];
    model.noticetype = @"设备维保";
    model.image = [UIImage imageNamed:@"notice_ic_-maintenance"];
    model.color = [UIColor colorWithHexString:@"dc4437"];
    return model;
}

+ (NotifyType *)getType2Model{
    NotifyType *model = [[NotifyType alloc] init];
    model.noticetype = @"订单确认";
    model.image = [UIImage imageNamed:@"notice_ic_message"];
    model.color = [UIColor colorWithHexString:@"007bc3"];
    return model;
}

+ (NotifyType *)getType3Model{
    NotifyType *model = [[NotifyType alloc] init];
    model.noticetype = @"设备加高";
    model.image = [UIImage imageNamed:@"notice_ic_height"];
    model.color = [UIColor colorWithHexString:@"007bc3"];
    return model;
}

+ (NotifyType *)getType4Model{
    NotifyType *model = [[NotifyType alloc] init];
    model.noticetype = @"设备拆除";
    model.image = [UIImage imageNamed:@"notice_ic_remove"];
    model.color = [UIColor colorWithHexString:@"007bc3"];
    return model;
}

- (UIColor *)returnColor {
    if ([self.noticetype isEqualToString:@"故障通知"]) {
        self.color = [UIColor colorWithHexString:@"dc4437"];
    }else if ([self.noticetype isEqualToString:@"设备维保"]) {
        self.color = [UIColor colorWithHexString:@"#DC4437"];
    }else if ([self.noticetype isEqualToString:@"订单确认"]) {
        self.color = [UIColor colorWithHexString:@"#007BC3"];
    }else if ([self.noticetype isEqualToString:@"设备加高"]) {
        self.color = [UIColor colorWithHexString:@"#007BC3"];
    }else if ([self.noticetype isEqualToString:@"设备拆除"]) {
        self.color = [UIColor colorWithHexString:@"#007BC3"];
    }else{
        self.color =  [UIColor clearColor];
    }
    return self.color;
}

- (UIImage *)returnImg{
    if ([self.noticetype isEqualToString:@"故障通知"]) {
        self.image =  [UIImage imageNamed:@"notice_ic_fault"];
    }else if ([self.noticetype isEqualToString:@"设备维保"]) {
        self.image =  [UIImage imageNamed:@"notice_ic_-maintenance"];
    }else if ([self.noticetype isEqualToString:@"订单确认"]) {
        self.image =  [UIImage imageNamed:@"notice_ic_message"];
    }else if ([self.noticetype isEqualToString:@"设备加高"]) {
        self.image = [UIImage imageNamed:@"notice_ic_height"];
    }else if ([self.noticetype isEqualToString:@"设备拆除"]) {
        self.image =  [UIImage imageNamed:@"notice_ic_remove"];
    }else{
        self.image =  nil;
    }
    return self.image;
}
@end
