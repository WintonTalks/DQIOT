//
//  IVEDataModel.h
//  WebThings
//
//  Created by machinsight on 2017/8/29.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IVEDataModel : NSObject
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) NSInteger TypeID;
@end
