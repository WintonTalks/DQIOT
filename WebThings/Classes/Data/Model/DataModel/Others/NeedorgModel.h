//
//  NeedorgModel.h
//  WebThings
//
//  Created by machinsight on 2017/7/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//  承租方

#import <Foundation/Foundation.h>
//承租方id:orgid
//承租方名称:orgname

@interface NeedorgModel : NSObject
@property (nonatomic, assign) NSInteger orgid;
@property (nonatomic, strong) NSString *orgname;
@end
