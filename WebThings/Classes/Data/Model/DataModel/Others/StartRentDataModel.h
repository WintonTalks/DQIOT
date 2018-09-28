//
//  StartRentDataModel.h
//  WebThings
//
//  Created by machinsight on 2017/7/14.
//  Copyright © 2017年 machinsight. All rights reserved.
//   启租单

#import <Foundation/Foundation.h>
//启租单id:tstartrentid
//isshowbutton:显示确认驳回按钮 0不显示 1显示
//启租时间:startdate
//产权备案号:recordno
//检测单位:checkcompany
//检测报告编号:chckreportid
//发起启租人员:{  startrentuser:
//    人员id:userid
//    人员名称:name
//    人员职务:usertype
//    人员头像地址:headimg
//    日期:cdate
//    
//}
//确认人员:{confirmuser
//    人员id:user
//    人员名称:name
//    人员职务:usertype
//    人员头像地址:headimg
//    日期:cdate
//}
@interface StartRentDataModel : NSObject
@property (nonatomic,assign) NSInteger tstartrentid;
@property (nonatomic,assign) NSInteger isshowbutton;
@property (nonatomic,strong) NSString *startdate;
@property (nonatomic,strong) NSString *recordno;
@property (nonatomic,strong) NSString *checkcompany;
@property (nonatomic,assign) NSInteger chckreportid;
@property (nonatomic,strong) UserModel *startrentuser;
@property (nonatomic,strong) UserModel *confirmuser;
@end
