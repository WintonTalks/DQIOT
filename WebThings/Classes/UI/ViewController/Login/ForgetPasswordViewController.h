//
//  ForgetPasswordViewController.h
//  WebThings
//
//  Created by machinsight on 2017/7/20.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMIBaseViewController.h"

typedef NS_ENUM(NSInteger, ForgetPasswordType) {
    KForgetPasswordVerifyStyle, //忘记密码
    KForgetPasswordModifyStyle  //修改密码
};

@interface ForgetPasswordViewController : EMIBaseViewController

@property (nonatomic) ForgetPasswordType type;

@end
