//
//  GetDismantleMsgModel.h
//  WebThings
//
//  Created by machinsight on 2017/7/14.
//  Copyright © 2017年 machinsight. All rights reserved.
//  1、	获取拆机信息


#import <Foundation/Foundation.h>
#import "DismantleModel.h"
#import "PaymentModel.h"
//停租单:{dismantle
//    停租单id：dismantleid
//    停租时间：cdate
//}
//创建停租单人员：dismantleuser
//{
//    人员id:userid
//    人员名称:name
//    人员职务:usertype
//    人员头像地址:headimg
//    日期:cdate
//}
//是否缴清费用 paymentisfinsh
//确认费用未缴清人员:{ confirmpaymentisnotfinshuser:
//    人员id:userid
//    人员名称:name
//    人员职务:usertype
//    人员头像地址:headimg
//    日期:cdate
//}
//确认费用已缴清人员:{confirmpaymentisfinshuser
//    人员id:userid
//    人员名称:name
//    人员职务:usertype
//    人员头像地址:headimg
//    日期:cdate
//}
//
//费用清算：{payment
//    进出场费:inoutprice
//    司机工资:driverrent
//    租金:rent
//}
//是否确认完成加高：isconfirmaddhighfinsh:
//确认完成加高人员：{ confirmaddhighfinshuser:
//    人员id:userid
//    人员名称:name
//    人员职务:usertype
//    人员头像地址:headimg
//    日期:cdate
//    
//}

@interface GetDismantleMsgModel : NSObject
@property (nonatomic, strong) DismantleModel *dismantle;
@property (nonatomic, strong) UserModel *dismantleuser;
@property (nonatomic, assign) NSInteger paymentisfinsh;
@property (nonatomic, strong) UserModel *confirmpaymentisnotfinshuser;
@property (nonatomic, strong) UserModel *confirmpaymentisfinshuser;
@property (nonatomic, strong) PaymentModel *payment;
@property (nonatomic, assign) NSInteger isconfirmaddhighfinsh;
@property (nonatomic, strong) UserModel *confirmaddhighfinshuser;
@end
