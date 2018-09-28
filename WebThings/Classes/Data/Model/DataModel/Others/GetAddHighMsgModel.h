//
//  GetAddHighMsgModel.h
//  WebThings
//
//  Created by machinsight on 2017/7/14.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HignModel.h"
//{ 加高单:{highorder:
//    加高单id:highid
//    加高开始时间:sdate
//    加高结束时间:edate
//    加高米数:high
//}
//    创建加高单人员：createuser
//    {
//        人员id:userid
//        人员名称:name
//        人员职务:usertype
//        人员头像地址:headimg
//        日期:cdate
//    }
//isshowbutton:显示费用已缴清和未缴清0不显示 1显示
//    是否确认时间发起加高 ifconfirmsdate:
//    确认时间发起加高人员:{ confirmsdateuser:
//        人员id:userid
//        人员名称:type
//        人员职务:usertype
//        人员头像地址:headimg
//        日期:cdate
//        
//    }
//    是否完成加高 isfinsh:
//    发起完成加高人员：{finshuser:
//        人员id:userid
//        人员名称:name
//        人员职务:usertype
//        人员头像地址:headimg
//        日期:cdate
//        
//    }
//    是否确认完成加高：confirmfinsh:
//    确认完成加高人员：{confirmfinshuser
//        人员id:userid
//        人员名称:name
//        人员职务:usertype
//        人员头像地址:headimg
//        日期:cdate
//        
//    }}…]
@interface GetAddHighMsgModel : NSObject
@property (nonatomic, strong) HignModel *highorder;
@property (nonatomic, strong) UserModel *createuser;
@property (nonatomic, assign) NSInteger isshowbutton;
@property (nonatomic, assign) NSInteger isconfirmsdate;
@property (nonatomic, strong) UserModel *confirmsdateuser;
@property (nonatomic, assign) NSInteger isfinsh;
@property (nonatomic, strong) UserModel *finshuser;
@property (nonatomic, assign) NSInteger isconfirmfinsh;
@property (nonatomic, strong) UserModel *confirmfishuser;
@end
