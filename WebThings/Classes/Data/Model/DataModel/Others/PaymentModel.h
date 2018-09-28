//
//  PaymentModel.h
//  WebThings
//
//  Created by machinsight on 2017/7/14.
//  Copyright © 2017年 machinsight. All rights reserved.
//  费用清算

#import <Foundation/Foundation.h>
//进出场费:inoutprice
////    司机工资:driverrent
////    租金:rent
@interface PaymentModel : NSObject
@property (nonatomic, assign) double inoutprice;
@property (nonatomic, assign) double driverrent;
@property (nonatomic, assign) double rent;
@end
