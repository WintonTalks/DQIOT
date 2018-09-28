//
//  CK_ID_NameModel.h
//  WebThings
//
//  Created by machinsight on 2017/7/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CK_ID_NameModel : NSObject
@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, strong) NSString *cname;

@property (nonatomic, strong) NSArray <UserModel *> *pm;
@end
