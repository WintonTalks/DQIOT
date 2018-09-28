//
//  NotifyDetailViewController.h
//  WebThings
//
//  Created by machinsight on 2017/7/5.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMIBaseViewController.h"

@interface NotifyDetailViewController : EMIBaseViewController
@property(nonatomic,strong)NSString *thisTitle;

- (void)fetchList;

@end
