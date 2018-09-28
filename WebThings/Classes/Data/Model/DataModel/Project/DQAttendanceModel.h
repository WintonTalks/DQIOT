//
//  DQAttendanceModel.h
//  WebThings
//
//  Created by winton on 2017/10/29.
//  Copyright © 2017年 machinsight. All rights reserved.
//  考勤

#import <Foundation/Foundation.h>

@interface DQAttendanceModel : NSObject
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, assign) NSInteger lng;
@property (nonatomic, assign) NSInteger lat;

@end

/*
 time”:”打卡时间,精确到秒”,
 “location”:”打卡地点”
 “lng”:”经度”,
 “lat”:”纬度”

 */
