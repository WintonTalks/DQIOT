//
//  NotifyType.h
//  WebThings
//
//  Created by machinsight on 2017/7/5.
//  Copyright © 2017年 machinsight. All rights reserved.
//  通知类型

#import <Foundation/Foundation.h>
//通知类型:noticetype
//租赁方名称:orgname
//项目名称:projectname
//时间:cdate
//消息数量:msgcount

@interface NotifyType : NSObject
@property (nonatomic, strong) NSString *noticetype;
@property (nonatomic, strong) NSString *orgname;
@property (nonatomic, strong) NSString *projectname;
@property (nonatomic, strong) NSString *cdate;
@property (nonatomic, assign) NSInteger msgcount;

@property (nonatomic, strong) NSString *model;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) NSInteger projectid;
@property (nonatomic, assign) NSInteger deviceid;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIColor *color;

+ (NotifyType *)getType0Model;

+ (NotifyType *)getType1Model;

+ (NotifyType *)getType2Model;

+ (NotifyType *)getType3Model;

+ (NotifyType *)getType4Model;


- (UIColor *)returnColor;

- (UIImage *)returnImg;
@end
