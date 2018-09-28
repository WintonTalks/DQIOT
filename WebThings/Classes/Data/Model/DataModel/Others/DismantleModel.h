//
//  DismantleModel.h
//  WebThings
//
//  Created by machinsight on 2017/7/14.
//  Copyright © 2017年 machinsight. All rights reserved.
//  停租单

#import <Foundation/Foundation.h>
//停租单id：dismantleid
////    停租时间：cdate
@interface DismantleModel : NSObject
@property (nonatomic, assign) NSInteger dismantleid;
@property (nonatomic, strong) NSString *cdate;
@end
