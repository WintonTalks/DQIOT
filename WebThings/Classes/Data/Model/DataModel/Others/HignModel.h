//
//  HignModel.h
//  WebThings
//
//  Created by machinsight on 2017/7/14.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
//加高单id:highid
////    加高开始时间:sdate
////    加高结束时间:edate
////    加高米数:high
@interface HignModel : NSObject
@property (nonatomic, assign) NSInteger highid;
@property (nonatomic, strong) NSString *sdate;
@property (nonatomic, strong) NSString *edate;
@property (nonatomic, assign) double high;
@end
