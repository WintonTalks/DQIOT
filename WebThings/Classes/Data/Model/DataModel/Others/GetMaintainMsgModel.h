//
//  GetMaintainMsgModel.h
//  WebThings
//
//  Created by machinsight on 2017/7/14.
//  Copyright © 2017年 machinsight. All rights reserved.
//  获取维保信息

#import <Foundation/Foundation.h>
#import "OrderModel.h"
//data:[{维保单:{ order:
//    维保单id:orderid:
//    维保开始时间:sdate
//    维保结束时间:edate
//    维保内容:text
//}
//    创建维保单人员：createuser
//    {
//        人员id:userid
//        人员名称:name
//        人员职务:usertype
//        人员头像地址:headimg
//        日期：cdate
//    }
//isshowbutton:显示已确认并发起维保 0不显示 1显示
//    是否确认时间发起维保 isconfirmsdate:
//    确认时间发起维保人员:{ confirmsdateuser
//        人员id：userid
//        人员名称：name
//        人员职务：usertype
//        人员头像地址：headimg
//        日期：cdate
//        
//    }
//    是否完成维保 isfinsh
//    发起完成维保人员：{finshuser
//        人员id：userid
//        人员名称:name
//        人员职务:usertype
//        人员头像地址:headimg
//        日期:cdate
//        
//    }
//    是否确认完成维保：isconfirmfinsh:
//    完成维保人员：{confirmfishuser
//        人员id:user
//        人员名称:name
//        人员职务:usertype
//        人员头像地址:headimg
//        日期:cdate
//        
//    }}…]
@interface GetMaintainMsgModel : NSObject
@property (nonatomic, strong) OrderModel *order;
@property (nonatomic, strong) UserModel *createuser;
@property (nonatomic, assign) NSInteger isshowbutton;
@property (nonatomic, assign) NSInteger isconfirmsdate;
@property (nonatomic, strong) UserModel *confirmsdateuser;
@property (nonatomic, assign) NSInteger isfinsh;
@property (nonatomic, strong) UserModel *finshuser;
@property (nonatomic, assign) NSInteger isconfirmfinsh;
@property (nonatomic, strong) UserModel *confirmfishuser;
@end
