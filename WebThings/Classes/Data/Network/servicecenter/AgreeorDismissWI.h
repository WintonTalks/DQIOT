//
//  AgreeorDismissWI.h
//  WebThings
//
//  Created by machinsight on 2017/7/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//  同意驳回

#import "CKBaseWebInterface.h"

//EventType
static NSString *QQGT_JCGTD = @"前期沟通_进场沟通单";
static NSString *SBBZ_BZZL = @"设备报装_报装资料";
static NSString *SBAZ_XCJSJD = @"设备安装_现场技术交底";
static NSString *SBAZ_AZPZ = @"设备安装_安装凭证";
static NSString *SBAZ_DSFYSPZ = @"设备安装_第三方验收凭证";
static NSString *SBQZ_QZD = @"设备启租_启租单";
static NSString *SJQR = @"司机确认";
static NSString *SBWH = @"设备维保";
static NSString *SBWX = @"设备维修";
static NSString *SBJG = @"设备加高";
static NSString *SBCC = @"拆除设备";

//yesorno
static NSString *Agree = @"通过";
static NSString *Refuse = @"驳回";
@interface AgreeorDismissWI : CKBaseWebInterface

@end
