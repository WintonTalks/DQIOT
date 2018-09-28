//
//  OrderModel.h
//  WebThings
//
//  Created by machinsight on 2017/7/14.
//  Copyright © 2017年 machinsight. All rights reserved.
//  维保单

#import <Foundation/Foundation.h>
//维保单id:orderid:
//    维保开始时间:sdate
//    维保结束时间:edate
//    维保内容:text
@interface OrderModel : NSObject
@property (nonatomic, assign) NSInteger orderid;
@property (nonatomic, strong) NSString *sdate;
@property (nonatomic, strong) NSString *edate;
@property (nonatomic, strong) NSString *text;
@end
