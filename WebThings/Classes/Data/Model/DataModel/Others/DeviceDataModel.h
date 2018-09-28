//
//  DeviceDataModel.h
//  WebThings
//
//  Created by machinsight on 2017/7/21.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
//warndata：[{
//    "dataid":"告警ID"，
//    “desc":"告警描述"
//}],
//addhigh:[{
//    "dataid":"加高ID",
//    "desc":"加高多少米"
//}]
@interface DeviceDataModel : NSObject
@property (nonatomic, assign) NSInteger dataid;
@property (nonatomic, strong) NSString *desc;
@end
