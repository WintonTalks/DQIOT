//
//  DQAttendanceListModel.h
//  WebThings
//
//  Created by winton on 2017/10/29.
//  Copyright © 2017年 machinsight. All rights reserved.
//  考勤记录

#import <Foundation/Foundation.h>

@interface DQAttendanceListModel : NSObject
@property (nonatomic, assign) NSInteger workerid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger checkincount;
@property (nonatomic, assign) NSInteger totalcount;

@end

/*
 workerid”:”人员id”,
 “name”:”姓名”,
 “checkincount”:”打卡次数”,
 “totalcount”:”应打卡次数”
 }…]
 */
