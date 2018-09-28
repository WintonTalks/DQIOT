//
//  ServiceCommentViewController.h
//  WebThings
//
//  Created by machinsight on 2017/7/4.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMIBaseViewController.h"
#import "DeviceModel.h"

@interface ServiceCommentViewController : EMIBaseViewController
@property (nonatomic, strong) DeviceModel *dm;
@property (nonatomic, assign) NSInteger projectid;
@end
