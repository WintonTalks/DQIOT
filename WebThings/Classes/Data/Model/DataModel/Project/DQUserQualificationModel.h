//
//  DQUserQualificationModel.h
//  WebThings
//
//  Created by winton on 2017/10/22.
//  Copyright © 2017年 machinsight. All rights reserved.
//  资质记录


#import <Foundation/Foundation.h>

@interface DQUserQualificationModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger workerid;
@property (nonatomic, strong) NSString *credentials;
@property (nonatomic, assign) CGFloat height;
@end
