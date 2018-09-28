//
//  NotifyDetail.h
//  WebThings
//
//  Created by machinsight on 2017/7/5.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
//通知id:noticeid
//通知标题:title
//通知内容:msg
//通知时间:cdate

@interface NotifyDetail : NSObject
@property (nonatomic, assign) NSInteger noticeid;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSString *cdate;

+ (NotifyDetail *)getModel;
@end
