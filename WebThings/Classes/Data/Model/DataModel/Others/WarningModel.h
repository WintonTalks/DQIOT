//
//  WarningModel.h
//  WebThings
//
//  Created by machinsight on 2017/7/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//  设备报警

#import <Foundation/Foundation.h>
//"warncode":"告警码",
//"warndesc":"告警描述",
//"num":"次数"
@interface WarningModel : NSObject
@property (nonatomic,strong) NSString *warncode;
@property (nonatomic,strong) NSString *warndesc;
@property (nonatomic,assign) NSInteger num;


//司机获取故障列表
@property (nonatomic,assign) NSInteger warnid;
@property (nonatomic,strong) NSString *warnname;
@end
