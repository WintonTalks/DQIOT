//
//  GetDriversModel.h
//  WebThings
//
//  Created by machinsight on 2017/7/14.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DriverModel.h"
//是否用户自己找司机 ismyselfdriver:
//司机:[{ drivers:
//    司机姓名:name
//    身份证号:idcard
//    联系电话:dn
//    工资类型：（月工资、包干工资）renttype
//    工资:rent
//    安全教育是否完成:issafeteach
//}]
//人员:{user：
//    人员id：userid
//    人员名称:name
//    人员职务:usertype
//    人员头像地址:headimg
//    日期:cdate
//}
//isshowbutton:显示确认驳回按钮 0不显示 1显示
//确认人员:{ confirmdriveruser
//    人员id:userid
//    人员名称:name
//    人员职务:usertype
//    人员头像地址:headimg
//    日期:cdate
//    
//}

@interface GetDriversModel : NSObject
@property (nonatomic, assign) NSInteger ismyselfdriver;
@property (nonatomic, strong) NSArray <DriverModel *> *drivers;
@property (nonatomic, strong) UserModel *user;
@property (nonatomic, assign) NSInteger isshowbutton;
@property (nonatomic, strong) UserModel *confirmdriveruser;
@end
