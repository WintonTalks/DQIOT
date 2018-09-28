//
//  DQEvaluateListModel.h
//  WebThings
//
//  Created by winton on 2017/10/27.
//  Copyright © 2017年 machinsight. All rights reserved.
//  评价列表

#import <Foundation/Foundation.h>

@interface DQEvaluateListModel : NSObject
@property (nonatomic, strong) NSString *asess;
@property (nonatomic, strong) NSString *cheadimg;
@property (nonatomic, assign) NSInteger cuserid;
@property (nonatomic, assign) NSInteger pleased;
@property (nonatomic, assign) NSInteger projectid;
@property (nonatomic, assign) NSInteger complete;
@property (nonatomic, assign) NSInteger service;
@property (nonatomic, assign) NSInteger skill;
@property (nonatomic, strong) NSString *cname;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *headimg;
@end

