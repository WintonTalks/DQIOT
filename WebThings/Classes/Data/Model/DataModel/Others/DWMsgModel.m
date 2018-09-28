//
//  DWMsgModel.m
//  WebThings
//
//  Created by machinsight on 2017/7/26.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DWMsgModel.h"
#import "WorkDeskStrConfig.h"

@implementation DWMsgModel

/* 实现该方法，说明数组中存储的模型数据类型 */
+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"users" : @"UserModel",
              @"ivedata":@"IVEDataModel"
              };
    
}

- (UIColor *)returnColor{
    if ([self.noticetype isEqualToString:Notice_GZTZ]) {
        self.color = [UIColor colorWithHexString:@"dc4437"];
    }else if ([self.noticetype isEqualToString:Notice_SBWH]) {
        self.color = [UIColor colorWithHexString:@"#DC4437"];
    }else if ([self.noticetype isEqualToString:Notice_SBWX]) {
        self.color = [UIColor colorWithHexString:@"#DC4437"];
    }else if ([self.noticetype isEqualToString:Notice_DDQR]) {
        self.color = [UIColor colorWithHexString:@"#007BC3"];
    }else if ([self.noticetype isEqualToString:Notice_SBJG]) {
        self.color = [UIColor colorWithHexString:@"#007BC3"];
    }else if ([self.noticetype isEqualToString:Notice_SBCC]) {
        self.color = [UIColor colorWithHexString:@"#007BC3"];
    }else{
        self.color =  [UIColor clearColor];
    }
    return self.color;
}

- (UIImage *)returnImg{
    if ([self.noticetype isEqualToString:Notice_GZTZ]) {
        self.image =  [UIImage imageNamed:@"notice_ic_fault"];
    }else if ([self.noticetype isEqualToString:Notice_SBWH]) {
        self.image =  [UIImage imageNamed:@"notice_ic_-maintenance"];
    }else if ([self.noticetype isEqualToString:Notice_SBWX]) {
        self.image =  [UIImage imageNamed:@"notice_ic_-maintenance"];
    }else if ([self.noticetype isEqualToString:Notice_DDQR]) {
        self.image =  [UIImage imageNamed:@"notice_ic_message"];
    }else if ([self.noticetype isEqualToString:Notice_SBJG]) {
        self.image = [UIImage imageNamed:@"notice_ic_height"];
    }else if ([self.noticetype isEqualToString:Notice_SBCC]) {
        self.image =  [UIImage imageNamed:@"notice_ic_remove"];
    }else{
        self.image =  nil;
    }
    return self.image;
}

- (NSString *)returnBtnTitle{
    if ([self.noticetype isEqualToString:Notice_GZTZ]) {
        self.btnTitle =  @"已完成维修";
    }else if ([self.noticetype isEqualToString:Notice_SBWH]) {
        self.btnTitle =  @"已完成维保";
    }else if ([self.noticetype isEqualToString:Notice_SBWX]) {
        self.btnTitle =  @"已完成维修";
    }else if ([self.noticetype isEqualToString:Notice_DDQR]) {
        self.btnTitle =  @"已完成确认";
    }else if ([self.noticetype isEqualToString:Notice_SBJG]) {
        self.btnTitle =  @"已完成加高";
    }else if ([self.noticetype isEqualToString:Notice_SBCC]) {
        self.btnTitle =  @"已完成拆除";
    }else{
        self.btnTitle =  @"";
    }
    return self.btnTitle;
}
@end
