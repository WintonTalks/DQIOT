//
//  UserModel.h
//  WebThings
//
//  Created by machinsight on 2017/7/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
//用户id:userid
//用户类型:type 承租商（need）租赁商（provide）
//用户名称:name
//手机号码:dn
//职位:usertype(需要注意一下 usertype是职位不是用户类型) CEO PM CPM
//头像:headimg
//公司名称:orgname
//性别:sex
//身份证号:idcard
//地区:district
//公司id:orgid

@interface UserModel : NSObject
@property (nonatomic,assign) NSInteger userid;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *dn;
@property (nonatomic,strong) NSString *usertype;
@property (nonatomic,strong) NSString *headimg;
@property (nonatomic,strong) NSString *orgname;
@property (nonatomic    ,strong) NSString *sex;
@property (nonatomic,strong) NSString *idcard;
@property (nonatomic,strong) NSString *district;
@property (nonatomic,assign) NSInteger orgid;
@property (nonatomic,strong) NSString *cdate;

@property (nonatomic,assign) NSInteger ID;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,assign) NSInteger state;
@property (nonatomic,assign) NSInteger notdisturb;
@property (nonatomic,strong) NSString *isread;
@property (nonatomic,strong) NSString *confirmresult;
@property (nonatomic,assign) NSInteger orgtype;

@property (nonatomic,assign) BOOL isSelected;//是否选中

// Add by Heidi 用来判断用户类型
@property (nonatomic, assign) BOOL isZuLin;     // 是否是租赁商
@property (nonatomic, assign) BOOL isCEO;       // 是否是CEO

@end
